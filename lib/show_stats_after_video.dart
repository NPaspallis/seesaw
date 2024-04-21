import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/buttons.dart';
import 'package:seesaw/main.dart';
import 'package:seesaw/state_model.dart';

class ShowStatsAfterVideo extends StatefulWidget {
  const ShowStatsAfterVideo({super.key});

  @override
  State createState() => _ShowStatsAfterVideoState();
}

const multiplierSwitch = 2;
const multiplierAfter = 7;
const lineHeight = 0.78;
const maxHeightSwitchLine = 50.0;

class _ShowStatsAfterVideoState extends State<ShowStatsAfterVideo> {

  double _switchedFromYesToNo = 1;
  double _switchedFromNoToYes = 1;
  double _responsesYesAfter = 1;
  double _responsesNoAfter = 1;

  @override
  void initState() {
    super.initState();
    // todo replace below code with actual value reading from Firebase
    _responsesYesAfter = Random().nextInt(100) as double;
    _responsesNoAfter = 100 - _responsesYesAfter;
    _switchedFromNoToYes = Random().nextInt(_responsesYesAfter.round()) as double;
    _switchedFromYesToNo = Random().nextInt(_responsesNoAfter.round()) as double;
  }

  @override
  Widget build(BuildContext context) {

    double fontSizeNoToYes = min(multiplierSwitch * (10 + 0.1 * _switchedFromNoToYes), maxHeightSwitchLine);
    double fontSizeYesToNo = min(multiplierSwitch * (10 + 0.1 * _switchedFromYesToNo), maxHeightSwitchLine);
    double percentageNoToYes = _switchedFromNoToYes / (_switchedFromNoToYes + _switchedFromYesToNo);
    double percentageYesToNo = _switchedFromYesToNo / (_switchedFromNoToYes + _switchedFromYesToNo);

    double sumAfter = _responsesYesAfter + _responsesNoAfter;
    double fontSizeYesAfter = multiplierAfter * (20 + 100 * _responsesYesAfter / sumAfter / 2);
    double fontSizeNoAfter = multiplierAfter * (20 + 100 * _responsesNoAfter / sumAfter / 2);
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
                                  fontSize: fontSizeYesAfter,
                                  fontWeight: FontWeight.w900,
                                  color: preparedCyanColor,
                                  decoration: TextDecoration.none)),

                          const SizedBox(height: 20),

                          Container(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text('${_responsesYesAfter.round()} yes\'s',
                                style: const TextStyle(
                                    fontSize: textSizeSmall,
                                    fontWeight: FontWeight.bold,
                                    color: preparedCyanColor,
                                    decoration: TextDecoration.none))
                          ),

                          const SizedBox(height: 20),

                          Container(
                            height: maxHeightSwitchLine,
                            padding: const EdgeInsets.only(right: 10),
                            child: Text('${_switchedFromNoToYes == 0 ? 'none' : _switchedFromNoToYes.round()} changed their answer to YES',
                                style: TextStyle(
                                    height: lineHeight,
                                    fontSize: fontSizeNoToYes,
                                    fontWeight: FontWeight.bold,
                                    color: preparedDarkCyanColor,
                                    decoration: TextDecoration.none)),
                          ),

                          const SizedBox(height: 10),

                          Container(
                            height: 4,
                            width: percentageNoToYes * MediaQuery.of(context).size.width / 2,
                            color: preparedDarkCyanColor,
                          ),
                        ],
                      ),
                    ),

                    // const SizedBox(width: 20),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('NO',
                              style: TextStyle(
                                  height: lineHeight,
                                  fontSize: fontSizeNoAfter,
                                  fontWeight: FontWeight.w900,
                                  color: preparedOrangeColor,
                                  decoration: TextDecoration.none)),


                          const SizedBox(height: 20),

                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('${_responsesNoAfter.round()} no\'s',
                                style: const TextStyle(
                                    fontSize: textSizeSmall,
                                    fontWeight: FontWeight.bold,
                                    color: preparedOrangeColor,
                                    decoration: TextDecoration.none))
                          ),

                          const SizedBox(height: 20),

                          Container(
                            height: maxHeightSwitchLine,
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('${_switchedFromYesToNo == 0 ? 'none' : _switchedFromYesToNo.round()} changed their answer to NO',
                                style: TextStyle(
                                    height: lineHeight,
                                    fontSize: fontSizeYesToNo,
                                    fontWeight: FontWeight.bold,
                                    color: preparedDarkOrangeColor,
                                    decoration: TextDecoration.none)),
                          ),

                          const SizedBox(height: 10),

                          Container(
                            height: 4,
                            width: percentageYesToNo * MediaQuery.of(context).size.width / 2,
                            color: preparedDarkOrangeColor,
                          ),
                        ],
                      ),
                    )
                  ],
                )
            ),
            Visibility(
              visible: kDebugMode,
              child: Slider(
                value: _switchedFromNoToYes,
                min: 0,
                max: 50,
                divisions: 25,
                label: '${_switchedFromNoToYes.round()} switched to YES / ${_switchedFromYesToNo.round()} switched to NO',
                onChanged: (double value) {
                  setState(() {
                    _switchedFromNoToYes = value;
                    _switchedFromYesToNo = 50 - _switchedFromNoToYes;
                  });
                },
              ),
            ),
            Visibility(
              visible: kDebugMode,
              child: Slider(
                value: _responsesYesAfter,
                min: 0,
                max: 100,
                divisions: 25,
                label: '${_responsesYesAfter.round()} YES / ${_responsesNoAfter.round()} NO',
                onChanged: (double value) {
                  setState(() {
                    _responsesYesAfter = value;
                    _responsesNoAfter = 100 - _responsesYesAfter;
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
