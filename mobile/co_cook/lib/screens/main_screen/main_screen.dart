import 'package:co_cook/screens/search_screen/search_screen.dart';
import 'package:co_cook/screens/user_screen/user_screen.dart';
import 'package:co_cook/widgets/sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
  final PanelController _mainPanelController =
      PanelController(); // 새 PanelController 추가

  // 화면 인텍스 변경 함수
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          child: [
            const HomeScreen(),
            Container(
              child: Text("냉털"),
            ),
            SearchScreen(),
            UserScreen(),
          ][_currentIndex],
        ),
        CustomSlidingUpPanel(
            body: Container(
              width: double.infinity,
              height: 1000,
              color: Colors.black,
            ),
            panelController: _mainPanelController)
      ]),
      bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onTap,
          panelController: _mainPanelController),
    );
  }
}
