import 'package:flutter/cupertino.dart';
import 'package:seesaw/tilt_direction.dart';

enum SeesawState {
  welcome,
  choosePerspective,
  perspectivePolicyMaker,
  perspectiveCommitteeMember,
  chooseHcsRefresher,
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

  // todo delete?
  TiltDirection _tiltDirection = TiltDirection.loop;

  TiltDirection get tiltDirection => _tiltDirection;

  void setTiltDirection(final TiltDirection tiltDirection) {
    _tiltDirection = tiltDirection;
    notifyListeners();
  }
}