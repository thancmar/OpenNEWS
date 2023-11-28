import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final String futureTime; // The future time in String format

  CountdownTimer({required this.futureTime});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late Duration _duration;

  @override
  void initState() {
    super.initState();
    // Convert the time string to a DateTime object
    DateTime futureDateTime = DateTime.parse(widget.futureTime);
    // Calculate the duration between the current time and the future time
    _duration = futureDateTime.difference(DateTime.now());
    // Start a periodic Timer that rebuilds the widget every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // When the countdown is over, cancel the timer
      if (_duration.inSeconds == 0) {
        _timer.cancel();
      } else {
        // Otherwise, decrement the duration by one second and update the state
        setState(() {
          _duration -= Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Format the duration into a readable string
    String formattedDuration = "${_duration.inHours}:${_duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${_duration.inSeconds.remainder(60).toString().padLeft(2, '0')}";

    // Build the widget with the countdown timer text
    return Text(
      "Time left: $formattedDuration",
      style: TextStyle(fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w200), // Style as needed
    );
  }
}