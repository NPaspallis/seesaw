import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class AutoTimeoutLayer extends StatefulWidget {

  const AutoTimeoutLayer({super.key});

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
    //todo
    Duration duration = DateTime.timestamp().difference(_lastInteraction);
    debugPrint('...tick... $duration');
    if(duration > const Duration(seconds: timeoutInSeconds)) {
      _handleTrigger();
    }
  }

  void _resetTimer([_]) {
    debugPrint('reset timer');
    _lastInteraction = DateTime.timestamp();
  }

  void _handleTrigger() {
    debugPrint('TRIGGERED!');
    _autoReset(context);
  }

  void _autoReset(BuildContext context) {
    // show the dialog
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: const Text(
              'It seems that nobody is interacting with me...\nResetting in 30 seconds.',
              style: TextStyle(fontSize: textSizeSmall)),
          actions: [
            TextButton(
                onPressed: _cancel,
                child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('CANCEL',
                        style: TextStyle(fontSize: textSizeSmall, fontWeight: FontWeight.bold, color: preparedSecondaryColor)))
            ),
          ],
          elevation: 24.0,
        ));
  }

  void _cancel() {
    _resetTimer();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Gesture detector covering an area of ${MediaQuery.of(context).size.width} x ${MediaQuery.of(context).size.height}');
    return GestureDetector(
      onTap: _resetTimer,
      onPanDown: _resetTimer,
      onScaleStart: _resetTimer,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height
      ),
    );
  }
}