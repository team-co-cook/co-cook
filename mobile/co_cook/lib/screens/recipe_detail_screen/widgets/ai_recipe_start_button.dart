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
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      width: double.infinity,
      alignment: Alignment.center,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: CustomColors.redPrimary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/logo/logo_ai_white.png'),
          Text(
            "AI 요리 레시피 시작",
            style: const CustomTextStyles()
                .button
                .copyWith(color: CustomColors.monotoneLight),
          ),
        ],
      ),
    );
  }
}
