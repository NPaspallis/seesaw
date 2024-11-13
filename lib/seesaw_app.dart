import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/auto_timeout_layer.dart';
import 'package:seesaw/charles_weijer_video.dart';
import 'package:seesaw/choose_hcs_videos.dart';
import 'package:seesaw/choose_triage_resources.dart';
import 'package:seesaw/make_decision_before_video.dart';
import 'package:seesaw/make_triage_decision_after_video.dart';
import 'package:seesaw/make_triage_decision_before_video.dart';
import 'package:seesaw/perspective_committee_member.dart';
import 'package:seesaw/perspective_policy_maker.dart';
import 'package:seesaw/secret_stats_screen.dart';
import 'package:seesaw/seesaw_widget.dart';
import 'package:seesaw/show_stats_after_video.dart';
import 'package:seesaw/show_stats_before_video.dart';
import 'package:seesaw/show_triage_stats_after_video.dart';
import 'package:seesaw/show_triage_stats_before_video.dart';
import 'package:seesaw/sort_pros_cons.dart';
import 'package:seesaw/state_model.dart';
import 'package:seesaw/thank_you.dart';
import 'package:seesaw/triage_expert_video.dart';
import 'package:seesaw/triage_refresher_video.dart';
import 'package:seesaw/welcome.dart';

import 'buttons.dart';
import 'choose_perspective.dart';
import 'classroom_screen.dart';
import 'splash_video.dart';
import 'hcs_refresher_video.dart';
import 'main.dart';
import 'make_decision_after_video.dart';

const defaultClassroomUUID = "kioskUUID";
const defaultClassroomName = "kiosk";

class SeesawApp extends StatelessWidget {
  const SeesawApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      routes: {
        "/": (context) => HomeScreen(classroomUUID: Uri.base.queryParameters['uuid'] ?? defaultClassroomUUID, classroomName: Uri.base.queryParameters['name'] ?? defaultClassroomName),
        "/kiosk": (context) => const HomeScreen(kioskMode: true),
        "/stats":  (context) => const SecretStatsScreen(),
        "/classroom":  (context) => const ClassroomScreen(),
      },
    );
  }
}

const version = '24.11.13+1';

class HomeScreen extends StatefulWidget {
  final String classroomUUID;
  final String classroomName;
  final bool kioskMode;
  const HomeScreen({super.key, this.classroomUUID = defaultClassroomUUID, this.classroomName = defaultClassroomName, this.kioskMode = false});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  late BalancingSeesaw _balancingSeesaw;
  late SeesawState _seesawState;

  late SplashVideo _splashVideo;

  @override
  void initState() {
    super.initState();
    // if in kiosk mode, show splash video
    _seesawState = SeesawState.welcome;

    _splashVideo = const SplashVideo();

    // debug info
    // debugPrint('classroomUUID: ${widget.classroomUUID}');
    // debugPrint('classroomName: ${widget.classroomName}');
    debugPrint('kioskMode: ${widget.kioskMode}');
  }

  @override
  void activate() {
    super.activate();
    _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease);
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

