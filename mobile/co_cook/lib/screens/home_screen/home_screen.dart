import 'package:co_cook/screens/home_screen/widgets/random_recommend.dart';
import 'package:flutter/material.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

import 'widgets/time_recommend.dart';
import 'widgets/ai_recommend.dart';
import 'widgets/theme_recommend.dart';
import 'widgets/category_recommend.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map> timeRecipeList = [
    {
      "recipeIdx": 3,
      "recipeName": "테스트 요리1",
      "recipeImgPath": "https://picsum.photos/200/300",
      "recipeDifficulty": "쉬움",
      "recipeRunningTime": 30,
      "isFavorite": false
    },
    {
      "recipeIdx": 3,
      "recipeName": "테스트 요리2",
      "recipeImgPath": "https://picsum.photos/200/300",
      "recipeDifficulty": "보통",
      "recipeRunningTime": 30,
      "isFavorite": true
    },
    {
      "recipeIdx": 3,
      "recipeName": "테스트 요리2",
      "recipeImgPath": "https://picsum.photos/200/300",
      "recipeDifficulty": "어려움",
      "recipeRunningTime": 30,
      "isFavorite": false
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Co-Cook!"),
        titleTextStyle: const CustomTextStyles().logo.copyWith(
              color: CustomColors.redPrimary,
            ),
        backgroundColor: CustomColors.monotoneLight,
        shadowColor: CustomColors.monotoneLight,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TimeRecommend(dataList: timeRecipeList),
            AiRecommend(),
            ThemeRecommend(),
            CategoryRecommend(),
            RandomRecommend(),
          ],
        ),
      ),
    );
  }
}
