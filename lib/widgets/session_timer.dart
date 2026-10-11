import 'dart:async';

import 'package:flutter/material.dart';

class SessionTimer extends StatefulWidget {
  const new({super.key});

  @override
  State<SessionTimer> createState() => _SessionTimerState();
}

class _SessionTimerState extends State<SessionTimer> {
  Timer? _timer;
  int counter = 0;

  @override
  void initState() {
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
    return Text(getFormattedTimer(counter));
  }

  String getFormattedTimer(int counter) {
    String formattedSeconds = '';
    String formattedMinutes = '';

    // 181
    // 1 minute = 60 seconds

    // (counter / 60).toInt()
    // 1 = 01
    // 2 = 01
    // 11 = 11

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