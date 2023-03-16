import 'package:flutter/cupertino.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

class ButtonToggle extends StatefulWidget {
  const ButtonToggle(
      {super.key,
      required this.label,
      required this.isToggleOn,
      required this.onPressed});
  final String label; // 토글 라벨
  final bool isToggleOn; // 토글의 상태
  final Function onPressed; // 버튼이 눌렸을 경우 실행할 함수

  @override
  State<ButtonToggle> createState() => _ButtonToggleState();
}

class _ButtonToggleState extends State<ButtonToggle> {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
      color: widget.isToggleOn
          ? CustomColors.redPrimary
          : CustomColors.monotoneLightGray,
      minSize: 32.0,
      borderRadius: BorderRadius.circular(16.0),
      onPressed: () {
        widget.onPressed();
      },
      child: Text(widget.label,
          style: const CustomTextStyles().button.copyWith(
              color: widget.isToggleOn
                  ? CustomColors.monotoneLight
                  : CustomColors.monotoneGray)),
    );
  }
}
