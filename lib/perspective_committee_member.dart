import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/db.dart';
import 'package:seesaw/main.dart';
import 'package:seesaw/state_model.dart';

import 'buttons.dart';

class PerspectiveCommitteeMember extends StatefulWidget {
  final String classroomUUID;
  PerspectiveCommitteeMember({super.key, required this.classroomUUID});

  @override
  State createState() => _PerspectiveCommitteeMemberState();
}

class _PerspectiveCommitteeMemberState
    extends State<PerspectiveCommitteeMember> {
  @override
  void initState() {
    RECCaseStudyDB().initializeCaseStudyCounters(widget.classroomUUID);
    super.initState();
  }

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
                          'Go back in time to early 2020.',
                          style: TextStyle(
                              fontSize: 128,
                              color: preparedWhiteColor,
                              decoration: TextDecoration.none),
                          textAlign: TextAlign.end,
                        ),
                        SizedBox(height: 64),
                        Text(
                              'Many countries were facing the possibility of having too few\n'
                              'Intensive Care Unit (ICU) beds to care for all patients with COVID-19.\n'
                              'Decisions had to be made about how to allocate ICU beds.',
                          style: TextStyle(
                              fontSize: 96,
                              color: preparedWhiteColor,
                              decoration: TextDecoration.none),
                          textAlign: TextAlign.end,
                        ),
                        SizedBox(height: 64),
                        Text(
                              'This is also known as triage. Which patients should get access\n'
                              'to ICU beds if not everyone can be accommodated?',
                          style: TextStyle(
                              fontSize: 96,
                              color: preparedWhiteColor,
                              decoration: TextDecoration.none),
                          textAlign: TextAlign.end,
                        ),
                        SizedBox(height: 64),
                        Text(
                          'This decision tree will last 12-14 minutes',
                          style: TextStyle(
                              fontSize: textSizeSmall,
                              fontStyle: FontStyle.italic,
                              color: preparedWhiteColor,
                              decoration: TextDecoration.none),
                          textAlign: TextAlign.end,
                        )
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
