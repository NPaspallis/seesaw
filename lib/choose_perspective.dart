import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/state_model.dart';

import 'buttons.dart';
import 'main.dart';

class ChoosePerspective extends StatefulWidget {

  const ChoosePerspective({super.key});

  @override
  State<StatefulWidget> createState() => _ChoosePerspective();
}

class _ChoosePerspective extends State<ChoosePerspective> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 2 / 3,
        height: MediaQuery.of(context).size.height * 2 / 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                'Please choose from which perspective\nyou want to take decisions',
                style: TextStyle(
                    color: preparedWhiteColor),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  InkWell(
                    onTap: choosePolicyMaker,
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(10.0))
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 4,
                              height: 200,
                              child: const Center(
                                  child: Text('Policy Maker',
                                      style: TextStyle(
                                          fontSize: textSizeLarge,
                                          fontWeight: FontWeight.w900,
                                          color: preparedWhiteColor,
                                          decoration: TextDecoration.none),
                                      textAlign: TextAlign.center)
                              )),
                          getElevatedButton(context, 'COMING SOON', choosePolicyMaker, Colors.grey)
                        ],
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: chooseCommitteeMember,
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(10.0))
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 4,
                              height: 200,
                              child: const Center(
                                  child: Text('Research Ethics\nCommittee Member',
                                      style: TextStyle(
                                          fontSize: textSizeLarge,
                                          fontWeight: FontWeight.w900,
                                          color: preparedWhiteColor,
                                          decoration: TextDecoration.none),
                                      textAlign: TextAlign.center)
                              )),
                          getElevatedButton(context, 'SELECT', chooseCommitteeMember)
                        ],
                      ),
                    ),
                  ),
                ]
            )
          ],
        ));
  }

  void choosePolicyMaker() {
    debugPrint('chose: choosePolicyMaker');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.info, color: Colors.white, size: 40,),
            Gap(20),
            Text("This option will be available soon.", style: TextStyle(fontSize: textSizeMedium),),
          ],
        ),
        backgroundColor: preparedBlueColor,
      )
    );
    // final StateModel stateModel = Provider.of<StateModel>(context, listen: false);
    // stateModel.setSeesawState(SeesawState.perspectivePolicyMaker);
  }

  void chooseCommitteeMember() {
    debugPrint('chose: chooseCommitteeMember');
    final StateModel stateModel = Provider.of<StateModel>(context, listen: false);
    stateModel.setSeesawState(SeesawState.perspectiveCommitteeMember);
  }
}