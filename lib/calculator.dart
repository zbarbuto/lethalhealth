import 'package:flutter/material.dart';

import 'keypad_keys.dart';

class Calculator extends StatefulWidget {
  final Color color;
  final int health;
  final Function onHealth;

  Calculator({
    required this.color,
    required this.health,
    required this.onHealth,
  });

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
              childAspectRatio: 3.8,
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              children: [
                ElevatedButton(
                  onPressed: () {
                    widget.onHealth(1);
                  },
                  child: Text('1'),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.black),
                    foregroundColor: WidgetStatePropertyAll(Colors.amber),
                    textStyle: WidgetStatePropertyAll(
                      TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.onHealth(5);
                  },
                  child: Text('5'),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.black),
                    foregroundColor: WidgetStatePropertyAll(Colors.amber),
                    textStyle: WidgetStatePropertyAll(
                      TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.onHealth(10);
                  },
                  child: Text('10'),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.black),
                    foregroundColor: WidgetStatePropertyAll(Colors.amber),
                    textStyle: WidgetStatePropertyAll(
                      TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                ...Keypad.values
                    .map(
                      (Keypad key) => ElevatedButton(
                        onPressed: () {
                          _handleKey(key);
                        },
                        child: Text(key.toKeyLabel()),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
          Container(
            child: Center(
              child: Text(
                value.toString(),
                style: TextStyle(fontSize: 32),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _handleKey(Keypad key) {
    setState(() {
      if (key == Keypad.okay) {
        return _setValue();
      } else if (key == Keypad.del) {
        value =
            int.tryParse(
              value.toString().substring(0, value.toString().length - 1),
            ) ??
            0;
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
