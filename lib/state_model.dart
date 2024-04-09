import 'package:flutter/cupertino.dart';
import 'package:seesaw/tilt_direction.dart';

enum SeesawState {
  welcome,
  choosePerspective,
  perspectivePolicyMaker,
  perspectiveCommitteeMember,
  chooseHcsRefresher,
  chooseHcsRefresherGo,
  evaluation,
  thankYou
}

class StateModel extends ChangeNotifier {

  SeesawState _seesawState = SeesawState.welcome;

  SeesawState get seesawState => _seesawState;

  void setSeesawState(SeesawState seesawState) {
    _seesawState = seesawState;
    notifyListeners();
  }
}