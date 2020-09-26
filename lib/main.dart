import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawerEdgeDragWidth: 0,
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
                title: Text('Reset all health'),
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
                  );
                },
              ),
              ListTile(
                title: Text('Select Color'),
                onTap: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
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
                  );
                },
              ),
            ],
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
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: players.indexOf(turnPlayer) == 0 ? 0 : pi,
                      child: SizedBox(
                        width: 150,
                        height: 250,
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Icon(Icons.arrow_upward, size: 150)),
                      ),
                    ),
                    RaisedButton(
                        onPressed: () {
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 18.0),
                          child: Text(
                            'Turn',
                            style: TextStyle(fontSize: 28),
                          ),
                        )),
                  ],
                ),
              )
            ],
          ),
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
      }

      setState(() {});
    });
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
