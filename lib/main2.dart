import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/perspective_committee_member.dart';
import 'package:seesaw/seesaw.dart';
import 'package:seesaw/state_model.dart';
import 'package:seesaw/thank_you.dart';

import 'buttons.dart';

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
    final StateModel stateModel = Provider.of<StateModel>(context, listen: false);
    stateModel.setSeesawState(SeesawState.perspectivePolicyMaker);
  }

  void chooseCommitteeMember() {
    debugPrint('chose: chooseCommitteeMember');
    final StateModel stateModel = Provider.of<StateModel>(context, listen: false);
    stateModel.setSeesawState(SeesawState.perspectiveCommitteeMember);
  }

  Widget _getMainContainer() {
    return Consumer<StateModel>(builder: (context, state, child) {
      switch (state.seesawState) {
        case SeesawState.welcome:
          return getWelcomeWidget();
        case SeesawState.choosePerspective:
          return getChoosePerspectiveWidget();
        case SeesawState.perspectivePolicyMaker:
          return const Text('error: todo'); //todo
        case SeesawState.perspectiveCommitteeMember:
          return const PerspectiveCommitteeMember();
        default:
          return const Text('error: todo'); //todo
      }
    });
  }

  Widget _getBalancingSeesaw() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: _balancingSeesaw,
    );
  }

  Container _getBottomContainer() {
    return Container(
        height: MediaQuery.of(context).size.height / 3,
        alignment: Alignment.center,
        child: const Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 30),
            child: Text(
              'An interactive experience demonstrating ethical tradeoffs in times of crisis',
              style: TextStyle(
                  fontSize: 32,
                  color: preparedWhiteColor,
                  decoration: TextDecoration.none),
              textAlign: TextAlign.center,
            )));
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
          fontFamily: 'Open Sans',
          useMaterial3: true,
        ),
        home: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const NeverScrollableScrollPhysics(),
              child: Container(
                  color: preparedPrimaryColor,
                  height: MediaQuery.of(context).size.height * 4 / 3,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _getMainContainer(),
                        _getBalancingSeesaw(),
                        _getBottomContainer()
                      ])),
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
                  child: getElevatedButtonWithLabel(
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
                    fontSize: 32, color: preparedWhiteColor, decoration: TextDecoration.none), textAlign: TextAlign.center,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    width: 300,
                    height: 300,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                      child: getElevatedButtonWithLabel(
                          context, 'Policy Maker', choosePolicyMaker),
                    )),
                SizedBox(
                    width: 300,
                    height: 300,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                      child: getElevatedButtonWithLabel(context,
                          'Research Ethics Committee Member', chooseCommitteeMember),
                    ))
              ],
            )
          ],
        ));
  }
}
