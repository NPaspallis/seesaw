import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/main.dart';
import 'package:seesaw/state_model.dart';

import 'buttons.dart';

class FirstComeFirstServedDefinition extends StatefulWidget {

  const FirstComeFirstServedDefinition({super.key});

  @override
  State createState() => _FirstComeFirstServedDefinitionState();
}

class _FirstComeFirstServedDefinitionState extends State<FirstComeFirstServedDefinition> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 6 / 10,
        height: MediaQuery.of(context).size.height * 2 / 3,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'A principle that might be used to allocate ICU beds is',
                          style: TextStyle(
                              fontSize: textSizeLarge,
                              color: preparedWhiteColor,
                              decoration: TextDecoration.none),
                          textAlign: TextAlign.end,
                        ),
                        Text(
                          'first come, first served,',
                          style: TextStyle(
                              fontSize: textSizeHuge,
                              color: preparedWhiteColor,
                              decoration: TextDecoration.none),
                          textAlign: TextAlign.end,
                        ),
                        Text(
                          'which means that people should be treated\nin the order in which they have arrived at the ICU.',
                          style: TextStyle(
                              fontSize: textSizeLarge,
                              color: preparedWhiteColor,
                              decoration: TextDecoration.none),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(right: 40),
                  child: getElevatedButton(context, 'PROCEED', proceed)
              )
            ],
          ),
        )
    );
  }

  void proceed() {
    debugPrint('Proceed to HCS refresher');
    Provider.of<StateModel>(context, listen: false).progressToNextSeesawState();
  }
}
