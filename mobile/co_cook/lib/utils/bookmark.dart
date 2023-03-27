import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:co_cook/services/recommend_service.dart';

void toggleBookmark(BuildContext context, bool isAdd, Function toggleIsAdd,
    int recipeIdx, String recipeName) async {
  RecommendService recommendService = RecommendService();

  if (isAdd) {
    Response? response = await recommendService.deleteBookmark(recipeIdx);
    Map? decodeRes = await jsonDecode(response.toString());

    if (response?.statusCode == 200) {
      toggleIsAdd();
      await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("$recipeName 레시피를 찜 목록에서 제거했습니다.."),
        duration: Duration(seconds: 1),
      ));
    }
  } else {
    Response? response = await recommendService.postBookmark(recipeIdx);

    if (response?.statusCode == 200) {
      toggleIsAdd();
      await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("$recipeName 레시피를 찜 목록에 추가했습니다."),
          duration: Duration(seconds: 1)));
    }
  }
}
