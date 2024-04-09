import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/main.dart';
import 'package:seesaw/state_model.dart';

import 'buttons.dart';

class PerspectiveCommitteeMember extends StatefulWidget {
  const PerspectiveCommitteeMember({super.key});

  @override
  State createState() => _PerspectiveCommitteeMemberState();
}

class _PerspectiveCommitteeMemberState
    extends State<PerspectiveCommitteeMember> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 2 / 3,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(40, 40, 0, 40),
                child: Text(
                  'Go back in time to early 2020.\nAre you ready to take a decision about COVID-19?',
                  style: TextStyle(
                      fontSize: textSizeMedium,
                      color: preparedWhiteColor,
                      decoration: TextDecoration.none),
                  textAlign: TextAlign.end,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(80),
                child: getElevatedButtonWithPreparedLabel(
                    context, 'Press here', proceed),
              )
            ],
          ),
        )
    );
  }

  void proceed() {
    debugPrint('Proceed to choose '); //todo
    final StateModel stateModel = Provider.of<StateModel>(context, listen: false);
    stateModel.setSeesawState(SeesawState.chooseHcsRefresher);
  }
}
