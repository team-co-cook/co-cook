import 'package:flutter/material.dart';
import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

class AiRecipeStartButton extends StatelessWidget {
  const AiRecipeStartButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
      width: double.infinity,
      alignment: Alignment.center,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: CustomColors.redPrimary,
      ),
      child: Text(
        "AI 레시피 시작",
        style: const CustomTextStyles()
            .button
            .copyWith(color: CustomColors.monotoneLight),
      ),
    );
  }
}
