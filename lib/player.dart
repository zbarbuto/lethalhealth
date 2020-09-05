import 'dart:ui';

import 'health_mode.dart';

class Player {
  HealthMode healthMode = HealthMode.none;
  int health = 30;
  bool hasCoin = true;
  Color color;

  get editHealthMode {
    return healthMode != HealthMode.none;
  }

  Player({this.color});
}
