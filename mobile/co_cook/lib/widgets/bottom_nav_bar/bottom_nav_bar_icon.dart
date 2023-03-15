import 'package:flutter/material.dart';

import 'package:co_cook/styles/colors.dart';
// import 'package:co_cook/styles/text_styles.dart';

class BottomNavBarIcon extends StatefulWidget {
  const BottomNavBarIcon({
    super.key,
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.iconOutlined,
    required this.onTap,
  });
  final int index; // 페이지 인덱스
  final int currentIndex; // 현재 페이지 인덱스
  final IconData icon; // 아이콘
  final IconData iconOutlined; // 아웃라인 아이콘
  final Function onTap; // 탭하면 실행될 함수

  @override
  State<BottomNavBarIcon> createState() => _BottomNavBarIconState();
}

class _BottomNavBarIconState extends State<BottomNavBarIcon> {
  bool _isTapDown = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails tapDownDetails) {
        setState(() {
          _isTapDown = true;
        });
      },
      onTapUp: (TapUpDetails tapUpDetails) {
        setState(() {
          _isTapDown = false;
        });
        widget.onTap(widget.index);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: _isTapDown ? CustomColors.monotoneLightGray : null,
        ),
        child: Icon(
          widget.index == widget.currentIndex
              ? widget.icon
              : widget.iconOutlined,
          color: CustomColors.monotoneBlack,
          size: 18,
        ),
      ),
    );
  }
}
