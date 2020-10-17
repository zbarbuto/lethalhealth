import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:lethal_health/health_mode.dart';
import 'package:lethal_health/player.dart';
import 'package:lethal_health/player_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
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
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<Player> players = [
    Player(color: Colors.lightBlue.shade300),
    Player(color: Colors.red.shade200)
  ];

  Player contextPlayer;
  Player turnPlayer;
  TextEditingController startHealthController =
      TextEditingController(text: '30');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEdgeDragWidth: 0,
      drawer: Transform.rotate(
        angle: _faceCurrentPlayer(),
        child: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
                title: Text('Reset Health'),
                onTap: () {
                  setState(() {
                    players.forEach((element) {
                      element.health = element.startHealth;
                    });
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Flip a Coin'),
                onTap: () {
                  Navigator.of(context).pop();
                  final result = Random().nextBool();
                  showDialog(
                    context: context,
                    child: Transform.rotate(
                      angle: _faceCurrentPlayer(),
                      child: AlertDialog(
                        content: SingleChildScrollView(
                          child: Text(result ? 'Heads' : 'Tails'),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: const Text('Done'),
                            onPressed: () {
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Select Color'),
                onTap: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    child: Transform.rotate(
                      angle: _faceCurrentPlayer(),
                      child: AlertDialog(
                        title: const Text('Pick a color!'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: Colors.red,
                            onColorChanged: (color) {
                              setState(() {
                                contextPlayer.color = color;
                              });
                              _storePlayerSettings(contextPlayer);
                            },
                            showLabel: true,
                            pickerAreaHeightPercent: 0.8,
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: const Text('Done'),
                            onPressed: () {
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Set Starting Health'),
                onTap: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    child: Transform.rotate(
                      angle: _faceCurrentPlayer(),
                      child: AlertDialog(
                        title: const Text('Enter Start Health'),
                        content: TextField(
                          controller: startHealthController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter health'),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: const Text('Done'),
                            onPressed: () {
                              setState(() {
                                _storePlayerStartHealth(int.parse(
                                    startHealthController.text, onError: (_) {
                                  startHealthController.text = '30';
                                  return 30;
                                }));
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Builder(
        builder: (context) => Stack(
          children: [
            Center(
              child: Column(
                  children: players
                      .map((player) => PlayerCard(
                            onSettings: () {
                              setState(() {
                                contextPlayer = player;
                              });
                              Scaffold.of(context).openDrawer();
                            },
                            inverted: players.indexOf(player) == 0,
                            player: player,
                            updatePlayers: _updatePlayers,
                          ))
                      .toList()),
            ),
            Center(
              child: CenterContent(
                onTurn: () {
                  players.forEach((player) {
                    player.hasCoin = true;
                    _updatePlayers();
                  });
                  setState(() {
                    turnPlayer = players.indexOf(turnPlayer) == 0
                        ? players[1]
                        : players[0];
                  });
                },
                players: players,
                turnPlayer: turnPlayer,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _prefs.then((prefs) {
      for (var i = 0; i < players.length; i++) {
        var colorString = prefs.getString('player${i}color') ??
            players[i].color.value.toRadixString(16);
        players[i].color = HexColor(colorString);
        players[i].startHealth = prefs.getInt('playerStartHealth') ?? 30;
        players[i].health = players[i].startHealth;
      }

      startHealthController.text = players[0].startHealth.toString();

      setState(() {});
    });
  }

  _faceCurrentPlayer() {
    return players.indexOf(contextPlayer) == 0 ? pi : 0;
  }

  _updatePlayers() {
    setState(() {
      players = [...players];
    });
  }

  _storePlayerSettings(Player player) {
    int index = players.indexOf(player);
    _prefs.then((SharedPreferences prefs) {
      prefs.setString(
          'player${index}color', player.color.value.toRadixString(16));
    });
  }

  _storePlayerStartHealth(int health) {
    players.forEach((element) {
      element.startHealth = health;
      element.health = element.startHealth;
    });
    _prefs.then((SharedPreferences prefs) {
      prefs.setInt('playerStartHealth', health);
    });
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class CenterContent extends StatefulWidget {
  final List<Player> players;
  final Player turnPlayer;
  final Function onTurn;

  CenterContent({this.players, this.turnPlayer, this.onTurn});

  @override
  _CenterContentState createState() => _CenterContentState();
}

class _CenterContentState extends State<CenterContent>
    with SingleTickerProviderStateMixin {
  final Tween<double> turnsTween = Tween<double>(
    begin: 0,
    end: 0.5,
  );

  AnimationController _controller;

  initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    super.initState();
  }

  @override
  void didUpdateWidget(CenterContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.players.indexOf(widget.turnPlayer) == 0
        ? _controller.forward()
        : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RotationTransition(
          turns: turnsTween.animate(_controller),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Visibility(
                visible: widget.players
                    .map((element) => element.editHealthMode)
                    .reduce(
                      (value, element) => !value && !element,
                    ),
                child: SizedBox(
                  width: 100,
                  height: 200,
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Icon(Icons.arrow_drop_down, size: 100)),
                ),
              ),
              RaisedButton(
                  onPressed: () {
                    widget.onTurn();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 18.0),
                    child: Text(
                      'Turn',
                      style: TextStyle(fontSize: 28),
                    ),
                  )),
            ],
          ),
        )
      ],
    );
  }
}
