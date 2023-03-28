import 'package:flutter/material.dart';

void pushScreen(BuildContext context, Widget screen) {
  Route targetScreen = MaterialPageRoute(builder: (context) => screen);
  Navigator.push(context, targetScreen);
}

void replaceScreen(BuildContext context, Widget screen) {
  Route targetScreen = MaterialPageRoute(builder: (context) => screen);
  Navigator.pushReplacement(context, targetScreen);
}
