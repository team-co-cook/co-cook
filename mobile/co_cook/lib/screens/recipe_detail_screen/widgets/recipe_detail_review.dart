import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:co_cook/services/detail_service.dart';
import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:co_cook/widgets/comment/recipe_comment.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

class RecipeDetailReviewTab extends StatefulWidget {
  const RecipeDetailReviewTab(
      {Key? key, required this.panelController, required this.recipeIdx})
      : super(key: key);

  final PanelController panelController;
  final int recipeIdx;

  @override
  State<RecipeDetailReviewTab> createState() => _RecipeDetailReviewTabState();
}

class _RecipeDetailReviewTabState extends State<RecipeDetailReviewTab> {
  List listData = [];

  @override
  void initState() {
    super.initState();
    getDetailReview(widget.recipeIdx);
  }

  Future<void> getDetailReview(int recipeIdx) async {
    // API 요청
    DetailService searchService = DetailService();
    Response? response =
        await searchService.getDetailReview(recipeIdx: recipeIdx);
    if (response?.statusCode == 200) {
      if (response?.data != null) {
        setState(() {
          listData = response!.data['data']['reviewsListResDto'];
        });
      }
    }
  }

  void reGet() {
    getDetailReview(widget.recipeIdx);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.monotoneLight,
      child: Stack(children: [
        ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 24.0),
          physics: NeverScrollableScrollPhysics(),
          itemCount: listData.length,
          itemBuilder: (context, index) => RecipeComment(
              panelController: widget.panelController,
              review: listData[index],
              reGet: reGet),
        ),
      ]),
    );
  }
}
