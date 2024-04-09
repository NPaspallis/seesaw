import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/state_model.dart';
import 'package:seesaw/tilt_direction.dart';
import 'package:seesaw/timed_painter.dart';

import 'main.dart';

class ThankYouPage extends StatelessWidget {
  const ThankYouPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            TimedBackground(() {
              Provider.of<StateModel>(context, listen: false).setTiltDirection(TiltDirection.loop);
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context).popUntil((route) => route.isFirst);
            }),
            const Center(child: Text('Thank you for participating to this interactive experience.', style: TextStyle(fontSize: 32, color: preparedWhiteColor), textAlign: TextAlign.center))
          ],
        )
      )
    );
  }
}