import 'package:flutter/material.dart';
import 'package:lethal_health/player.dart';
import 'package:lethal_health/player_card.dart';

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
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 18.0),
                  child: Text(
                    'Turn',
                    style: TextStyle(fontSize: 28),
                  ),
                )),
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
