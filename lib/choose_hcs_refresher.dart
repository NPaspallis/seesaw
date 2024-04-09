import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/buttons.dart';
import 'package:seesaw/main.dart';
import 'package:seesaw/state_model.dart';

class HcsChooseRefresher extends StatefulWidget {
  const HcsChooseRefresher({super.key});

  @override
  State createState() => _HcsChooseRefresherState();
}

class _HcsChooseRefresherState extends State<HcsChooseRefresher> {

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
                        fontSize: textSizeLarge,
                        color: preparedSecondaryColor,
                        decoration: TextDecoration.none))),
            Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    child: const Text(
                        'Press here if you know what human challenge studies are',
                        style: TextStyle(
                            fontSize: textSizeMedium,
                            color: preparedWhiteColor,
                            decoration: TextDecoration.none), textAlign: TextAlign.center),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    child: const Text(
                        'Press here if you would like a refresher',
                        style: TextStyle(
                            fontSize: textSizeMedium,
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
    final StateModel stateModel =
        Provider.of<StateModel>(context, listen: false);
    stateModel.setSeesawState(SeesawState.chooseHcsRefresherGo);
  }
}
