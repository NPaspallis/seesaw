import 'package:flutter/cupertino.dart';
import 'package:seesaw/tilt_direction.dart';

class StateModel extends ChangeNotifier {

  TiltDirection _tiltDirection = TiltDirection.loop;

  TiltDirection get tiltDirection => _tiltDirection;

  void setTiltDirection(final TiltDirection tiltDirection) {
    _tiltDirection = tiltDirection;
    notifyListeners();
  }
}