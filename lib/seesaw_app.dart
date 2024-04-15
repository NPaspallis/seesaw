import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/evaluation.dart';
import 'package:seesaw/perspective_committee_member.dart';
import 'package:seesaw/seesaw.dart';
import 'package:seesaw/state_model.dart';
import 'package:seesaw/thank_you.dart';
import 'package:seesaw/welcome.dart';

import 'buttons.dart';
import 'choose_hcs_refresher.dart';
import 'hcs_refresher.dart';
import 'main.dart';

class SeesawApp extends StatefulWidget {
  const SeesawApp({super.key});

  @override
  State<StatefulWidget> createState() => _SeesawAppState();
}

class _SeesawAppState extends State<SeesawApp> {
  final ScrollController _scrollController = ScrollController();

  late BalancingSeesaw _balancingSeesaw;
  late SeesawState _seesawState;

  @override
  void initState() {
    super.initState();
    _balancingSeesaw = const BalancingSeesaw();
    _seesawState = SeesawState.welcome;

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (_seesawState == SeesawState.welcome) {
    //     debugPrint('animateTo maxScrollExtent');
    //     _scrollController.animateTo(_scrollController.position.maxScrollExtent,
    //         duration: const Duration(milliseconds: 500), curve: Curves.ease);
    //   } else {
    //     debugPrint('animateTo minScrollExtent');
    //     _scrollController.animateTo(_scrollController.position.minScrollExtent,
    //         duration: const Duration(milliseconds: 500), curve: Curves.ease);
    //   }
    // });
  }

  void choosePolicyMaker() {
    debugPrint('chose: choosePolicyMaker');
    final StateModel stateModel =
        Provider.of<StateModel>(context, listen: false);
    stateModel.setSeesawState(SeesawState.perspectivePolicyMaker);
  }

  void chooseCommitteeMember() {
    debugPrint('chose: chooseCommitteeMember');
    final StateModel stateModel =
        Provider.of<StateModel>(context, listen: false);
    stateModel.setSeesawState(SeesawState.perspectiveCommitteeMember);
  }

  void _resetInteraction(BuildContext context) {
    // show the dialog
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: const Text(
                  'Are you sure you want to reset the session?\nAll progress will be lost.',
                  style: TextStyle(fontSize: textSizeSmall)),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel',
                        style: TextStyle(fontSize: textSizeSmall, fontWeight: FontWeight.bold, color: preparedSecondaryColor))),
                getElevatedButton(context, 'RESET', () {
                  _doResetInteraction();
                  Navigator.pop(context);
                }),
              ],
              elevation: 24.0,
            ));
  }

  void _doResetInteraction() {
    final StateModel stateModel =
        Provider.of<StateModel>(context, listen: false);
    stateModel.setSeesawState(SeesawState.welcome);
    _scrollController.animateTo(
        _scrollController
            .position.maxScrollExtent, // todo generalize as a post-build action
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease);
  }

  Widget _getMainContainer(final StateModel state) {
    // must add up to 2/3 of height
    debugPrint('state: ${state.seesawState}');
    switch (state.seesawState) {
      case SeesawState.welcome:
        return Welcome(_scrollController);
      case SeesawState.choosePerspective:
        return getChoosePerspectiveWidget();
      case SeesawState.perspectivePolicyMaker:
        return const Text('error: todo'); //todo
      case SeesawState.perspectiveCommitteeMember:
        return const PerspectiveCommitteeMember();
      case SeesawState.chooseHcsRefresher:
        return const HcsChooseRefresher();
      case SeesawState.chooseHcsRefresherGo:
        return const HcsRefresher();
      case SeesawState.evaluation:
        return const EvaluationPage();
      case SeesawState.thankYou:
        return ThankYou(_scrollController);
      default:
        return Text('error: unknown state: ${state.seesawState}',
            style: const TextStyle(color: Colors.red));
    }
  }

  Widget _getBalancingSeesaw() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width * 2 / 3,
      child: _balancingSeesaw,
    );
  }

  String _getNavigationLabel(final SeesawState seesawState) {
    switch (seesawState) {
      case SeesawState.choosePerspective:
        return 'Choose perspective';
      case SeesawState.perspectiveCommitteeMember:
        return 'Perspective | Research ethics committee member';
      case SeesawState.perspectivePolicyMaker:
        return 'Perspective | Policy maker';
      case SeesawState.chooseHcsRefresher:
        return 'Human Challenge Studies | Refresher?';
      case SeesawState.chooseHcsRefresherGo:
        return 'Human Challenge Studies | Refresher';
      case SeesawState.evaluation:
        return 'Evaluation';
      case SeesawState.thankYou:
        return 'Thank you!';
      case SeesawState.welcome:
        return 'Welcome';
      default:
        return 'unknown';
    }
  }

  Container _getNavigationWidget(final SeesawState seesawState) {
    String label = _getNavigationLabel(seesawState);
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 24,
        color: preparedShadeColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(textSizeSmall, 0, 0, 0),
                child: Text(
                  label,
                  style: const TextStyle(
                      fontSize: textSizeSmall,
                      color: preparedSecondaryColor,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none),
                )),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, textSizeSmall, 0),
                child: Builder(
                    builder: (context) => ElevatedButton(
                        onPressed: () => _resetInteraction(context),
                        child: const Row(
                          children: [
                            Icon(Icons.reset_tv),
                            SizedBox(width: 10),
                            Text('RESET')
                          ],
                        )))),
          ],
        ));
  }

  Container _getTopContainer() {
    return Container(
        height: MediaQuery.of(context).size.height / 6,
        color: Colors.red,
        alignment: Alignment.center,
        child: const Text(
          'An interactive experience demonstrating ethical tradeoffs in times of crisis',
          style: TextStyle(
              fontSize: 32,
              color: preparedWhiteColor,
              decoration: TextDecoration.none),
          textAlign: TextAlign.center,
        ));
  }

  Widget _getBottomWidget() {
    return SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        child: const Center(
            child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
              'An interactive experience demonstrating ethical tradeoffs in times of crisis',
              style: TextStyle(
                  fontSize: textSizeLarge,
                  color: preparedWhiteColor,
                  decoration: TextDecoration.none)),
        )));
  }

  Widget getChoosePerspectiveWidget() {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 2 / 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Please choose from which perspective you want to take decisions',
              style: TextStyle(
                  fontSize: textSizeMedium,
                  color: preparedSecondaryColor,
                  decoration: TextDecoration.none),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      width: 400,
                      height: 200,
                      child: Center(
                        child: Text('Policy Maker',
                            style: TextStyle(
                                fontSize: textSizeLarge,
                                color: preparedWhiteColor,
                                decoration: TextDecoration.none),
                            textAlign: TextAlign.center)
                      )),
                      getElevatedButton(context, 'SELECT', choosePolicyMaker)
                  ],
                ),

                Column(
                  children: [
                    const SizedBox(
                      width: 400,
                      height: 200,
                      child: Center(
                        child: Text('Research Ethics Committee Member',
                            style: TextStyle(
                                fontSize: textSizeLarge,
                                color: preparedWhiteColor,
                                decoration: TextDecoration.none),
                            textAlign: TextAlign.center)
                      )),
                      getElevatedButton(context, 'SELECT', chooseCommitteeMember)
                  ],
                ),
              ]

                // SizedBox(
                //     width: 300,
                //     height: 300,
                //     child: Padding(
                //       padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                //       // child: getElevatedButtonWithPreparedLabel(
                //       //     context, 'Policy Maker', choosePolicyMaker),
                //       child: Column(
                //         children: [
                //           const Text('Policy Maker',
                //           style: TextStyle(
                //               fontSize: textSizeLarge,
                //               color: preparedWhiteColor,
                //               decoration: TextDecoration.none),
                //           textAlign: TextAlign.center),
                //           const SizedBox(height: 50),
                //           getElevatedButton(context, 'SELECT', choosePolicyMaker)
                //         ],
                //       )
                //     )),
                // Visibility(
                //     visible: _seesawState == SeesawState.welcome,
                //     child: SizedBox(
                //         width: 400,
                //         height: 300,
                //         child: Padding(
                //           padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                //           // child: getElevatedButtonWithPreparedLabel(
                //           //     context,
                //           //     'Research Ethics Committee Member',
                //           //     chooseCommitteeMember),
                //             child: Column(
                //               children: [
                //                 const Text('Research Ethics Committee Member',
                //                     style: TextStyle(
                //                         fontSize: textSizeLarge,
                //                         color: preparedWhiteColor,
                //                         decoration: TextDecoration.none),
                //                     textAlign: TextAlign.center),
                //                 const SizedBox(height: 50),
                //                 getElevatedButton(context, 'SELECT', chooseCommitteeMember)
                //               ],
                //             )
                //         )))              ],
            )
          ],
        ));
  }


  @override
  void activate() {
    super.activate();
    _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_seesawState == SeesawState.welcome) {
        debugPrint('animateTo maxScrollExtent');
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500), curve: Curves.ease);
      } else {
        debugPrint('animateTo minScrollExtent');
        _scrollController.animateTo(_scrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 500), curve: Curves.ease);
      }
    });

    return MaterialApp(
        title: 'Seesaw App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: preparedPrimaryColor),
          primaryColor: preparedPrimaryColor,
          splashColor: preparedSecondaryColor,
          // fontFamily: 'Open Sans',
          useMaterial3: true,
        ),
        home: Scaffold(
            body: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const NeverScrollableScrollPhysics(),
                    child: Container(
                        color: preparedPrimaryColor,
                        child: Consumer<StateModel>(
                            builder: (context, state, child) {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _getNavigationWidget(state.seesawState),
                                Visibility(
                                    visible:
                                        _seesawState != SeesawState.welcome,
                                    child: _getTopContainer()), // 1/6
                                _getMainContainer(state), // 2/3
                                _getBalancingSeesaw(), // 1/3
                                Visibility(
                                    visible:
                                        _seesawState == SeesawState.welcome,
                                    child: _getBottomWidget()) // 1/6
                              ]);
                        }))))));
  }
}
