import 'package:flutter/material.dart';

class ColorConstant {

  ColorConstant(Color foregroundColor);
  static const darkblue = Color(0xFF042A50);
  static const midnight = Color(0xff145da0);
  static const lightblue = Color(0xff2e8bc0);
  static const bluegrey = Color(0xffbfd7ed);
  static const white = Color.fromARGB(255, 255, 255, 255);
  static const grey = Color.fromARGB(205, 233, 229, 229);
  static const red = Color.fromARGB(210, 188, 24, 24);
  static const black = Colors.black;
  static const green = Color.fromARGB(255, 18, 214, 25);
  static const darkGreen = Color.fromARGB(255, 30, 69, 31);
  static const blue = Colors.blue;
  static const splashColor = Colors.black38;
  static const balance = Color.fromARGB(255, 127, 154, 182);
  static const amount = Color.fromARGB(255, 65, 122, 215);
  static var foregroundColor;
  static Color blueA70026 = fromHex('#26005cff');

  static Color pink40026 = fromHex('#26e84c88');

  static Color blueGray50 = fromHex('#f1f1f1');

  static Color lightBlue50026 = fromHex('#2600aff0');

  static Color indigoA100 = fromHex('#8982ff');

  static Color lightBlue80026 = fromHex('#260274b3');

  static Color blueA70066 = fromHex('#660062f5');

  static Color deepPurple300 = fromHex('#8871e4');

  static Color gray50 = fromHex('#f9f9f9');

  static Color teal300 = fromHex('#5bcaa1');

  static Color black900 = fromHex('#000000');

  static Color indigo5001 = fromHex('#e4e2ff');

  static Color indigo5002 = fromHex('#e4e3ff');

  static Color greenA70026 = fromHex('#261dd75f');

  static Color deepPurpleA400 = fromHex('#5c33f6');

  static Color blueGray100 = fromHex('#cccccc');

  static Color gray500 = fromHex('#aaaaaa');

  static Color blueGray400 = fromHex('#888888');

  static Color indigo50 = fromHex('#ebeafd');

  static Color black9000f = fromHex('#0f000000');

  static Color black9000c = fromHex('#0c000000');

  static Color gray200 = fromHex('#eeeeee');

  static Color teal80026 = fromHex('#26007348');

  static Color gray300 = fromHex('#dddddd');

  static Color amber60026 = fromHex('#26ffb700');

  static Color gray30001 = fromHex('#e6e6e6');

  static Color gray100 = fromHex('#f3f3f3');

  static Color blue7005b = fromHex('#5b2472d5');

  static Color deepPurple50 = fromHex('#edecff');

  static Color indigo100 = fromHex('#ccd6eb');

  static Color black90011 = fromHex('#11000000');

  static Color bluegray400 = fromHex('#888888');

  static Color whiteA70001 = fromHex('#fdfdfd');

  static Color gray40026 = fromHex('#26bbbbbb');

  static Color redA70026 = fromHex('#26e50812');

  static Color black90014 = fromHex('#14000000');

  static Color whiteA700 = fromHex('#ffffff');

  static Color orangeA500 = fromHex('#FFA500');

  static Color blue5baeb7 = fromHex('#5BAEB7');

  static Color bluePelorous = fromHex('#1E80C1');

  static Color tropicalBlue = fromHex('#B8CFEC');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
