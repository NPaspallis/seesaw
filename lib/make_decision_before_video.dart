import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/buttons.dart';
import 'package:seesaw/main.dart';
import 'package:seesaw/state_model.dart';

import 'db.dart';

class MakeDecisionBeforeVideo extends StatefulWidget {
  const MakeDecisionBeforeVideo({super.key});

  static bool initialDecision = false;

  @override
  State createState() => _MakeDecisionBeforeVideoState();
}

class _MakeDecisionBeforeVideoState extends State<MakeDecisionBeforeVideo> {

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
                child: Text('Now please make a decision as the Chair of a Research Ethics Committee.\nAnd remember it is early 2020.',
                    style: TextStyle(
                        fontSize: textSizeLarge,
                        color: preparedWhiteColor,
                        decoration: TextDecoration.none), textAlign: TextAlign.center,)),
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
    debugPrint('before-yes');
    MakeDecisionBeforeVideo.initialDecision = true;
    var db = RECCaseStudyDB.instance;
    db.incrementInitialYesDecision().then((value) =>
        Provider.of<StateModel>(context, listen: false).progressToNextSeesawState(),
    );
  }

  void chooseNo() {
    debugPrint('before-no');
    MakeDecisionBeforeVideo.initialDecision = false;
    var db = RECCaseStudyDB.instance;
    db.incrementInitialNoDecision().then((value) =>
        Provider.of<StateModel>(context, listen: false).progressToNextSeesawState(),
    );
  }
}
