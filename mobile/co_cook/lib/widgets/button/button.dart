import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

// 버튼 타입
enum ButtonType { red, green, none }

class CommonButton extends StatefulWidget {
  const CommonButton(
      {super.key,
      required this.label,
      required this.color,
      this.isActive = true,
      required this.onPressed});
  final String label; // 버튼 라벨
  final ButtonType color; // 버튼 색깔, ButtonType
  final bool isActive; // 버튼 작동유무, 기본값 = true
  final Function onPressed; // 버튼이 눌렸을 경우 실행할 함수

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  @override
  Widget build(BuildContext context) {
    Color buttonColor;
    Color labelColor = widget.isActive
        ? CustomColors.monotoneLight
        : CustomColors.monotoneGray;
    switch (widget.color) {
      case ButtonType.red:
        buttonColor = widget.isActive
            ? CustomColors.redPrimary
            : CustomColors.monotoneLightGray;
        break;
      case ButtonType.green:
        buttonColor = widget.isActive
            ? CustomColors.greenPrimary
            : CustomColors.monotoneLightGray;
        break;
      case ButtonType.none:
        buttonColor = Colors.transparent;
        labelColor = widget.isActive
            ? CustomColors.redPrimary
            : CustomColors.monotoneLightGray;
        break;
    }

    return CupertinoButton(
      padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
      color: buttonColor,
      minSize: 40.0,
      borderRadius: BorderRadius.circular(16.0),
      onPressed: () {
        widget.isActive ? widget.onPressed() : null;
      },
      child: Text(widget.label,
          style: const CustomTextStyles().button.copyWith(color: labelColor)),
    );
  }
}
