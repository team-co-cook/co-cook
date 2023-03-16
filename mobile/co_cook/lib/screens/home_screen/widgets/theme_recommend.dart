import 'package:flutter/material.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

import 'theme_recommend_card.dart';

class ThemeRecommend extends StatelessWidget {
  const ThemeRecommend({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 16.0),
              width: double.infinity,
              child: Text("테마별 레시피",
                  textAlign: TextAlign.left,
                  style: const CustomTextStyles().subtitle1.copyWith(
                        color: CustomColors.monotoneBlack,
                      )),
            ),
            SizedBox(
                height: 120,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                    itemBuilder: (BuildContext context, int index) {
                      return ThemeRecommendCard(
                        data: {
                          "id": 1,
                          "themeName": "시원한 국물 요리",
                          "imgPath": "https://picsum.photos/200/300"
                        },
                      );
                    })),
          ],
        ));
  }
}
