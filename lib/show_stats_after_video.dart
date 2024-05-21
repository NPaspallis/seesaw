import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/buttons.dart';
import 'package:seesaw/main.dart';
import 'package:seesaw/state_model.dart';

import 'db.dart';
import 'poll_data.dart';

class ShowStatsAfterVideo extends StatefulWidget {
  const ShowStatsAfterVideo({super.key});

  @override
  State createState() => _ShowStatsAfterVideoState();
}

const animationDuration = Duration(seconds: 1);
const minFontSize = 20;
double maxFontSize = 420;
const minHeightSwitchLine = 18.0;
const maxHeightSwitchLine = 50.0;
const lineHeight = 0.78;

class _ShowStatsAfterVideoState extends State<ShowStatsAfterVideo> {

  double _switchedFromYesToNo = 0;
  double _switchedFromNoToYes = 0;
  double _responsesYesAfter = 0;
  double _responsesNoAfter = 0;

  void getDataFromFirebase() async {

    var db = RECCaseStudyDB.instance;
    final PollData pollData = await db.getDecisionCounters();

    setState(() {
      _responsesYesAfter = pollData.finalYes as double;
      _responsesNoAfter = pollData.finalNo as double;
      _switchedFromNoToYes = pollData.switchedToYes as double;
      _switchedFromYesToNo = pollData.switchedToNo as double;
    });
  }

  @override
  void initState() {
    super.initState();
    getDataFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    maxFontSize = MediaQuery.of(context).size.height * 3/8; // todo confirm

    double sumSwitch = _switchedFromNoToYes + _switchedFromYesToNo;
    double percentageNoToYes = sumSwitch == 0 ? 0 : _switchedFromNoToYes / sumSwitch;
    double percentageYesToNo = sumSwitch == 0 ? 0 : _switchedFromYesToNo / sumSwitch;
    double fontSizeNoToYes = minHeightSwitchLine + (maxHeightSwitchLine-minHeightSwitchLine) * percentageNoToYes;
    double fontSizeYesToNo = minHeightSwitchLine + (maxHeightSwitchLine-minHeightSwitchLine) * percentageYesToNo;

    double sumAfter = _responsesYesAfter + _responsesNoAfter;
    double percentageYesAfter = sumAfter == 0 ? 0 : _responsesYesAfter / sumAfter;
    double percentageNoAfter = sumAfter == 0 ? 0 : _responsesNoAfter / sumAfter;
    double fontSizeYesAfter = minFontSize + (maxFontSize-minFontSize) * percentageYesAfter;
    double fontSizeNoAfter = minFontSize + (maxFontSize-minFontSize) * percentageNoAfter;
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
                          AnimatedDefaultTextStyle(
                            duration: animationDuration,
                            style: TextStyle(
                                height: lineHeight,
                                fontSize: fontSizeYesAfter,
                                fontWeight: FontWeight.w900,
                                color: preparedCyanColor,
                                decoration: TextDecoration.none),
                            child: const Text('YES'),
                          ),

                          const SizedBox(height: 20),

                          Container(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text('${_responsesYesAfter.round()} yeses',
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
                            child: AnimatedDefaultTextStyle(
                              duration: animationDuration,
                              style: TextStyle(
                                  height: lineHeight,
                                  fontSize: fontSizeNoToYes,
                                  fontWeight: FontWeight.bold,
                                  color: preparedDarkCyanColor,
                                  decoration: TextDecoration.none),
                              child: Text('${_switchedFromNoToYes == 0 ? 'none' : _switchedFromNoToYes.round()} changed their answer to YES'),
                            )
                          ),

                          const SizedBox(height: 10),

                          AnimatedContainer(
                            duration: animationDuration,
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
                          AnimatedDefaultTextStyle(
                            duration: animationDuration,
                            style: TextStyle(
                                height: lineHeight,
                                fontSize: fontSizeNoAfter,
                                fontWeight: FontWeight.w900,
                                color: preparedOrangeColor,
                                decoration: TextDecoration.none),
                            child: const Text('NO')
                          ),

                          const SizedBox(height: 20),

                          Container(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text('${_responsesNoAfter.round()} noes',
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
                            child: AnimatedDefaultTextStyle(
                              duration: animationDuration,
                              style: TextStyle(
                                  height: lineHeight,
                                  fontSize: fontSizeYesToNo,
                                  fontWeight: FontWeight.bold,
                                  color: preparedDarkOrangeColor,
                                  decoration: TextDecoration.none),
                              child: Text('${_switchedFromYesToNo == 0 ? 'none' : _switchedFromYesToNo.round()} changed their answer to NO')
                            )
                          ),

                          const SizedBox(height: 10),

                          AnimatedContainer(
                            duration: animationDuration,
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
            // Visibility(
            //   visible: kDebugMode,
            //   child: Slider(
            //     value: _switchedFromNoToYes,
            //     min: 0,
            //     max: 1000,
            //     divisions: 50,
            //     label: '${_switchedFromNoToYes.round()} switched to YES / ${_switchedFromYesToNo.round()} switched to NO',
            //     onChanged: (double value) {
            //       setState(() {
            //         _switchedFromNoToYes = value;
            //         _switchedFromYesToNo = 1000 - _switchedFromNoToYes;
            //       });
            //     },
            //   ),
            // ),
            // Visibility(
            //   visible: kDebugMode,
            //   child: Slider(
            //     value: _responsesYesAfter,
            //     min: 0,
            //     max: 1000,
            //     divisions: 25,
            //     label: '${_responsesYesAfter.round()} YES / ${_responsesNoAfter.round()} NO',
            //     onChanged: (double value) {
            //       setState(() {
            //         _responsesYesAfter = value;
            //         _responsesNoAfter = 1000 - _responsesYesAfter;
            //       });
            //     },
            //   ),
            // ),
            getOutlinedButton(context, "CARRY ON", carryOn)
          ],
        ));
  }

  void carryOn() {
    debugPrint('carryOn');
    // Provider.of<StateModel>(context, listen: false).progressToNextSeesawState();
    Provider.of<StateModel>(context, listen: false).setSeesawState(SeesawState.thankYou); // bypass evaluation
  }
}