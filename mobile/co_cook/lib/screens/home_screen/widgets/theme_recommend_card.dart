import 'package:flutter/material.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

class ThemeRecommendCard extends StatelessWidget {
  const ThemeRecommendCard({
    super.key,
    required this.data,
  });
  final Map data;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(data["imgPath"]), // 배경 이미지
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(1, 1),
              blurRadius: 6.0,
              spreadRadius: 0.0,
            )
          ],
        ),
        margin: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
        width: 120,
        height: 120,
      ),
      Positioned(
          top: 28,
          left: 24,
          right: 24,
          child: Text(data["themeName"],
              style: const CustomTextStyles()
                  .subtitle1
                  .copyWith(color: CustomColors.monotoneLight, shadows: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(1, 1),
                  blurRadius: 6.0,
                  spreadRadius: 0.0,
                )
              ])))
    ]);
  }
}
