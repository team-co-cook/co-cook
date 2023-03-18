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
    super.initState();
    getTimeRecommendData("/home/random");
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
          dataList = decodeRes["data"]["recipes"];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          dataList.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dataList.length,
                  padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 24.0),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListCard(data: dataList[index]),
                    );
                  })
              : const Center(
                  child: CircularProgressIndicator(
                      color: CustomColors.redPrimary)),
        ],
      ),
    );
  }
}
