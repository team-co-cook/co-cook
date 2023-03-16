import 'package:flutter/material.dart';
import 'styles/colors.dart';
import 'styles/text_styles.dart';
import 'package:co_cook/screens/splash_screen/splash_screen.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}
