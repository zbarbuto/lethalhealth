import 'package:flutter/material.dart';
import 'package:lethal_health/health_mode.dart';

class HealthManager extends StatelessWidget {
  final int health;
  final Color color;
  final bool hasCoin;
  final Function onHealth;
  final Function onCoin;
  final Function onSettings;

  HealthManager(
      {this.health = 0,
      this.hasCoin,
      this.color = Colors.cyan,
      this.onHealth,
      this.onSettings,
      this.onCoin});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    child: FittedBox(
                      child: FloatingActionButton(
                        onPressed: () {
                          onCoin();
                        },

                        backgroundColor: hasCoin
                            ? Colors.yellow.shade300
                            : Colors.grey.shade300,
                        foregroundColor: Colors.black,
                        // child: hasCoin
                        //     ? Icon(Icons.monetization_on_outlined)
                        //     : Icon(Icons.money_off_outlined),
                      ),
                    ),
                  ),
                  IgnorePointer(
                    child: Container(
                      child: Text(
                        this.health.toString(),
                        style: TextStyle(fontSize: 42),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                onPressed: () {
                  onHealth(HealthMode.subtract);
                },
                backgroundColor: Colors.red.shade900,
                child: Icon(Icons.remove),
              ),
              FloatingActionButton(
                backgroundColor: Colors.blueGrey.shade300,
                child: Icon(Icons.settings),
                onPressed: () {
                  onSettings();
                },
              ),
              FloatingActionButton(
                onPressed: () {
                  onHealth(HealthMode.add);
                },
                backgroundColor: Colors.green.shade400,
                child: Icon(Icons.add),
              ),
            ],
          )
        ],
      ),
    );
  }
}
