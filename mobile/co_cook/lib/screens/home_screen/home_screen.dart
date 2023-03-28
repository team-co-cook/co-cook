import 'package:flutter/material.dart';
import 'package:co_cook/screens/home_screen/widgets/random_recommend.dart';

import 'widgets/ai_recommend.dart';
import 'widgets/time_recommend.dart';
import 'widgets/theme_recommend.dart';
import 'widgets/category_recommend.dart';
import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        centerTitle: true,
        title: Container(
            padding: EdgeInsets.only(top: 16), child: const Text("Co-Cook!")),
        titleTextStyle: const CustomTextStyles()
            .logo
            .copyWith(color: CustomColors.redPrimary, fontSize: 32),
        backgroundColor: CustomColors.monotoneLight,
        shadowColor: CustomColors.monotoneLight,
        elevation: 0.5,
      ),
      body: const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            TimeRecommend(),
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
