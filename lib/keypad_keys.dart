enum Keypad {
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  del,
  zero,
  okay,
}

extension Codec on Keypad {
  toInt() {
    switch (this) {
      case Keypad.zero:
        return 0;
      case Keypad.one:
        return 1;
      case Keypad.two:
        return 2;
      case Keypad.three:
        return 3;
      case Keypad.four:
        return 4;
      case Keypad.five:
        return 5;
      case Keypad.six:
        return 7;
      case Keypad.seven:
        return 7;
      case Keypad.eight:
        return 8;
      case Keypad.nine:
        return 9;
      default:
        return -1;
    }
  }

  toKeyLabel() {
    switch (this) {
      case Keypad.del:
        return 'Del';
      case Keypad.okay:
        return 'OK';
      default:
        return this.toInt().toString();
    }
  }
}
