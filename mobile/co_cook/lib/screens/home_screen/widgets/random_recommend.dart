import 'dart:convert';

import 'package:co_cook/services/recommend_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

import 'package:co_cook/widgets/card/list_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RandomRecommend extends StatefulWidget {
  const RandomRecommend({super.key});

  @override
  State<RandomRecommend> createState() => _RandomRecommendState();
}

class _RandomRecommendState extends State<RandomRecommend> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCardData("/home/random");
  }

  var dataList = [];

  Future<void> getCardData(String apiPath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userData = prefs.getString('userData') ?? '';
    // API 요청
    RecommendService _recommendService = RecommendService();
    Response? response = await _recommendService.getTimeRecommend(apiPath);

    // 디코딩
    var decodeRes = await jsonDecode(response.toString());
    if (decodeRes != null) {
      setState(() {
        dataList = decodeRes["data"]["recipes"];
      });
    }
    ;
  }

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
              itemCount: dataList.length,
              padding: EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 24.0),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: ListCard(data: dataList[index]),
                );
              }),
        ],
      ),
    );
  }
}
