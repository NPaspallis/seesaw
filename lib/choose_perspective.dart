import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/state_model.dart';

import 'buttons.dart';
import 'main.dart';

class ChoosePerspective extends StatefulWidget {

  const ChoosePerspective({super.key});

  @override
  State<StatefulWidget> createState() => _ChoosePerspective();
}

class _ChoosePerspective extends State<ChoosePerspective> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 2 / 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Please choose from which perspective\nyou want to take decisions',
              style: TextStyle(
                  fontSize: textSizeLarge,
                  color: preparedWhiteColor),
              textAlign: TextAlign.center,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const SizedBox(
                          width: 450,
                          height: 200,
                          child: Center(
                              child: Text('Policy Maker',
                                  style: TextStyle(
                                      fontSize: textSizeLarge,
                                      fontWeight: FontWeight.w900,
                                      color: preparedWhiteColor,
                                      decoration: TextDecoration.none),
                                  textAlign: TextAlign.center)
                          )),
                      getElevatedButton(context, 'SELECT', choosePolicyMaker)
                    ],
                  ),

                  Column(
                    children: [
                      const SizedBox(
                          width: 450,
                          height: 200,
                          child: Center(
                              child: Text('Research Ethics Committee Member',
                                  style: TextStyle(
                                      fontSize: textSizeLarge,
                                      fontWeight: FontWeight.w900,
                                      color: preparedWhiteColor,
                                      decoration: TextDecoration.none),
                                  textAlign: TextAlign.center)
                          )),
                      getElevatedButton(context, 'SELECT', chooseCommitteeMember)
                    ],
                  ),
                ]
            )
          ],
        ));
  }

  void choosePolicyMaker() {
    debugPrint('chose: choosePolicyMaker');
    final StateModel stateModel = Provider.of<StateModel>(context, listen: false);
    stateModel.setSeesawState(SeesawState.perspectivePolicyMaker);
  }

  void chooseCommitteeMember() {
    debugPrint('chose: chooseCommitteeMember');
    final StateModel stateModel = Provider.of<StateModel>(context, listen: false);
    stateModel.setSeesawState(SeesawState.perspectiveCommitteeMember);
  }
}