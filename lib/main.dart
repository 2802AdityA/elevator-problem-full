import 'dart:async';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ElevatorApp(),
    );
  }
}

class ElevatorApp extends StatefulWidget {
  @override
  _ElevatorAppState createState() => _ElevatorAppState();
}

class _ElevatorAppState extends State<ElevatorApp> {
  final List<FloorData> floors = [
    FloorData(floorNumber: 10, value: 10),
    FloorData(floorNumber: 9, value: 9),
    FloorData(floorNumber: 8, value: 8),
    FloorData(floorNumber: 7, value: 7),
    FloorData(floorNumber: 6, value: 6),
    FloorData(floorNumber: 5, value: 5),
    FloorData(floorNumber: 4, value: 4),
    FloorData(floorNumber: 3, value: 3),
    FloorData(floorNumber: 2, value: 2),
    FloorData(floorNumber: 1, value: 1),
  ];
  List<ElevatorData> elevators = [
    ElevatorData(elevatorNumber: 1, location: 3, color: Colors.blue),
    ElevatorData(elevatorNumber: 2, location: 3, color: Colors.yellow),
    ElevatorData(elevatorNumber: 3, location: 3, color: Colors.green),
  ];

  void updateElevatorLocation(int elevatorNumber, int newLocation) {
    setState(() {
      elevators[elevatorNumber - 1].location = newLocation;
    });
  }

  int fromFloor = 0;
  int destination = 0;
  int elevatorToMove = 0;
  void onButtonPressed(BuildContext context) {
    if (fromFloor > 10 ||
        fromFloor < 1 ||
        destination > 10 ||
        destination < 1) {
      Alert(
        context: context,
        title: 'Floor limit exceeded',
        desc: "No floor available",
      ).show();
    } else {
      int minDistance = 11;
      for (var i = 0; i < 3; i++) {
        if ((elevators[i].location - fromFloor).abs() < minDistance) {
          minDistance = (elevators[i].location - fromFloor).abs();
          elevatorToMove = i;
        }
      }
      moveToUser(fromFloor, elevatorToMove);
      scheduleTimeout(2 * 1000);
    }
  }

  Timer scheduleTimeout([int milliseconds = 10000]) =>
      Timer(Duration(milliseconds: milliseconds), handleTimeout);

  void handleTimeout() {
    moveToDestination(destination, elevatorToMove);
  }

  void moveToDestination(int destination, int elevatorNumber) {
    setState(() {
      elevators[elevatorNumber].location = destination;
    });
  }

  void moveToUser(int fromFloor, int elevatorNumber) {
    setState(() {
      elevators[elevatorNumber].location = fromFloor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Elevator App'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                alignment: Alignment.topCenter,
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'From Floor'),
                      onChanged: (value) {
                        setState(() {
                          fromFloor = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Destination'),
                      onChanged: (value) {
                        setState(() {
                          destination = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        onButtonPressed(context);
                      },
                      child: Text('Move Elevator'),
                    ),
                  )
                ])),
            Expanded(
                child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        floors.map((floor) => BuildingFloor(floor)).toList(),
                  ),
                ),
                Expanded(
                  child: BuildingElevator(elevators[0]),
                ),
                Expanded(
                  child: BuildingElevator(elevators[1]), //elevator 1
                ),
                Expanded(
                  child: BuildingElevator(elevators[2]), //elevator 1
                ),
              ],
            ))
          ],
        ));
  }
}

class ElevatorData {
  final int elevatorNumber;
  int location;
  Color color;

  ElevatorData(
      {required this.elevatorNumber,
      required this.location,
      required this.color});
}

class BuildingElevator extends StatelessWidget {
  final ElevatorData elevatorData;

  const BuildingElevator(this.elevatorData);

  @override
  Widget build(BuildContext context) {
    final int position = elevatorData.location > 5
        ? 10 - elevatorData.location + 1
        : elevatorData.location;

    final double elevatorPosition = (10 - (2 * position - 1)) * 50.0;

    Color color = elevatorData.color;
    return Container(
      width: 50,
      height: 50,
      margin: EdgeInsets.only(
        top: elevatorData.location <= 5 ? elevatorPosition : 0,
        bottom: elevatorData.location > 5 ? elevatorPosition : 0,
      ),
      decoration: BoxDecoration(
        border: Border.all(),
        color: color,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${elevatorData.elevatorNumber}'),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class FloorData {
  final int floorNumber;
  final int value;

  FloorData({required this.floorNumber, required this.value});
}

class BuildingFloor extends StatelessWidget {
  final FloorData floorData;

  const BuildingFloor(this.floorData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 50.0,
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Floor ${floorData.floorNumber}'),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
