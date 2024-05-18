import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/seesaw_app.dart';
import 'package:seesaw/state_model.dart';
import 'package:seesaw/timed_painter.dart';

import 'main.dart';

class ThankYou extends StatefulWidget {
  final ScrollController scrollController;

  const ThankYou(this.scrollController, {super.key});

  @override
  State createState() => _ThankYouState();
}

const showThankYouForMilliseconds = 4000;

class _ThankYouState extends State<ThankYou> {

  @override
  Widget build(BuildContext context) {
    return Container(
        color: preparedWhiteColor,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Text(
                  'Thank you for participating to this interactive experience.',
                  style: TextStyle(fontSize: textSizeLarger, color: preparedPrimaryColor, fontWeight: FontWeight.w900, decoration: TextDecoration.none),
                  textAlign: TextAlign.center),
            ),
            const SizedBox(height: 128),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [ // portraits
                _getPortraitWithName('assets/doris.png', 'Doris Schroeder'),
                _getPortraitWithName('assets/dave.png', 'David Robinson'),
                _getPortraitWithName('assets/natalie.png', 'Natalie Evans'),
              ],
            ),
            const SizedBox(height: 128),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [ // logos
                Image.asset('assets/eu_co_funded_en_400.png'),
                Image.asset('assets/amsterdam_umc_400.png'),
                Image.asset('assets/prepared_400.png'),
                Image.asset('assets/eogs_200.png'),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text('Version: $version', textAlign: TextAlign.end),
            ),
            TimedBackground(() => reset(), backgroundColor: preparedPrimaryColor, shadingColor: preparedSecondaryColor, screenRatio: 32),
          ],
        )
    );
  }

  Widget _getPortraitWithName(final String imageAsset, final String name) {
    return Column(
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(imageAsset),
              )
          ),
        ),
        Text(name, style: const TextStyle(fontSize: textSizeSmall, fontWeight: FontWeight.w500, color: preparedPrimaryColor), textAlign: TextAlign.center)
      ],
    );
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