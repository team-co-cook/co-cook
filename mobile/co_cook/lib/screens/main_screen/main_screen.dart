import 'package:co_cook/screens/voice_search_screen/voice_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:co_cook/widgets/favorite_direct/favorite_direct.dart';
import 'package:co_cook/widgets/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:co_cook/widgets/sliding_up_panel/sliding_up_panel.dart';

import 'package:co_cook/screens/home_screen/home_screen.dart';
import 'package:co_cook/screens/user_screen/user_screen.dart';
import 'package:co_cook/screens/search_screen/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final PanelController _mainPanelController = PanelController();
  final GlobalKey<FavoriteDirectState> _favoriteDirectKey =
      GlobalKey<FavoriteDirectState>(); // favorite 키 가져오기

  void onTap(int index) {
    if (_mainPanelController.isPanelOpen) {
      _mainPanelController.close();
    }
    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    if (_mainPanelController.isPanelOpen) {
      _mainPanelController.close();
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(children: [
          Container(
            child: [
              HomeScreen(),
              VoiceSearchScreen(),
              SearchScreen(),
              UserScreen(),
            ][_currentIndex],
          ),
          CustomSlidingUpPanel(
              body: FavoriteDirect(
                  key: _favoriteDirectKey), // FavoriteDirect에 GlobalKey 전달
              panelController: _mainPanelController,
              onPanelOpened: () {
                _favoriteDirectKey.currentState?.getDetailInfo(); // api 새로 호출하기
              }),
        ]),
        bottomNavigationBar: BottomNavBar(
            currentIndex: _currentIndex,
            onTap: onTap,
            panelController: _mainPanelController),
      ),
    );
  }
}
