import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/buttons.dart';
import 'package:seesaw/main.dart';
import 'package:seesaw/state_model.dart';

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
                getElevatedButton(context, 'YES', chooseYes),
                getOutlinedButton(context, 'NO', chooseNo)
              ],
            ),
          ],
        ));
  }

  void chooseYes() {
    debugPrint('after-yes');
    //todo update firebase
    Provider.of<StateModel>(context, listen: false).progressToNextSeesawState();
  }

  void chooseNo() {
    debugPrint('after-no');
    //todo update firebase
    Provider.of<StateModel>(context, listen: false).progressToNextSeesawState();
  }
}
