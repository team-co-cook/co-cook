import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:co_cook/services/detail_service.dart';
import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

class RecipeDetailRecipeTab extends StatefulWidget {
  const RecipeDetailRecipeTab({super.key, required this.recipeIdx});
  final int recipeIdx;

  @override
  State<RecipeDetailRecipeTab> createState() => _RecipeDetailRecipeTabState();
}

class _RecipeDetailRecipeTabState extends State<RecipeDetailRecipeTab> {
  Map data = {};

  @override
  void initState() {
    super.initState();
    getDetailStep(widget.recipeIdx);
  }

  Future<void> getDetailStep(int recipeIdx) async {
    // API 요청
    DetailService searchService = DetailService();
    Response? response =
        await searchService.getDetailStep(recipeIdx: recipeIdx);
    if (response?.statusCode == 200) {
      if (response != null) {
        setState(() {
          data = response!.data['data'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.monotoneLight,
      child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.fromLTRB(8.0, 24.0, 24.0, 24.0),
          physics: NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) => Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "1",
                          style: CustomTextStyles()
                              .subtitle2
                              .copyWith(color: CustomColors.monotoneBlack),
                        )),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: Colors.amber,
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 8, bottom: 32),
                              child: Text(
                                "먼저 재료를 준비합니다.",
                                style: CustomTextStyles().body1.copyWith(
                                    color: CustomColors.monotoneBlack),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              )),
    );
  }
}
