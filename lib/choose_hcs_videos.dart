import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/buttons.dart';
import 'package:seesaw/state_model.dart';
import 'main.dart';

class ChooseHcsVideos extends StatefulWidget {

  const ChooseHcsVideos({super.key});

  @override
  State<StatefulWidget> createState() => _ChooseHcsVideos();
}

class _ChooseHcsVideos extends State<ChooseHcsVideos> {

  final Random random = Random();
  final double _side = 350;
  late double _lp1;
  late double _tp1;
  late double _lp2;
  late double _tp2;
  late double _lp3;
  late double _tp3;
  var colors = [preparedOrangeColor, preparedBrightRed, preparedCyanColor];
  var watched = [false, false, false];

  @override
  void initState() {
    super.initState();

    final double ballPaddingSide = _side / 3;
    _lp1 = random.nextDouble() * ballPaddingSide;
    _tp1 = random.nextDouble() * ballPaddingSide;
    _lp2 = random.nextDouble() * ballPaddingSide;
    _tp2 = random.nextDouble() * ballPaddingSide;
    _lp3 = random.nextDouble() * ballPaddingSide;
    _tp3 = random.nextDouble() * ballPaddingSide;
    colors.shuffle(random);
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 2 / 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Human Challenge Studies Seesaw',
              style: TextStyle(
                  fontSize: textSizeLarge,
                  color: preparedWhiteColor),
              textAlign: TextAlign.center,
            ),
            Row(
                children: [
                  _getClickableBall(colors[0], _side, _lp1, _tp1, "A person's experience of being part of a COVID-19 HCS", watched[0], watchVideo1),
                  _getClickableBall(colors[1], _side, _lp2, _tp2, "Read from Peter Singer’s article on COVID-19 HCS", watched[1], watchVideo2),
                  _getClickableBall(colors[2], _side, _lp3, _tp3, "A doctor explaining the risks of HCS with COVID-19", watched[2], watchVideo3)
                ]
            ),
            const SizedBox(height: 10),
            Visibility(
              visible: watched[0] && watched[1] && watched[2],
              child: getElevatedButton(context, 'CARRY ON', proceed)
            )
          ],
        ));
  }

  Widget _getClickableBall(Color color, double side, double lp, double tp, String text, bool watched, VoidCallback callback) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.height / 2,
      child: Padding(
        padding: EdgeInsets.fromLTRB(lp, tp, side/3 - lp, side/3 - tp),
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: color,
                width: 10.0,
              ),
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: side/8, horizontal: side/5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text, style: const TextStyle(fontSize: textSizeMedium, fontWeight: FontWeight.w900, color: preparedWhiteColor), textAlign: TextAlign.center),
                const SizedBox(height: 10),
                watched ?
                const Text('WATCHED 🗹', style: TextStyle(fontSize: textSizeSmall, fontWeight: FontWeight.w500, color: preparedSecondaryColor)) :
                getOutlinedButton(context, 'WATCH', callback)
              ],
            )
          )
        ),
      ),
    );
  }

  void proceed() {
    //todo
    setState(() {
      final double ballPaddingSide = _side / 3;
      _lp1 = random.nextDouble() * ballPaddingSide;
      _tp1 = random.nextDouble() * ballPaddingSide;
      _lp2 = random.nextDouble() * ballPaddingSide;
      _tp2 = random.nextDouble() * ballPaddingSide;
      _lp3 = random.nextDouble() * ballPaddingSide;
      _tp3 = random.nextDouble() * ballPaddingSide;
    });
    Provider.of<StateModel>(context, listen: false).progressToNextSeesawState();
  }

  void watchVideo1() {
    //todo
    setState(() {
      watched[0] = true;
    });
  }

  void watchVideo2() {
    //todo
    setState(() {
      watched[1] = true;
    });
  }

  void watchVideo3() {
    //todo
    setState(() {
      watched[2] = true;
    });
  }
}