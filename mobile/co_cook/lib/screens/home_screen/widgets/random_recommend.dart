import 'package:flutter/material.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

import 'package:co_cook/widgets/card/list_card.dart';

class RandomRecommend extends StatelessWidget {
  const RandomRecommend({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0.0),
            width: double.infinity,
            child: Text("더 많은 요리 레시피",
                textAlign: TextAlign.left,
                style: const CustomTextStyles().subtitle1.copyWith(
                      color: CustomColors.monotoneBlack,
                    )),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 3,
              padding: EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 24.0),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: ListCard(data: {
                    "recipeIdx": 3,
                    "recipeName": "테스트 요리2",
                    "recipeImgPath": "https://picsum.photos/200/300",
                    "recipeDifficulty": "쉬움",
                    "recipeRunningTime": 30,
                    "isFavorite": false
                  }),
                );
              }),
        ],
      ),
    );
  }
}
