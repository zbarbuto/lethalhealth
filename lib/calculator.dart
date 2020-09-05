import 'package:flutter/material.dart';

import 'keypad_keys.dart';

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
      padding: EdgeInsets.only(top: 24),
      color: widget.color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: GridView.count(
                childAspectRatio: 2.8,
                crossAxisCount: 3,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                children: [
                  ...Keypad.values
                      .map((Keypad key) => RaisedButton(
                          onPressed: () {
                            _handleKey(key);
                          },
                          child: Text(key.toKeyLabel())))
                      .toList()
                ]),
          ),
          Container(
            child: Center(
              child: Text(
                value.toString(),
                style: TextStyle(fontSize: 32),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  _handleKey(Keypad key) {
    setState(() {
      if (key == Keypad.okay) {
        return _setValue();
      } else if (key == Keypad.del) {
        value = int.parse(
            value.toString().substring(0, value.toString().length - 1),
            onError: (_) => 0);
        return;
      } else if (value == 0) {
        value = key.toInt();
      } else {
        value = int.parse(value.toString() + key.toInt().toString());
      }
    });
  }

  _setValue() {
    widget.onHealth(value);
  }
}
