import 'package:flutter/material.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
// import 'package:co_cook/styles/text_styles.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'bottom_nav_bar_icon.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.panelController,
  }) : super(key: key);
  final int currentIndex;
  final ValueChanged<int> onTap;
  final PanelController panelController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: CustomColors.monotoneLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 6.0,
            spreadRadius: 0.0,
          )
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 홈 탭
              BottomNavBarIcon(
                index: 0,
                icon: Icons.home,
                iconOutlined: Icons.home_outlined,
                onTap: onTap,
                currentIndex: currentIndex,
              ),
              // 음성 재료검색 탭
              BottomNavBarIcon(
                index: 1,
                icon: Icons.kitchen,
                iconOutlined: Icons.kitchen_outlined,
                onTap: onTap,
                currentIndex: currentIndex,
              ),
              // co-cook 바로실행 아이콘
              ZoomTapAnimation(
                  onTap: () {
                    // 아이콘 탭 동작시 실행할 함수
                    print('co-cook!');
                    panelController.isPanelOpen
                        ? panelController.close()
                        : {panelController.open()};
                  },
                  child: const SizedBox(
                    height: 56,
                    child: Image(
                        image:
                            AssetImage('assets/images/logo/logo_circle.png')),
                  )),
              // 검색 탭
              BottomNavBarIcon(
                index: 2,
                icon: Icons.screen_search_desktop_rounded,
                iconOutlined: Icons.screen_search_desktop_outlined,
                onTap: onTap,
                currentIndex: currentIndex,
              ),
              // 마이페이지 스크린 탭
              BottomNavBarIcon(
                index: 3,
                icon: Icons.account_circle,
                iconOutlined: Icons.account_circle_outlined,
                onTap: onTap,
                currentIndex: currentIndex,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
