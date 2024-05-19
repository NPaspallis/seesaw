import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/buttons.dart';
import 'package:seesaw/main.dart';
import 'package:seesaw/make_decision_before_video.dart';
import 'package:seesaw/state_model.dart';

import 'db.dart';

class MakeTriageDecisionAfterVideo extends StatefulWidget {
  const MakeTriageDecisionAfterVideo({super.key});

  @override
  State createState() => _MakeTriageDecisionAfterVideoState();
}

class _MakeTriageDecisionAfterVideoState extends State<MakeTriageDecisionAfterVideo> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 2 / 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const FittedBox(
              fit: BoxFit.fitWidth,
              child: Text("After having heard Dr. Marco Vergano's assessment, which decision would you take now?",
                  style: TextStyle(
                      fontSize: textSizeLarge,
                      color: preparedWhiteColor,
                      decoration: TextDecoration.none)),
            ),
            const FittedBox(
              fit: BoxFit.fitWidth,
              child: Text('Will you give an ICU bed to patients based on who came first?',
                  style: TextStyle(
                      fontSize: textSizeLarger,
                      fontWeight: FontWeight.w900,
                      color: preparedWhiteColor,
                      decoration: TextDecoration.none)),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                getElevatedButton(context, 'YES', chooseYes, preparedCyanColor),
                getElevatedButton(context, 'NO', chooseNo, preparedOrangeColor)
              ],
            ),
          ],
        ));
  }

  void chooseYes() {
    debugPrint('triage-after-yes');
    // todo
    // var db = RECCaseStudyDB.instance;
    // List<Future> futures = [db.incrementFinalYesDecision()];
    // if (MakeDecisionBeforeVideo.initialDecision == false) {
    //   futures.add(db.incrementSwitchedToYes());
    // }
    // Future.wait(futures).then((value) =>
        Provider.of<StateModel>(context, listen: false).progressToNextSeesawState();
    // );
  }

  void chooseNo() {
    debugPrint('triage-after-no');
    // todo
    // var db = RECCaseStudyDB.instance;
    // List<Future> futures = [db.incrementFinalNoDecision()];
    // if (MakeDecisionBeforeVideo.initialDecision == true) {
    //   futures.add(db.incrementSwitchedToNo());
    // }
    // Future.wait(futures).then((value) =>
        Provider.of<StateModel>(context, listen: false).progressToNextSeesawState();
    // );
  }
}