  void _showSplashVideo() {
    final StateModel stateModel =
        Provider.of<StateModel>(context, listen: false);
    stateModel.setSplashVideoOn();
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

      // perspective policy maker views
      case SeesawState.perspectivePolicyMaker:
        return PerspectivePolicyMaker(classroomUUID: widget.classroomUUID);
      case SeesawState.doTriageRefresher:
        return const TriageRefresherVideo();
      case SeesawState.chooseTriageResources:
        return const ChooseTriageResources();
      case SeesawState.makeTriageDecisionBefore:
        return MakeTriageDecisionBeforeVideo(classroomUUID: widget.classroomUUID);
      case SeesawState.showTriageStatsBeforeVideo:
        return ShowTriageStatsBeforeVideo(classroomUUID: widget.classroomUUID);
      case SeesawState.triageExpertVideo:
        return const TriageExpertVideo();
      case SeesawState.makeTriageDecisionAfter:
        return MakeTriageDecisionAfterVideo(classroomUUID: widget.classroomUUID);
      case SeesawState.showTriageStatsAfterVideo:
        return ShowTriageStatsAfterVideo(classroomUUID: widget.classroomUUID);

      // perspective committee member views
      case SeesawState.perspectiveCommitteeMember:
        return PerspectiveCommitteeMember(classroomUUID: widget.classroomUUID,);
      case SeesawState.doHcsRefresher:
        return const HcsRefresherVideo();
      case SeesawState.chooseHcsVideos:
        return const ChooseHcsVideos();
      case SeesawState.sortProsCons:
        return const SortProsCons();
      case SeesawState.makeDecisionBeforeCharlesWeijerVideo:
        return MakeDecisionBeforeVideo(classroomUUID: widget.classroomUUID);
      case SeesawState.showStatsBeforeCharlesWeijerVideo:
        return ShowStatsBeforeVideo(classroomUUID: widget.classroomUUID);
      case SeesawState.charlesWeijerVideo:
        return const CharlesWeijerVideo();
      case SeesawState.makeDecisionAfterCharlesWeijerVideo:
        return MakeDecisionAfterVideo(classroomUUID: widget.classroomUUID);
      case SeesawState.showStatsAfterCharlesWeijerVideo:
        return ShowStatsAfterVideo(classroomUUID: widget.classroomUUID);


      // evaluation
      // case SeesawState.chooseEvaluation:
      //   return const ChooseEvaluation();
      // case SeesawState.evaluation:
      //   return const EvaluationPage();
      case SeesawState.thankYou:
        return ThankYou(_scrollController);
      default:
        return Text('error: unknown state: ${state.seesawState}',
            style: const TextStyle(color: Colors.red));
    }
  }

  String _getNavigationLabel(final SeesawState seesawState) {
    switch (seesawState) {
      case SeesawState.choosePerspective:
        return 'Choose perspective ...';
      case SeesawState.perspectivePolicyMaker:
        return 'Policy maker perspective';
      case SeesawState.doTriageRefresher:
        return 'Policy maker perspective | Crisis Triage refresher';
      case SeesawState.chooseTriageResources:
        return 'Policy maker perspective | Different perspectives';
      case SeesawState.makeTriageDecisionBefore:
        return 'Policy maker perspective | What is your decision?';
      case SeesawState.showTriageStatsBeforeVideo:
        return 'Policy maker perspective | See what others have decided';
      case SeesawState.triageExpertVideo:
        return 'Policy maker perspective | Expert\'s view';
      case SeesawState.makeTriageDecisionAfter:
        return 'Policy maker perspective | What is your decision after this video?';
      case SeesawState.showTriageStatsAfterVideo:
        return 'Policy maker perspective | See how others have decided';

      case SeesawState.perspectiveCommitteeMember:
        return 'Research ethics committee member perspective';
      case SeesawState.doHcsRefresher:
        return 'Research ethics committee member perspective | Human Challenge Studies refresher';
      case SeesawState.chooseHcsVideos:
        return 'Research ethics committee member perspective | Videos of different perspectives';
      case SeesawState.sortProsCons:
        return 'Research ethics committee member perspective | Identify pros and cons of Human Challenge Studies';
      case SeesawState.makeDecisionBeforeCharlesWeijerVideo:
        return 'Research ethics committee member perspective | What is your decision?';
      case SeesawState.showStatsBeforeCharlesWeijerVideo:
        return 'Research ethics committee member perspective | See what others have decided';
      case SeesawState.charlesWeijerVideo:
        return 'Research ethics committee member perspective | Expert\'s view';
      case SeesawState.makeDecisionAfterCharlesWeijerVideo:
        return 'Research ethics committee member perspective | What is your decision after this video?';
      case SeesawState.showStatsAfterCharlesWeijerVideo:
        return 'Research ethics committee member perspective | See how others have decided';
      // case SeesawState.chooseEvaluation:
      //   return 'Proceed to evaluation?';
      // case SeesawState.evaluation:
      //   return 'Evaluation';
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
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 10),
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                    label,
                    style: const TextStyle(
                        fontSize: textSizeSmall,
                        color: preparedSecondaryColor,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.none),
                  ),
                )
            ),
            const Spacer(),
            Visibility(
              visible: !widget.kioskMode,
              child: Text(widget.classroomName, style: const TextStyle(color: preparedSecondaryColor, fontStyle: FontStyle.italic)),
            ),
            Padding(
                padding: const EdgeInsets.all(2),
                child: Builder(
                    builder: (context) => IconButton(
                        onPressed: () => _resetInteraction(context),
                        style: IconButton.styleFrom(padding: EdgeInsets.zero),
                        icon: const FittedBox(child: Icon(Icons.reset_tv, color: preparedSecondaryColor))
                    )
                )
            ),
          ],
        ));
  }

  Widget _getBottomWidget() {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Column(
                    children: [
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                            'An interactive experience demonstrating ethical tradeoffs in times of crisis',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: textSizeLarge,
                                color: preparedWhiteColor,
                                decoration: TextDecoration.none)),
                      ),
                    ],
                  )
                ),
              ),
              const Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 60, 20),
                    child: Text('Version: $version', style: TextStyle(color: Colors.grey)),
                  )
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: IconButton(iconSize: 24, icon: const Icon(Icons.ondemand_video_rounded), color: Colors.grey, onPressed: startScreensaver),
                  )
              ),
              Visibility(
                visible: !widget.kioskMode,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: IconButton(iconSize: 48, icon: const Icon(Icons.school), color: Colors.grey, onPressed: createClassroom),
                  ),
                )
              ),
            ]
        )
    );
  }

  void startScreensaver() {
    final StateModel stateModel = Provider.of<StateModel>(context, listen: false);
    stateModel.setSplashVideoOn();
  }

  void createClassroom() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ClassroomScreen()));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: AutoTimeoutLayer(
            callback: _showSplashVideo,
            child: Consumer<StateModel>(
                builder: (context, state, child) {
                  debugPrint('drawing main screen with state: ${state.seesawState}');
                  return state.splashVideo ? _splashVideo : buildInteractiveScreen(state);
                }
            )
        )
    );
  }

  Widget buildInteractiveScreen(StateModel state) {
    return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const NeverScrollableScrollPhysics(),
          child: Container(
              color: preparedPrimaryColor,
              child: Stack(
                children: [
                  Visibility(
                      visible: state.seesawState != SeesawState.thankYou,
                      child: Align(alignment: Alignment.topCenter, child: _getNavigationWidget(state.seesawState))
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Align(
                        alignment: Alignment.center,
                        child: _getMainContainer(state),
                      )
                  ),
                  Visibility(
                      visible: state.seesawState == SeesawState.welcome,
                      child: Align(alignment: Alignment.bottomCenter, child: _getBottomWidget())
                  ),
                ],
              )),
        )
    );
  }
}