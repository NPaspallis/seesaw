import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/buttons.dart';
import 'package:seesaw/main.dart';
import 'package:seesaw/participant_entry.dart';
import 'package:seesaw/poll_entry.dart';
import 'package:seesaw/state_model.dart';

class ShowStatsBeforeVideo extends StatefulWidget {
  const ShowStatsBeforeVideo({super.key});

  @override
  State createState() => _ShowStatsBeforeVideoState();
}

const multiplier = 7;
const lineHeight = 0.78;

class _ShowStatsBeforeVideoState extends State<ShowStatsBeforeVideo> {

  int _responsesYes = 0;
  int _responsesNo = 0;

  getResponses() async {
    _responsesNo = 0;
    _responsesYes = 0;
    var snapshot = await FirebaseFirestore.instance
        .collection(ParticipantEntry.name)
        .get();

    for (DocumentSnapshot doc in snapshot.docs) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = doc as DocumentSnapshot<Map<String, dynamic>>;
      ParticipantEntry entry = ParticipantEntry.fromDocumentSnapshot(snapshot);
      if (entry.pollEntry!.initialDecision!) {
        _responsesYes++;
      }
      else {
        _responsesNo++;
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

            int sum = _responsesYes + _responsesNo;

            int qualifiedYes = _responsesYes == 0 ? 1 : _responsesYes;
            int qualifiedNo = _responsesNo == 0 ? 1 : _responsesNo;
            int qualifiedSum = sum == 0 ? 20 : sum;

            double fontSizeYes = multiplier * (20 + 100 * qualifiedYes / qualifiedSum / 2);
            double fontSizeNo = multiplier * (20 + 100 * qualifiedNo / qualifiedSum / 2);

            print("~~RESPONSES");
            print("Yes: ${_responsesYes}");
            print("No: ${_responsesNo}");

            print("~~FONTSIZE");
            print(fontSizeYes);
            print(fontSizeNo);

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
                      visible: false, //was previously set to kDebugMode,
                      child: Slider(
                        value: _responsesYes as double,
                        min: 0,
                        max: 100,
                        divisions: 25,
                        label: '${_responsesYes.round()} YES / ${_responsesNo.round()} NO',
                        onChanged: (double value) {
                          setState(() {
                            _responsesYes = value as int;
                            _responsesNo = 100 - _responsesYes;
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
