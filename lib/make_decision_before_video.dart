import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/buttons.dart';
import 'package:seesaw/main.dart';
import 'package:seesaw/seesaw_app.dart';
import 'package:seesaw/state_model.dart';

import 'db.dart';

class MakeDecisionBeforeVideo extends StatefulWidget {
  final String classroomUUID;
  const MakeDecisionBeforeVideo({super.key, required this.classroomUUID});

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
            const FittedBox(
              fit: BoxFit.fitWidth,
              child: Text('Now please make a decision as the Chair of a Research Ethics Committee.\nAnd remember it is early 2020.',
                style: TextStyle(
                    fontSize: textSizeLarge,
                    color: preparedWhiteColor,
                    decoration: TextDecoration.none), textAlign: TextAlign.center)
            ),
            const FittedBox(
              fit: BoxFit.fitWidth,
              child: Text('Will you allow a human challenge trial with COVID-19?',
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
    debugPrint('hcs-before-yes -- ${widget.classroomUUID}');
    MakeDecisionBeforeVideo.initialDecision = true;
    var db = RECCaseStudyDB.instance;
    db.incrementInitialYesDecision(widget.classroomUUID).then((value) =>
        Provider.of<StateModel>(context, listen: false).progressToNextSeesawState(),
    );
  }

  void chooseNo() {
    debugPrint('hcs-before-no -- ${widget.classroomUUID}');
    MakeDecisionBeforeVideo.initialDecision = false;
    var db = RECCaseStudyDB.instance;
    db.incrementInitialNoDecision(widget.classroomUUID).then((value) =>
        Provider.of<StateModel>(context, listen: false).progressToNextSeesawState(),
    );
  }
}
