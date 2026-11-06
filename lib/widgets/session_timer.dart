import 'dart:async';

import 'package:flutter/material.dart';

class SessionTimer extends StatefulWidget {
  final int secondsPassed;
  final bool isActive;

  const new({super.key, required this.secondsPassed, this.isActive = true});

  @override
  State<SessionTimer> createState() => _SessionTimerState();
}

class _SessionTimerState extends State<SessionTimer> {
  Timer? _timer;
  int counter = 0;

  @override
  void initState() {
    super.initState();

    counter = widget.secondsPassed;

    if (widget.isActive) {
      startTimer();
    }
  }

  void startTimer() {
    if (_timer?.isActive ?? false) return;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          counter++;
        });
      },
    );
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void didUpdateWidget(covariant SessionTimer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isActive != widget.isActive) {
      if (widget.isActive) {
        startTimer();
      } else {
        stopTimer();
      }
    }
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      getFormattedTimer(counter),
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
