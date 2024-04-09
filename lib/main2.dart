import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/perspective_committee_member.dart';
import 'package:seesaw/seesaw.dart';
import 'package:seesaw/state_model.dart';

import 'buttons.dart';
import 'choose_hcs_refresher.dart';

const preparedPrimaryColor = Color(0xFF007689);
const preparedSecondaryColor = Color(0xFF97C13C);
const preparedShadeColor = Color(0xFF006272);
const preparedDarkShadeColor = Color(0xFF59862B);
const preparedWhiteColor = Color(0xFFFFFFFF);
const preparedBlueColor = Color(0xFF17486A);
const preparedGreyColor = Colors.grey;
const preparedBallColors = [
  preparedBlueColor,
  Color(0xFFDD1667),
  Color(0xFF29BCE2),
  Color(0xFFFD9E22),
  Color(0xFFE7263B),
  Color(0xFFA21A3F),
  Color(0xFF9C1567),
  preparedBlueColor,
  Color(0xFFDD1667),
  Color(0xFF29BCE2),
  Color(0xFFFD9E22),
  Color(0xFFE7263B),
  Color(0xFFA21A3F),
  Color(0xFF9C1567),
];

const double largeTextSize = 42;
const double textSizeMedium = 36;
const double textSizeSmall = 24;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => StateModel(),
      child: const SeesawApp(),
    ),
  );
}

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

  void pressedStart() {
    debugPrint('choosePerspective');
    final StateModel stateModel =
        Provider.of<StateModel>(context, listen: false);
    stateModel.setSeesawState(SeesawState.choosePerspective);
    _scrollController.animateTo(_scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
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
    debugPrint('reset');

    // show the dialog
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
          title: const Text('Reset?'),
          content: const Text('Are you sure you want to reset? All your progress will be lost.', style: TextStyle(fontSize: textSizeSmall)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(fontSize: textSizeSmall))),
            TextButton(onPressed: () { _doResetInteraction(); Navigator.pop(context); }, child: const Text('Reset', style: TextStyle(fontSize: textSizeSmall)))
          ],
          elevation: 24.0,
        )
    );
  }

  void _doResetInteraction() {
    debugPrint('doReset');
    final StateModel stateModel =
    Provider.of<StateModel>(context, listen: false);
    stateModel.setSeesawState(SeesawState.welcome);
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  Widget _getMainContainer(final StateModel state) { // must add up to 2/3 of height
    switch (state.seesawState) {
      case SeesawState.welcome:
        return getWelcomeWidget();
      case SeesawState.choosePerspective:
        return getChoosePerspectiveWidget();
      case SeesawState.perspectivePolicyMaker:
        return const Text('error: todo'); //todo
      case SeesawState.perspectiveCommitteeMember:
        return const PerspectiveCommitteeMember();
      case SeesawState.chooseHcsRefresher:
        return const HcsChooseRefresher();
      default:
        return Text('error: unknown state: ${state.seesawState}', style: const TextStyle(color: Colors.red));
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
    debugPrint('seesawState: $seesawState');
    switch(seesawState) {
      case SeesawState.choosePerspective:
        return 'Choose perspective';
      case SeesawState.perspectiveCommitteeMember:
        return 'Perspective | Research ethics committee member';
      case SeesawState.perspectivePolicyMaker:
        return 'Perspective | Policy maker';
      case SeesawState.welcome:
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
            padding: const EdgeInsets.fromLTRB(textSizeSmall, 0, 0 ,0),
            child: Text(
              label,
              style: const TextStyle(fontSize: textSizeSmall, color: preparedSecondaryColor, fontWeight: FontWeight.normal, decoration: TextDecoration.none),
            )
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0 , textSizeSmall, 0),
            child: Builder(
              builder: (context) => ElevatedButton(
                  onPressed: () => _resetInteraction(context),
                  child: const Row(
                    children: [
                      Icon(Icons.reset_tv),
                      SizedBox(width: 10),
                      Text('RESET')
                    ],
                  )
              )
            )
          ),
        ],
      )
    );
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
              style: TextStyle(fontSize: largeTextSize,
                  color: preparedWhiteColor, decoration: TextDecoration.none)),
        )));
  }

  Widget getWelcomeWidget() {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 2 / 3,
        child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
                width: 300,
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                  child: getElevatedButtonWithPreparedLabel(
                      context, 'Press to Start', pressedStart),
                ))));
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
                  fontSize: 32,
                  color: preparedWhiteColor,
                  decoration: TextDecoration.none),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    width: 300,
                    height: 300,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                      child: getElevatedButtonWithPreparedLabel(
                          context, 'Policy Maker', choosePolicyMaker),
                    )),
                Visibility(
                    visible: _seesawState == SeesawState.welcome,
                    child: SizedBox(
                        width: 300,
                        height: 300,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                          child: getElevatedButtonWithPreparedLabel(
                              context,
                              'Research Ethics Committee Member',
                              chooseCommitteeMember),
                        )))
              ],
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    // scroll down when first loaded
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
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
                                        visible: _seesawState != SeesawState.welcome,
                                        child: _getTopContainer()), // 1/6
                                    _getMainContainer(state), // 2/3
                                    _getBalancingSeesaw(),  // 1/3
                                    Visibility(
                                        visible: _seesawState == SeesawState.welcome,
                                        child: _getBottomWidget()) // 1/6
                                  ]
                              );
                            }
                        )
                    ))))
        );
  }
}
