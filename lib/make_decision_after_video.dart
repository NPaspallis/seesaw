import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/buttons.dart';
import 'package:seesaw/main.dart';
import 'package:seesaw/make_decision_before_video.dart';
import 'package:seesaw/state_model.dart';

import 'db.dart';

class MakeDecisionAfterVideo extends StatefulWidget {
  const MakeDecisionAfterVideo({super.key});

  @override
  State createState() => _MakeDecisionAfterVideoState();
}

class _MakeDecisionAfterVideoState extends State<MakeDecisionAfterVideo> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 2 / 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Padding(
                padding: EdgeInsets.all(50),
                child: Text('After having heard Prof. Charles Weijer’s assessment,\nwhich decision would you take now.',
                    style: TextStyle(
                        fontSize: textSizeLarge,
                        color: preparedWhiteColor,
                        decoration: TextDecoration.none))),
            const Padding(
                padding: EdgeInsets.all(50),
                child: Text('Will you allow a human challenge trial with COVID-19?',
                    style: TextStyle(
                        fontSize: textSizeLarger,
                        fontWeight: FontWeight.w900,
                        color: preparedWhiteColor,
                        decoration: TextDecoration.none))),
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
    debugPrint('after-yes');
    var db = RECCaseStudyDB.instance;
    List<Future> futures = [db.incrementFinalYesDecision()];
    if (MakeDecisionBeforeVideo.initialDecision == false) {
      futures.add(db.incrementSwitchedToYes());
    }
    Future.wait(futures).then((value) =>
        Provider.of<StateModel>(context, listen: false).progressToNextSeesawState(),
    );
  }

  void chooseNo() {
    debugPrint('after-no');
    var db = RECCaseStudyDB.instance;
    List<Future> futures = [db.incrementFinalNoDecision()];
    if (MakeDecisionBeforeVideo.initialDecision == true) {
      futures.add(db.incrementSwitchedToNo());
    }
    Future.wait(futures).then((value) =>
        Provider.of<StateModel>(context, listen: false).progressToNextSeesawState(),
    );
  }
}
