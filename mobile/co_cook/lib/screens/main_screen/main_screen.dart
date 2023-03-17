import 'package:co_cook/screens/user_screen/user_screen.dart';
import 'package:flutter/material.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

import 'package:co_cook/screens/home_screen/home_screen.dart';
import 'package:co_cook/widgets/bottom_nav_bar/bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // 화면 인덱스 초기화

  // 화면 인텍스 변경 함수
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        const HomeScreen(),
        Container(
          child: Text("냉털"),
        ),
        Container(
          child: Text("search"),
        ),
        UserScreen(),
      ][_currentIndex],
      bottomNavigationBar:
          BottomNavBar(currentIndex: _currentIndex, onTap: _onTap),
    );
  }
}
