import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:transparent_image/transparent_image.dart';

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
      if (response?.data != null) {
        setState(() {
          data = response!.data['data'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return data.isEmpty
        ? Center(
            child: CircularProgressIndicator(color: CustomColors.redPrimary))
        : Container(
            color: CustomColors.monotoneLight,
            child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.fromLTRB(8.0, 24.0, 24.0, 24.0),
                physics: NeverScrollableScrollPhysics(),
                itemCount: data['steps'].length,
                itemBuilder: (context, index) => Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                '${data['steps'][index]['currentStep']}',
                                style: CustomTextStyles().subtitle2.copyWith(
                                    color: CustomColors.monotoneBlack),
                              )),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AspectRatio(
                                  aspectRatio: 16 / 10, // 비율 설정
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: FadeInImage.memoryNetwork(
                                        fadeInDuration:
                                            const Duration(milliseconds: 200),
                                        fit: BoxFit.cover,
                                        placeholder: kTransparentImage,
                                        image: data['steps'][index]['imgPath']),
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(top: 8, bottom: 32),
                                    child: Text(
                                      data['steps'][index]['content'],
                                      style: CustomTextStyles().body1.copyWith(
                                          color: CustomColors.monotoneBlack,
                                          height: 1.5),
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
