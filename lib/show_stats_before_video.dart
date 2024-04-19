import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/buttons.dart';
import 'package:seesaw/main.dart';
import 'package:seesaw/state_model.dart';

class ShowStatsBeforeVideo extends StatefulWidget {
  const ShowStatsBeforeVideo({super.key});

  @override
  State createState() => _ShowStatsBeforeVideoState();
}

class _ShowStatsBeforeVideoState extends State<ShowStatsBeforeVideo> {

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
                child: Text('TODO... show a pie chart of the decisions recorded',
                    style: TextStyle(
                        fontSize: textSizeLarge,
                        color: preparedWhiteColor,
                        decoration: TextDecoration.none))),
            getElevatedButton(context, "CARRY ON", carryOn)
          ],
        ));
  }

  void carryOn() {
    debugPrint('carryOn');
    Provider.of<StateModel>(context, listen: false).progressToNextSeesawState();
  }
}
