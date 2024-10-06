import 'package:flutter/cupertino.dart';

enum SeesawState {
  welcome,
  choosePerspective,

  perspectivePolicyMaker,
  doTriageRefresher,
  chooseTriageResources,
  makeTriageDecisionBefore,
  showTriageStatsBeforeVideo,
  triageExpertVideo,
  makeTriageDecisionAfter,
  showTriageStatsAfterVideo,

  perspectiveCommitteeMember,
  doHcsRefresher,
  chooseHcsVideos,
  sortProsCons,
  makeDecisionBeforeCharlesWeijerVideo,
  showStatsBeforeCharlesWeijerVideo,
  charlesWeijerVideo,
  makeDecisionAfterCharlesWeijerVideo,
  showStatsAfterCharlesWeijerVideo,

  // chooseEvaluation,
  // evaluation,
  thankYou,
}

class StateModel extends ChangeNotifier {

  SeesawState _seesawState = SeesawState.welcome;

  SeesawState get seesawState => _seesawState;

  double getProgress() {
    var allValues = SeesawState.values;
    final indexOfChoosePerspective = allValues.indexOf(SeesawState.choosePerspective);
    final indexOfPartPolicyMakerEnd = allValues.indexOf(SeesawState.showTriageStatsAfterVideo);
    final indexOfPartCommitteeMemberEnd = allValues.indexOf(SeesawState.showStatsAfterCharlesWeijerVideo);
    final numOfStatesInPolicyMakerRoute = indexOfPartPolicyMakerEnd - indexOfChoosePerspective;
    final numOfStatesInCommitteeMemberRoute = indexOfPartCommitteeMemberEnd - indexOfPartPolicyMakerEnd;
    final numOfStatesInTheEnd = allValues.length - indexOfPartCommitteeMemberEnd;

    final index = _seesawState.index - indexOfChoosePerspective;
    // debugPrint('**  index: $index, numOfStatesInPolicyMakerRoute: $numOfStatesInPolicyMakerRoute, numOfStatesInCommitteeMemberRoute: $numOfStatesInCommitteeMemberRoute, numOfStatesInTheEnd: $numOfStatesInTheEnd');
    if(_seesawState.index <= indexOfPartPolicyMakerEnd) { // following the PolicyMaker path
      // debugPrint('<<< ${_seesawState.index / (numOfStatesInPolicyMakerRoute + numOfStatesInTheEnd)}');
      return _seesawState.index / (numOfStatesInPolicyMakerRoute + numOfStatesInTheEnd);
    } else {
      // debugPrint('>>> ${(_seesawState.index - numOfStatesInPolicyMakerRoute) / (numOfStatesInCommitteeMemberRoute + numOfStatesInTheEnd)}');
      return (_seesawState.index - numOfStatesInPolicyMakerRoute) / (numOfStatesInCommitteeMemberRoute + numOfStatesInTheEnd);
    }
  }

  void setSeesawState(final SeesawState seesawState) {
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