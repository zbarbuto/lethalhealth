import 'dart:ui';

import 'health_mode.dart';

class Player {
  HealthMode healthMode = HealthMode.none;
  int startHealth;
  int health;
  bool hasCoin = true;
  Color color;

  get editHealthMode {
    return healthMode != HealthMode.none;
  }

  Player({required this.color, this.startHealth = 30})
    : this.health = startHealth;
}
