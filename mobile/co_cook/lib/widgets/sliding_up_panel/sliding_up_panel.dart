import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

final PanelController panelController = PanelController();

class CustomSlidingUpPanel extends StatelessWidget {
  const CustomSlidingUpPanel({super.key, required this.body});
  final Widget body; // 판넬 안에 담길 내용

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      controller: panelController,
      backdropEnabled: true,
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
      minHeight: 0.0,
      color: CustomColors.monotoneLight,
      panel: Column(
        children: [
          GestureDetector(
            onTap: () {
              panelController.close(); // 댓글창 닫는 함수
              FocusScope.of(context).unfocus(); // 키보드 닫는 함수
            },
            child: Container(
              height: 48,
              child: const Icon(
                Icons.horizontal_rule_rounded,
                size: 52,
                color: CustomColors.monotoneLightGray,
              ),
            ),
          ),
          Expanded(
            child: body,
          ),
        ],
      ),
    );
  }
}
