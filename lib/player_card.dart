import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lethal_health/calculator.dart';
import 'package:lethal_health/health_manager.dart';
import 'package:lethal_health/player.dart';

import 'health_mode.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  final Function updatePlayers;
  final Function onSettings;
  final bool inverted;

  PlayerCard(
      {this.player,
      this.updatePlayers,
      this.onSettings,
      this.inverted = false});

  @override
  Widget build(BuildContext context) {
    final content = player.editHealthMode
        ? Calculator(
            onHealth: (int health) {
              player.health = player.healthMode == HealthMode.add
                  ? player.health + health
                  : player.health - health;
              player.healthMode = HealthMode.none;
              updatePlayers();
            },
            health: player.health,
            color: player.color)
        : HealthManager(
            onSettings: onSettings,
            onHealth: (HealthMode mode) {
              player.healthMode = mode;
              updatePlayers();
            },
            onCoin: () {
              player.hasCoin = !player.hasCoin;
              updatePlayers();
            },
            hasCoin: player.hasCoin,
            color: player.color,
            health: player.health,
          );
    return Expanded(
        child:
            inverted ? Transform.rotate(angle: pi, child: content) : content);
  }
}
