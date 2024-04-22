import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AutoTimeoutLayer extends StatefulWidget {

  final Widget child;
  final VoidCallback callback;

  const AutoTimeoutLayer({required this.child, required this.callback, super.key});

  @override
  State<StatefulWidget> createState() => _AutoTimeoutLayerState();
}

const int defaultTimeoutInSeconds = 300; // 5 minutes
const int defaultTimeoutInSecondsInDebugMode = 30; // // in debug mode simply wait for 1/2 minutes
const int timeoutInSeconds = kDebugMode ? defaultTimeoutInSecondsInDebugMode : defaultTimeoutInSeconds;

class _AutoTimeoutLayerState extends State<AutoTimeoutLayer> {

  DateTime _lastInteraction = DateTime.timestamp();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = _timer = Timer.periodic(const Duration(seconds: 1), _handleTick);
    _resetTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _handleTick([_]) {
    Duration duration = DateTime.timestamp().difference(_lastInteraction);
    // debugPrint('...tick... $duration');
    if(duration > const Duration(seconds: timeoutInSeconds)) {
      _handleTrigger();
    }
  }

  void _handleTrigger() {
    debugPrint('TRIGGERED!');
    _resetTimer();
    widget.callback();
  }

  void _resetTimer([_]) {
    _lastInteraction = DateTime.timestamp();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _resetTimer,
      onPanDown: _resetTimer,
      onHorizontalDragEnd: _resetTimer,
      onVerticalDragEnd: _resetTimer,
      behavior: HitTestBehavior.translucent,
      child: widget.child,
    );
  }
}