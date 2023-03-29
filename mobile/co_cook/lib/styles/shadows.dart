import 'package:flutter/material.dart';

class CustomShadows {
  const CustomShadows();

  static const Shadow text = Shadow(
    color: Color.fromARGB(255, 0, 0, 0),
    offset: Offset(1, 1),
    blurRadius: 30.0,
  );
  static const BoxShadow card = BoxShadow(
    color: Colors.black26,
    offset: Offset(1, 1),
    blurRadius: 6.0,
    spreadRadius: 0.0,
  );
}
