import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fullscreen_window/fullscreen_window.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/seesaw_widget.dart';
import 'package:seesaw/state_model.dart';

import 'buttons.dart';

class Welcome extends StatefulWidget {
  final ScrollController scrollController;

  const Welcome(this.scrollController, {super.key});

  @override
  State createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

  late BalancingSeesaw _balancingSeesaw;


  @override
  void initState() {
    super.initState();
    _balancingSeesaw = const BalancingSeesaw();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 300,
            height: 300,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
              child: getStartButton(context, pressedStart)
            )
          ),

          const SizedBox(height: 100),

          _getBalancingSeesaw()
        ]
    );
  }

  Widget _getBalancingSeesaw() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width * 2 / 3,
      child: _balancingSeesaw,
    );
  }

  void pressedStart() {
    FullScreenWindow.setFullScreen(true);
    debugPrint('choosePerspective');
    final StateModel stateModel =
        Provider.of<StateModel>(context, listen: false);
    stateModel.setSeesawState(SeesawState.choosePerspective);
    widget.scrollController.animateTo(
        widget.scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease);
  }
}
