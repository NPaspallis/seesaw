import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seesaw/main.dart';

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
        height: MediaQuery.of(context).size.height * 2 / 3,
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 4,
              child: const Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Perspective',
                          style: TextStyle(
                              fontSize: 32,
                              color: Colors.black,
                              decoration: TextDecoration.none)),
                      SizedBox(height: 10),
                      Text('Research ethics committee member',
                          style: TextStyle(
                              fontSize: 48,
                              color: preparedWhiteColor,
                              decoration: TextDecoration.none))
                    ],
                  )),
              // child: const Text('Go back in time to early 2020. Are you ready to take a decision about COVID-19?')
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 1 / 2,
              child: const Padding(
                  padding: EdgeInsets.all(40),
                  child: Text(
                        'Go back in time to early 2020. Are you ready to take a decision about COVID-19?',
                        style: TextStyle(
                            fontSize: 46,
                            color: preparedWhiteColor,
                            decoration: TextDecoration.none),
                        textAlign: TextAlign.end,
                      ),
                  ),
              // child: const Text('Go back in time to early 2020. Are you ready to take a decision about COVID-19?')
            ),
            Padding(
              padding: const EdgeInsets.all(40),
              child: getElevatedButtonWithLabel(
                  context, 'Press here', proceed),
            )
          ],
        ));
  }

  void proceed() {
    debugPrint('Pressed here'); //todo
  }
}
