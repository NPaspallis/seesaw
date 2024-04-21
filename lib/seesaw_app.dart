import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/charles_weijer_video.dart';
import 'package:seesaw/choose_hcs_videos.dart';
import 'package:seesaw/evaluation.dart';
import 'package:seesaw/make_decision_before_video.dart';
import 'package:seesaw/perspective_committee_member.dart';
import 'package:seesaw/seesaw_widget.dart';
import 'package:seesaw/show_stats_after_video.dart';
import 'package:seesaw/show_stats_before_video.dart';
import 'package:seesaw/state_model.dart';
import 'package:seesaw/thank_you.dart';
import 'package:seesaw/welcome.dart';

import 'buttons.dart';
import 'choose_hcs_refresher.dart';
import 'choose_perspective.dart';
import 'hcs_refresher_video.dart';
import 'main.dart';
import 'make_decision_after_video.dart';

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
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('CANCEL',
                        style: TextStyle(fontSize: textSizeSmall, fontWeight: FontWeight.bold, color: preparedSecondaryColor)))
                ),
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
        return const ChoosePerspective();
      case SeesawState.perspectivePolicyMaker:
        return const Text('error: todo'); //todo
      case SeesawState.perspectiveCommitteeMember:
        return const PerspectiveCommitteeMember();
      // case SeesawState.chooseHcsRefresher:
      //   return const HcsChooseRefresher();
      case SeesawState.doHcsRefresher:
        return const HcsRefresherVideo();
      case SeesawState.chooseHcsVideos:
        return const ChooseHcsVideos();
      case SeesawState.makeDecisionBeforeCharlesWeijerVideo:
        return const MakeDecisionBeforeVideo();
      case SeesawState.showStatsBeforeCharlesWeijerVideo:
        return const ShowStatsBeforeVideo();
      case SeesawState.charlesWeijerVideo:
        return const CharlesWeijerVideo();
      case SeesawState.makeDecisionAfterCharlesWeijerVideo:
        return const MakeDecisionAfterVideo();
      case SeesawState.showStatsAfterCharlesWeijerVideo:
        return const ShowStatsAfterVideo();
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
        return 'Choose Perspective ...';
      case SeesawState.perspectiveCommitteeMember:
        return 'Research ethics committee member Perspective';
      case SeesawState.perspectivePolicyMaker:
        return 'Policy maker Perspective';
      case SeesawState.doHcsRefresher:
        return 'Research ethics committee member Perspective | Human Challenge Studies Refresher';
      case SeesawState.chooseHcsVideos:
        return 'Research ethics committee member Perspective | Videos of Different Perspectives';
      case SeesawState.makeDecisionBeforeCharlesWeijerVideo:
        return 'Research ethics committee member Perspective | What is your Decision?';
      case SeesawState.showStatsBeforeCharlesWeijerVideo:
        return 'Research ethics committee member Perspective | See what others have Decided';
      case SeesawState.charlesWeijerVideo:
        return 'Research ethics committee member Perspective | Expert\'s View';
      case SeesawState.makeDecisionAfterCharlesWeijerVideo:
        return 'Research ethics committee member Perspective | What is your Decision after this Video?';
      case SeesawState.showStatsAfterCharlesWeijerVideo:
        return 'Research ethics committee member Perspective | See how others have Decided';
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
                            Icon(Icons.delete_forever, color: Colors.black, size: 16,),
                            SizedBox(width: 10),
                            Text('RESET', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold))
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
        debugShowCheckedModeBanner: false,
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
