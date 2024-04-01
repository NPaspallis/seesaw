import 'dart:async';

import 'package:flutter/widgets.dart';

import 'main.dart';

class TimedBackground extends StatefulWidget {

  final VoidCallback callback;

  const TimedBackground(this.callback, {super.key});

  @override
  State<TimedBackground> createState() => _TimedBackgroundState();
}

const int stepInMilliseconds = 20;

class _TimedBackgroundState extends State<TimedBackground> {

  final int delayInMilliseconds = 5 * 1000; // 5 seconds

  late Timer timer;
  int _elapsedTimeMilliseconds = 0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: stepInMilliseconds), (Timer timer) {
      if (_elapsedTimeMilliseconds >= delayInMilliseconds) {
        timer.cancel();
        widget.callback.call();
      } else {
        setState(() => _elapsedTimeMilliseconds += stepInMilliseconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: preparedPrimaryColor,
        ),
        Container(
          width: MediaQuery.of(context).size.width * _elapsedTimeMilliseconds / delayInMilliseconds,
          height: MediaQuery.of(context).size.height,
          color: preparedShadeColor,
        ),
      ],
    );
  }
}