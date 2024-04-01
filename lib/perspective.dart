import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/seesaw.dart';
import 'package:seesaw/state_model.dart';
import 'package:seesaw/tilt_direction.dart';

import 'evaluation.dart';
import 'main.dart';

class ChoosePerspective extends StatefulWidget {

  const ChoosePerspective({super.key});

  @override
  State<ChoosePerspective> createState() => _ChoosePerspectiveState();
}

class _ChoosePerspectiveState extends State<ChoosePerspective> {

  bool policyMaker = false;

  late BalancingSeesaw _balancingSeesaw;

  @override
  void initState() {
    super.initState();
    _balancingSeesaw = BalancingSeesaw(maxTilt: math.pi / 256, callback: () {
      debugPrint('policyMaker: $policyMaker');
      //todo
      navigateTo(context, const EvaluationPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
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
                          getElevatedButton(
                              context, 'Policy Maker', const EvaluationPage(),
                              choosePolicyMaker),
                          getElevatedButton(
                              context, 'Research Ethics Committee Member',
                              const EvaluationPage(), chooseCommitteeMember),
                        ],
                      )
                  ),
                  Expanded(child: _balancingSeesaw),
                ]
            )
        )
    );
  }

  ElevatedButton getElevatedButton(final BuildContext context,
      final String text, final Widget targetWidget,
      final VoidCallback callback) {
    return ElevatedButton(
        onPressed: () => callback.call(),
        style: ButtonStyle(
            padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>((
                Set<MaterialState> states) =>
                EdgeInsets.all(states.contains(MaterialState.pressed) ? 0 : 0)),
            // default elevation,
            backgroundColor: MaterialStateProperty.all<Color>(
                preparedPrimaryColor),
            shadowColor: MaterialStateProperty.all<Color>(preparedShadeColor),
            elevation: MaterialStateProperty.resolveWith<double>((
                Set<MaterialState> states) {
              return states.contains(MaterialState.pressed)
                  ? 5
                  : 15; // default elevation
            }),
            animationDuration: const Duration(milliseconds: 200),
            shape: const MaterialStatePropertyAll(CircleBorder())
        ),
        child: Stack(
          children: [
            Container(
                width: 300,
                color: Colors.transparent,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset('assets/green_button_blank.png'),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                      child: Text(text, style: const TextStyle(fontSize: 28,
                          color: preparedWhiteColor,
                          fontWeight: FontWeight.w900,
                          shadows: [
                            Shadow(color: preparedShadeColor,
                                offset: Offset(2, 2),
                                blurRadius: 4)
                          ]), textAlign: TextAlign.center),
                    ),
                  ],
                )
            ),

          ],
        )
    );
  }

  void choosePolicyMaker() {
    debugPrint('chose: choosePolicyMaker');
    Provider.of<StateModel>(context, listen: false).setTiltDirection(
        TiltDirection.left);
  }

  void chooseCommitteeMember() {
    debugPrint('chose: chooseCommitteeMember');
    Provider.of<StateModel>(context, listen: false).setTiltDirection(
        TiltDirection.right);
  }
}