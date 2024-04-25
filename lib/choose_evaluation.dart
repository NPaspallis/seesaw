import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/buttons.dart';
import 'package:seesaw/main.dart';
import 'package:seesaw/state_model.dart';

class ChooseEvaluation extends StatefulWidget {
  const ChooseEvaluation({super.key});

  @override
  State createState() => _ChooseEvaluationState();
}

class _ChooseEvaluationState extends State<ChooseEvaluation> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 2 / 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 280),
                child: Text('Are you happy to answer some questions about your experience of using the See Saw?',
                    style: TextStyle(
                        fontSize: textSizeLarge,
                        fontWeight: FontWeight.bold,
                        color: preparedWhiteColor,
                        decoration: TextDecoration.none), textAlign: TextAlign.center,)),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                getOutlinedButton(context, 'NO', skipEvaluation),
                getElevatedButton(context, 'YES', doEvaluation)
              ],
            ),
          ],
        ));
  }

  void skipEvaluation() {
    debugPrint('skipEvaluation');
    Provider.of<StateModel>(context, listen: false).setSeesawState(SeesawState.thankYou);
  }

  void doEvaluation() {
    debugPrint('doEvaluation');
    Provider.of<StateModel>(context, listen: false).progressToNextSeesawState();
  }
}
