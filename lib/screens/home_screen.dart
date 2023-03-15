import 'dart:async';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
// 리스타트 만들기 리셋아이콘/ 재시작

class _HomeScreenState extends State<HomeScreen> {
  static const twentyFiveMinutes = 1500;
  int totalSeconds = twentyFiveMinutes;
  late Timer timer;
  bool isRunning = false;
  int totalPomodoros = 0;

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        isRunning = false;
        totalSeconds = twentyFiveMinutes;
        totalPomodoros++;
      });
      timer.cancel();
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  void onResetPressed() {
    setState(() {
      totalSeconds = twentyFiveMinutes;
    });
    timer.cancel();
  }

  void onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void onStartPressed() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
    setState(() {
      isRunning = true;
    });
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);

    return duration.toString().split(".").first.substring(2, 7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
              flex: 1,
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Text(
                  format(totalSeconds),
                  style: TextStyle(
                    color: Theme.of(context).cardColor,
                    fontSize: 89,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )),
          IconButton(
            color: Theme.of(context).cardColor,
            onPressed: onResetPressed,
            icon: const Icon(Icons.restore),
            iconSize: 50,
          ),
          Flexible(
              flex: 3,
              child: Center(
                child: IconButton(
                  color: Theme.of(context).cardColor,
                  onPressed: isRunning ? onPausePressed : onStartPressed,
                  icon: Icon(
                      isRunning ? Icons.pause_circle_filled_outlined : Icons.play_circle_outline),
                  iconSize: 98,
                ),
              )),
          Flexible(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'POMODOROS',
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).textTheme.headlineSmall!.color,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '$totalPomodoros',
                      style: TextStyle(
                          fontSize: 58,
                          color: Theme.of(context).textTheme.headlineSmall!.color,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
