import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'main.dart';

class TimedBackground extends StatefulWidget {

  final VoidCallback callback;
  final Color backgroundColor;
  final Color shadingColor;
  final int screenRatio;

  const TimedBackground(this.callback, {super.key, this.backgroundColor = preparedPrimaryColor, this.shadingColor = preparedShadeColor, this.screenRatio = 1});

  @override
  State<TimedBackground> createState() => _TimedBackgroundState();
}

const int stepInMilliseconds = 20;

class _TimedBackgroundState extends State<TimedBackground> {

  final int delayInMilliseconds = (kDebugMode ? 10 : 30) * 1000; // 30 seconds

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
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / widget.screenRatio,
          color: widget.backgroundColor
        ),
        Container(
          width: MediaQuery.of(context).size.width * _elapsedTimeMilliseconds / delayInMilliseconds,
          height: MediaQuery.of(context).size.height / widget.screenRatio,
          color: widget.shadingColor
        ),
      ],
    );
  }
}