import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/state_model.dart';

import 'buttons.dart';

class Welcome extends StatefulWidget {
  final ScrollController scrollController;

  const Welcome(this.scrollController, {super.key});

  @override
  State createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
                width: 300,
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                  child: getStartButton(context, pressedStart)
                ))));
  }

  void pressedStart() {
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
