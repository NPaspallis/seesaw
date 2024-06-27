import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/buttons.dart';
import 'package:seesaw/main.dart';
import 'package:seesaw/state_model.dart';

import 'db.dart';

class MakeTriageDecisionBeforeVideo extends StatefulWidget {
  final String classroomUUID;
  MakeTriageDecisionBeforeVideo({super.key, required this.classroomUUID});

  static bool initialDecision = false;

  @override
  State createState() => _MakeTriageDecisionBeforeVideoState();
}

class _MakeTriageDecisionBeforeVideoState extends State<MakeTriageDecisionBeforeVideo> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.height * 2 / 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const FittedBox(
              fit: BoxFit.fitWidth,
              child: Text('Now please make a decision as the Head of an Intensive Care Unit.',
                style: TextStyle(
                    fontSize: textSizeLarge,
                    color: preparedWhiteColor,
                    decoration: TextDecoration.none), textAlign: TextAlign.center,),
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
    debugPrint('triage-before-yes');
    MakeTriageDecisionBeforeVideo.initialDecision = true;
    var db = TriageCaseStudyDB.instance;
    db.incrementInitialYesDecision(widget.classroomUUID).then((value) =>
        Provider.of<StateModel>(context, listen: false).progressToNextSeesawState()
    );
  }

  void chooseNo() {
    debugPrint('triage-before-no');
    MakeTriageDecisionBeforeVideo.initialDecision = false;
    var db = TriageCaseStudyDB.instance;
    db.incrementInitialNoDecision(widget.classroomUUID).then((value) =>
        Provider.of<StateModel>(context, listen: false).progressToNextSeesawState()
    );
  }
}
