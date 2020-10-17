import 'package:flutter/material.dart';
import 'package:lethal_health/player.dart';

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
