import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Homeapp(),
    );
  }
}

class Homeapp extends StatefulWidget {
  const Homeapp({super.key});

  @override
  State<Homeapp> createState() => _HomeappState();
}

class _HomeappState extends State<Homeapp> {
  int seconds = 0, minutes = 0, hours = 0;
  String digitseconds = '00', digitminutes = "00", digithours = "00";
  Timer? timer;
  bool started = false;
  List<String> laps = [];

  void stop() {
    if (timer != null) {
      timer!.cancel();
    }
    setState(() {
      started = false;
    });
  }

  void reset() {
    if (timer != null) {
      timer!.cancel();
    }
    setState(() {
      seconds = 0;
      minutes = 0;
      hours = 0;

      digitseconds = "00";
      digitminutes = "00";
      digithours = "00";
      started = false;
      laps.clear();
    });
  }

  void addLaps() {
    String lap = "$digithours:$digitminutes:$digitseconds";
    setState(() {
      laps.add(lap);
    });
  }

  void start() {
    started = true;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int localSeconds = seconds + 1;
      int localMinutes = minutes;
      int localHours = hours;

      if (localSeconds > 59) {
        localSeconds = 0;
        localMinutes += 1;
      }

      if (localMinutes > 59) {
        localMinutes = 0;
        localHours += 1;
      }

      setState(() {
        seconds = localSeconds;
        minutes = localMinutes;
        hours = localHours;
        digitseconds = (seconds >= 10) ? "$seconds" : "0$seconds";
        digitminutes = (minutes >= 10) ? "$minutes" : "0$minutes";
        digithours = (hours >= 10) ? "$hours" : "0$hours";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Center(
                child: Text(
                  "STOPWATCH",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 75,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "$digithours:$digitminutes:$digitseconds",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 100,
                  ),
                ),
              ),
              Container(
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  itemCount: laps.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(19.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Lap n°${index + 1}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            laps[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        if (!started) {
                          start();
                        } else {
                          stop();
                        }
                      },
                      fillColor: Colors.grey,
                      shape: const StadiumBorder(
                        side: BorderSide(color: Colors.black),
                      ),
                      child: Text(
                        (!started) ? "Start" : "Pause",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    color: Colors.black,
                    onPressed: addLaps,
                    icon: const Icon(Icons.flag_circle_sharp),
                    iconSize: 50,
                  ),
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: reset,
                      fillColor: Colors.grey,
                      shape: const StadiumBorder(
                        side: BorderSide(color: Colors.black),
                      ),
                      child: const Text(
                        "Reset",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
