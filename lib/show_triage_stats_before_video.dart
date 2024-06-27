import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/buttons.dart';
import 'package:seesaw/main.dart';
import 'package:seesaw/state_model.dart';

import 'db.dart';
import 'poll_data.dart';

class ShowTriageStatsBeforeVideo extends StatefulWidget {
  final String classroomUUID;
  ShowTriageStatsBeforeVideo({super.key, required this.classroomUUID});

  @override
  State createState() => _ShowTriageStatsBeforeVideoState();
}

const animationDuration = Duration(seconds: 1);
const minFontSize = 20;
const maxFontSize = 520;
const lineHeight = 0.78;

class _ShowTriageStatsBeforeVideoState extends State<ShowTriageStatsBeforeVideo> {

  double _responsesYes = 0;
  double _responsesNo = 0;

  void getDataFromFirebase() async {
    var db = TriageCaseStudyDB.instance;
    final PollData pollData = await db.getDecisionCounters(widget.classroomUUID);

    setState(() {
      _responsesYes = pollData.initialYes as double;
      _responsesNo = pollData.initialNo as double;
    });
  }

  @override
  void initState() {
    super.initState();
    getDataFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    double sum = _responsesYes + _responsesNo;
    double percentageYes = sum == 0 ? 0 : _responsesYes / sum;
    double percentageNo = sum == 0 ? 0 : _responsesNo / sum;
    double fontSizeYes = minFontSize + (maxFontSize-minFontSize) * percentageYes; // multiplier * (20 + 100 * percentageYes / 2);
    double fontSizeNo = minFontSize + (maxFontSize-minFontSize) * percentageNo; // multiplier * (20 + 100 * percentageNo / 2);

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
                                fontSize: fontSizeYes,
                                fontWeight: FontWeight.w900,
                                color: preparedCyanColor,
                                decoration: TextDecoration.none),
                            child: const Text('YES', textAlign: TextAlign.end),
                          ),
                          const SizedBox(height: 20),
                          Text('${_responsesYes.round()} yeses',
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
                          AnimatedDefaultTextStyle(
                              duration: animationDuration,
                              style: TextStyle(
                                  height: lineHeight,
                                  fontSize: fontSizeNo,
                                  fontWeight: FontWeight.w900,
                                  color: preparedOrangeColor,
                                  decoration: TextDecoration.none),
                              child: const Text('NO', textAlign: TextAlign.start)
                          ),
                          const SizedBox(height: 20),
                          Text('${_responsesNo.round()} noes',
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
            // Visibility(
            //   visible: kDebugMode,
            //   child: Slider(
            //     value: _responsesYes,
            //     min: 0,
            //     max: 10000,
            //     divisions: 25,
            //     label: '${_responsesYes.round()} YES / ${_responsesNo.round()} NO',
            //     onChanged: (double value) {
            //       setState(() {
            //         _responsesYes = value;
            //         _responsesNo = 10000 - _responsesYes;
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
    Provider.of<StateModel>(context, listen: false).progressToNextSeesawState();
  }
}