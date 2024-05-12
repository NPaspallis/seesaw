import 'package:flutter/cupertino.dart';

enum SeesawState {
  welcome,
  choosePerspective,
  perspectivePolicyMaker,
  perspectiveCommitteeMember,
  doHcsRefresher,
  chooseHcsVideos,
  sortProsCons,
  makeDecisionBeforeCharlesWeijerVideo,
  showStatsBeforeCharlesWeijerVideo,
  charlesWeijerVideo,
  makeDecisionAfterCharlesWeijerVideo,
  showStatsAfterCharlesWeijerVideo,
  chooseEvaluation,
  evaluation,
  thankYou
}

class StateModel extends ChangeNotifier {

  SeesawState _seesawState = SeesawState.sortProsCons;

  SeesawState get seesawState => _seesawState;

  void setSeesawState(SeesawState seesawState) {
    _seesawState = seesawState;
    notifyListeners();
  }

  void progressToNextSeesawState() {
    var allValues = SeesawState.values;
    int nextSeesawStateIndex = (_seesawState.index + 1) % allValues.length;
    SeesawState nextSeesawState = allValues[nextSeesawStateIndex];
    setSeesawState(nextSeesawState);
  }
}