import 'dart:async';

import 'package:flutter/material.dart';

class SessionTimer extends StatefulWidget {
  final int secondsPassed;

  const new({
    super.key,
    required this.secondsPassed,
  });

  @override
  State<SessionTimer> createState() => _SessionTimerState();
}

class _SessionTimerState extends State<SessionTimer> {
  Timer? _timer;
  int counter = 0;

  @override
  void initState() {
    counter = widget.secondsPassed;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          counter++;
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      getFormattedTimer(counter),
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  String getFormattedTimer(int counter) {
    String formattedSeconds = '';
    String formattedMinutes = '';

    int remainingMinutes = counter ~/ 60;
    int remainingSeconds = counter % 60;

    formattedMinutes = "$remainingMinutes";
    formattedSeconds = "$remainingSeconds";

    if (remainingMinutes < 10) {
      formattedMinutes = "0$remainingMinutes";
    }

    if (remainingSeconds < 10) {
      formattedSeconds = "0$remainingSeconds";
    }

    return "$formattedMinutes:$formattedSeconds";
  }
}

// starttime of exercise
// what is the current time
// currentTime - startTime = start Timer from here
// 06:00 PM -> Start time
// 06:10 PM -> Current Time
// 10:00

// Hello Shravin!
