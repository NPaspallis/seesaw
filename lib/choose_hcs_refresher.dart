import 'package:flutter/material.dart';
import 'package:seesaw/buttons.dart';

import 'main.dart';

class HcsChooseRefresher extends StatelessWidget {
  const HcsChooseRefresher({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 2 / 3,
        child: Column(
          children: [
            const Padding(
                padding: EdgeInsets.all(50),
                child: Text('Human Challenge Studies',
                    style: TextStyle(
                        fontSize: 46,
                        color: preparedWhiteColor,
                        decoration: TextDecoration.none))),
            Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: const Text(
                        'Press here if you know what human challenge studies are',
                        style: TextStyle(
                            fontSize: 48,
                            color: preparedWhiteColor,
                            decoration: TextDecoration.none), textAlign: TextAlign.center),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: const Text(
                        'Press here if you would like a refresher',
                        style: TextStyle(
                            fontSize: 48,
                            color: preparedWhiteColor,
                            decoration: TextDecoration.none), textAlign: TextAlign.center),
                  ),
                ]),
            const SizedBox(height: 50),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                getElevatedButtonWithPreparedLabel(
                    context, 'Press HERE', skipRefresher),
                getElevatedButtonWithPreparedLabel(context, 'Press HERE', doRefresher),
              ],
            ),
          ],
        ));
  }

  void skipRefresher() {
    debugPrint('skipRefresher');
  }

  void doRefresher() {
    debugPrint('doRefresher');
  }
}
