import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/seesaw.dart';
import 'package:seesaw/state_model.dart';
import 'package:seesaw/tilt_direction.dart';

import 'buttons.dart';
import 'evaluation.dart';
import 'main.dart';

class ChoosePerspective extends StatefulWidget {

  const ChoosePerspective({super.key});

  @override
  State<ChoosePerspective> createState() => _ChoosePerspectiveState();
}

class _ChoosePerspectiveState extends State<ChoosePerspective> {

  bool policyMaker = false;

  late ElevatedButton policyMakerButton;
  late ElevatedButton committeeMemberButton;
  late BalancingSeesaw _balancingSeesaw;

  @override
  void initState() {
    super.initState();
    policyMakerButton = getElevatedButtonWithLabel(context, 'Policy Maker', choosePolicyMaker);
    committeeMemberButton = getElevatedButtonWithLabel(context, 'Research Ethics Committee Member', chooseCommitteeMember);
    _balancingSeesaw = BalancingSeesaw(callback: () {
      debugPrint('policyMaker: $policyMaker');
      navigateTo(context, const EvaluationPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            color: preparedPrimaryColor,
            child: Column(
                children: [
                  const Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 30),
                      child: Text(
                          'Please choose from which perspective you want to take decisions',
                          style: TextStyle(
                              fontSize: 32, color: preparedWhiteColor))
                  ),
                  Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 4,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      padding: const EdgeInsets.all(30),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          policyMakerButton,
                          committeeMemberButton,
                        ],
                      )
                  ),
                  Expanded(child: _balancingSeesaw),
                ]
            )
        )
    );
  }

  void choosePolicyMaker() {
    debugPrint('chose: choosePolicyMaker');
    final StateModel stateModel = Provider.of<StateModel>(context, listen: false);
    if(stateModel.tiltDirection == TiltDirection.loop) {
      stateModel.setTiltDirection(TiltDirection.left);
    }
  }

  void chooseCommitteeMember() {
    debugPrint('chose: chooseCommitteeMember');
    final StateModel stateModel = Provider.of<StateModel>(context, listen: false);
    if(stateModel.tiltDirection == TiltDirection.loop) {
      stateModel.setTiltDirection(TiltDirection.right);
    }
  }
}