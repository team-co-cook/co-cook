import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:co_cook/screens/splash_screen/splash_screen.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  await dotenv.load(fileName: ".env.local");

  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
    );
  }
}
