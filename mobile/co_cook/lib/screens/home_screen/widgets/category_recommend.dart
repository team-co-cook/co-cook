import 'dart:convert';

import 'package:co_cook/services/recommend_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class CategoryRecommend extends StatefulWidget {
  const CategoryRecommend({super.key});

  @override
  State<CategoryRecommend> createState() => _CategoryRecommendState();
}

class _CategoryRecommendState extends State<CategoryRecommend> {
  @override
  void initState() {
    super.initState();
    getTimeRecommendData("/home/category");
  }

  List dataList = [];

  Future<void> getTimeRecommendData(String apiPath) async {
    // API 요청
    RecommendService recommendService = RecommendService();
    Response? response = await recommendService.getCardData(apiPath);
    if (response?.statusCode == 200) {
      Map? decodeRes = await jsonDecode(response.toString());
      if (decodeRes != null) {
        setState(() {
          dataList = decodeRes["data"]["categories"];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0.0),
      child: dataList.isNotEmpty
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CategoryRecommendCard(
                    data: dataList[0], onTap: () => print("0")),
                CategoryRecommendCard(
                    data: dataList[1], onTap: () => print("1")),
                CategoryRecommendCard(
                    data: dataList[2], onTap: () => print("2"))
              ],
            )
          : const Center(
              child: CircularProgressIndicator(color: CustomColors.redPrimary)),
    );
  }
}

class CategoryRecommendCard extends StatelessWidget {
  const CategoryRecommendCard({
    super.key,
    required this.data,
    required this.onTap,
  });
  final Map data;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
        end: 0.98,
        onTap: () => onTap,
        child: Stack(children: [
          Container(
            width: ((MediaQuery.of(context).size.width - 48) / 3 - 8),
            height: 128,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(data["imgPath"]),
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
          ),
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                  child: Text(data["categoryName"],
                      style: CustomTextStyles().subtitle1.copyWith(
                          color: CustomColors.monotoneLight,
                          shadows: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(1, 1),
                              blurRadius: 6.0,
                              spreadRadius: 0.0,
                            )
                          ])))),
        ]));
  }
}
