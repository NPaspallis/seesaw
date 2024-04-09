import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/state_model.dart';
import 'package:seesaw/timed_painter.dart';

import 'main.dart';

class ThankYou extends StatefulWidget {
  final ScrollController scrollController;

  const ThankYou(this.scrollController, {super.key});

  @override
  State createState() => _ThankYouState();
}

class _ThankYouState extends State<ThankYou> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            TimedBackground(() => reset()),
            const Center(
                child: Text(
                    'Thank you for participating to this interactive experience.',
                    style: TextStyle(fontSize: 32, color: preparedWhiteColor, decoration: TextDecoration.none),
                    textAlign: TextAlign.center))
          ],
        ));
  }

  void reset() {
    final StateModel stateModel = Provider.of<StateModel>(context, listen: false);
    stateModel.setSeesawState(SeesawState.welcome);
    widget.scrollController.animateTo(
        widget.scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease);
  }
}
