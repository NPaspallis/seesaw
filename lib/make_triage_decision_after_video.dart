import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/buttons.dart';
import 'package:seesaw/main.dart';
import 'package:seesaw/make_triage_decision_before_video.dart';
import 'package:seesaw/state_model.dart';

import 'db.dart';

class MakeTriageDecisionAfterVideo extends StatefulWidget {
  final String classroomUUID;
  const MakeTriageDecisionAfterVideo({super.key, required this.classroomUUID});

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
    var db = TriageCaseStudyDB.instance;
    List<Future> futures = [db.incrementFinalYesDecision(widget.classroomUUID)];
    if (MakeTriageDecisionBeforeVideo.initialDecision == false) {
      futures.add(db.incrementSwitchedToYes(widget.classroomUUID));
    }
    Future.wait(futures).then((value) =>
        Provider.of<StateModel>(context, listen: false).progressToNextSeesawState()
    );
  }

  void chooseNo() {
    debugPrint('triage-after-no');
    var db = TriageCaseStudyDB.instance;
    List<Future> futures = [db.incrementFinalNoDecision(widget.classroomUUID)];
    if (MakeTriageDecisionBeforeVideo.initialDecision == true) {
      futures.add(db.incrementSwitchedToNo(widget.classroomUUID));
    }
    Future.wait(futures).then((value) =>
        Provider.of<StateModel>(context, listen: false).progressToNextSeesawState()
    );
  }
}
