import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

enum HealthMode { none, add, subtract }

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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        //
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Player> players = [
    Player(color: Colors.lightBlue.shade300),
    Player(color: Colors.red.shade200)
  ];

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
                children: players
                    .map((player) => PlayerCard(
                          inverted: players.indexOf(player) == 0,
                          player: player,
                          updatePlayers: _updatePlayers,
                        ))
                    .toList()),
          ),
          Center(
            child: RaisedButton(
                onPressed: () {
                  players.forEach((player) {
                    player.hasCoin = true;
                    _updatePlayers();
                  });
                },
                child: Text('Turn')),
          )
        ],
      ),
    );
  }

  _updatePlayers() {
    setState(() {
      players = [...players];
    });
  }
}

class PlayerCard extends StatelessWidget {
  final Player player;
  final Function updatePlayers;
  final bool inverted;

  PlayerCard({this.player, this.updatePlayers, this.inverted = false});

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

class Calculator extends StatefulWidget {
  final Color color;
  final int health;
  final Function onHealth;

  Calculator({this.color, this.health, this.onHealth});

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  int value = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      child: GridView.count(
          childAspectRatio: 2.8,
          crossAxisCount: 3,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          children: [
            ...List.generate(
                12,
                (index) => RaisedButton(
                    onPressed: () {
                      _addValue(index == 10
                          ? -1
                          : index == 11 ? -2 : (index + 1) % 10);
                    },
                    child: index == 10
                        ? Text('OK')
                        : index == 11
                            ? Text('Del')
                            : Text(((index + 1) % 10).toString()))),
            Center(
              child: Text(
                value.toString(),
                style: TextStyle(fontSize: 25),
              ),
            )
          ]),
    );
  }

  _addValue(int _value) {
    setState(() {
      if (_value == -1) {
        _setValue();
      } else if (value == 0) {
        value = _value > 0 ? _value : 0;
      } else if (_value == -2) {
        value = int.parse(
            value.toString().substring(0, value.toString().length - 1),
            onError: (_) => 0);
      } else {
        value = int.parse(value.toString() + _value.toString());
      }
    });
  }

  _setValue() {
    widget.onHealth(value);
  }
}

class HealthManager extends StatelessWidget {
  final int health;
  final Color color;
  final bool hasCoin;
  final Function onHealth;
  final Function onCoin;

  HealthManager(
      {this.health = 0,
      this.hasCoin,
      this.color = Colors.cyan,
      this.onHealth,
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
              child: Container(
                child: Text(
                  this.health.toString(),
                  style: TextStyle(fontSize: 42),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                onPressed: () {
                  onHealth(HealthMode.add);
                },
                backgroundColor: Colors.green.shade300,
                child: Icon(Icons.add),
              ),
              FloatingActionButton(
                onPressed: () {
                  onCoin();
                },
                backgroundColor:
                    hasCoin ? Colors.yellow.shade300 : Colors.grey.shade300,
                foregroundColor: Colors.black,
                child: hasCoin
                    ? Icon(Icons.monetization_on_outlined)
                    : Icon(Icons.money_off_outlined),
              ),
              FloatingActionButton(
                onPressed: () {
                  onHealth(HealthMode.subtract);
                },
                backgroundColor: Colors.red.shade300,
                child: Icon(Icons.remove),
              ),
            ],
          )
        ],
      ),
    );
  }
}
