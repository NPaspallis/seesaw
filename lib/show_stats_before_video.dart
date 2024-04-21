import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/buttons.dart';
import 'package:seesaw/main.dart';
import 'package:seesaw/state_model.dart';

class ShowStatsBeforeVideo extends StatefulWidget {
  const ShowStatsBeforeVideo({super.key});

  @override
  State createState() => _ShowStatsBeforeVideoState();
}

const multiplier = 7;
const lineHeight = 0.78;

class _ShowStatsBeforeVideoState extends State<ShowStatsBeforeVideo> {

  double _responsesYes = 1;
  double _responsesNo = 1;

  @override
  void initState() {
    super.initState();
    // todo replace below code with actual value reading from Firebase
    _responsesYes = Random().nextInt(100) as double;
    _responsesNo = 100 - _responsesYes;
  }

  @override
  Widget build(BuildContext context) {
    double sum = _responsesYes + _responsesNo;
    double fontSizeYes = multiplier * (20 + 100 * _responsesYes / sum / 2);
    double fontSizeNo = multiplier * (20 + 100 * _responsesNo / sum / 2);
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 2 / 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('YES',
                              style: TextStyle(
                                  height: lineHeight,
                                  fontSize: fontSizeYes,
                                  fontWeight: FontWeight.w900,
                                  color: preparedCyanColor,
                                  decoration: TextDecoration.none), textAlign: TextAlign.end),

                          const SizedBox(height: 20),
                          Text('${_responsesYes.round()} yes\'s',
                              style: const TextStyle(
                                  fontSize: textSizeSmall,
                                  fontWeight: FontWeight.bold,
                                  color: preparedCyanColor,
                                  decoration: TextDecoration.none)),
                        ],
                      ),
                    ),

                    const SizedBox(width: 20),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('NO',
                              style: TextStyle(
                                  height: lineHeight,
                                  fontSize: fontSizeNo,
                                  fontWeight: FontWeight.w900,
                                  color: preparedOrangeColor,
                                  decoration: TextDecoration.none), textAlign: TextAlign.start),

                          const SizedBox(height: 20),
                          Text('${_responsesNo.round()} no\'s',
                              style: const TextStyle(
                                  fontSize: textSizeSmall,
                                  fontWeight: FontWeight.bold,
                                  color: preparedOrangeColor,
                                  decoration: TextDecoration.none)),
                        ],
                      ),
                    )
                  ],
                )
            ),
            Visibility(
              visible: kDebugMode,
              child: Slider(
                value: _responsesYes,
                min: 0,
                max: 100,
                divisions: 25,
                label: '${_responsesYes.round()} YES / ${_responsesNo.round()} NO',
                onChanged: (double value) {
                  setState(() {
                    _responsesYes = value;
                    _responsesNo = 100 - _responsesYes;
                  });
                },
              ),
            ),
            getOutlinedButton(context, "CARRY ON", carryOn)
          ],
        ));
  }

  void carryOn() {
    debugPrint('carryOn');
    Provider.of<StateModel>(context, listen: false).progressToNextSeesawState();
  }
}
