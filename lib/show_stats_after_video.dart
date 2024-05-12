import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/buttons.dart';
import 'package:seesaw/main.dart';
import 'package:seesaw/participant_entry.dart';
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

  int _responsesYesBefore = 0;
  int _responsesNoBefore = 0;

  int _responsesYesAfter = 0;
  int _responsesNoAfter = 0;

  int _switchedFromYesToNo = 0;
  int _switchedFromNoToYes = 0;

  getResponses() async {

    _responsesNoBefore = 0;
    _responsesYesBefore = 0;
    _responsesYesAfter = 0;
    _responsesNoAfter = 0;
    _switchedFromNoToYes = 0;
    _switchedFromYesToNo = 0;

    var snapshot = await FirebaseFirestore.instance
        .collection(ParticipantEntry.name)
        .get();

    for (DocumentSnapshot doc in snapshot.docs) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = doc as DocumentSnapshot<Map<String, dynamic>>;
      ParticipantEntry entry = ParticipantEntry.fromDocumentSnapshot(snapshot);

      if (entry.pollEntry != null) {

        //Compute initial decision
        if (entry.pollEntry!.initialDecision!) {
          _responsesYesBefore++;
        }
        else {
          _responsesNoBefore++;
        }

        if (entry.pollEntry!.finalDecision != null) {
          //Compute final decision
          if (entry.pollEntry!.finalDecision!) {
            _responsesYesAfter++;
          }
          else {
            _responsesNoAfter++;
          }

          //Compute change from yes to no:
          if (entry.pollEntry!.initialDecision! == true && entry.pollEntry!.finalDecision! == false) {
            _switchedFromYesToNo++;
          }

          //Compute change from no to yes:
          if (entry.pollEntry!.initialDecision! == false && entry.pollEntry!.finalDecision! == true) {
            _switchedFromNoToYes++;
          }
        }

      }

    }
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: getResponses(),
      builder: (context, snapshot) {

        if (snapshot.hasError) {

          debugPrint(snapshot.error.toString());
          debugPrint((snapshot.error as Error).stackTrace.toString());

          return Center(
            child: Column(
              children: [
                const Icon(Icons.error, size: 60, color: Colors.white,),
                const SizedBox(height: 20,),
                const Text("An error occurred while reading data from the server. Please try again.", style: TextStyle(color: Colors.white),),
                const SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () {
                    setState(() { });
                  },
                  child: const Text("Try again"),
                )
              ],
            ),
          );
        }
        else {
          if (snapshot.connectionState == ConnectionState.done) {


            double fontSizeNoToYes = min(multiplierSwitch * (10 + 0.1 * _switchedFromNoToYes), maxHeightSwitchLine);
            double fontSizeYesToNo = min(multiplierSwitch * (10 + 0.1 * _switchedFromYesToNo), maxHeightSwitchLine);
            double percentageNoToYes = _switchedFromNoToYes / (_switchedFromNoToYes + _switchedFromYesToNo);
            double percentageYesToNo = _switchedFromYesToNo / (_switchedFromNoToYes + _switchedFromYesToNo);

            int sumAfter = _responsesYesAfter + _responsesNoAfter;
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
                      visible: false, //was previously kDebugMode
                      child: Slider(
                        value: _switchedFromNoToYes as double,
                        min: 0,
                        max: 100,
                        divisions: 50,
                        label: '${_switchedFromNoToYes.round()} switched to YES / ${_switchedFromYesToNo.round()} switched to NO',
                        onChanged: (double value) {
                          setState(() {
                            _switchedFromNoToYes = value as int;
                            _switchedFromYesToNo = 100 - _switchedFromNoToYes;
                          });
                        },
                      ),
                    ),
                    Visibility(
                      visible: kDebugMode,
                      child: Slider(
                        value: _responsesYesAfter as double,
                        min: 0,
                        max: 100,
                        divisions: 25,
                        label: '${_responsesYesAfter.round()} YES / ${_responsesNoAfter.round()} NO',
                        onChanged: (double value) {
                          setState(() {
                            _responsesYesAfter = value as int;
                            _responsesNoAfter = 100 - _responsesYesAfter;
                          });
                        },
                      ),
                    ),
                    getOutlinedButton(context, "CARRY ON", carryOn)
                  ],
                ));
          }
          else {
            return const CircularProgressIndicator();
          }
        }
      },
    );


  }

  void carryOn() {
    debugPrint('carryOn');
    Provider.of<StateModel>(context, listen: false).progressToNextSeesawState();
  }
}
