import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:co_cook/services/recommend_service.dart';

import 'theme_recommend_card.dart';

class ThemeRecommend extends StatefulWidget {
  const ThemeRecommend({super.key});

  @override
  State<ThemeRecommend> createState() => _ThemeRecommendState();
}

class _ThemeRecommendState extends State<ThemeRecommend> {
  @override
  void initState() {
    super.initState();
    getTimeRecommendData("/home/theme");
  }

  List dataList = [];

  Future<void> getTimeRecommendData(String apiPath) async {
    // API 요청
    RecommendService recommendService = RecommendService();
    Response? response = await recommendService.getCardData(apiPath);

    if (response?.statusCode == 200) {
      if (response?.data['data'] != null) {
        setState(() {
          dataList = response!.data["data"];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0.0),
              width: double.infinity,
              child: Text("테마별 레시피",
                  textAlign: TextAlign.left,
                  style: const CustomTextStyles().subtitle1.copyWith(
                        color: CustomColors.monotoneBlack,
                      )),
            ),
            SizedBox(
                height: 156,
                child: dataList.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: dataList.length,
                        physics: const BouncingScrollPhysics(),
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                        itemBuilder: (BuildContext context, int index) {
                          return ThemeRecommendCard(data: dataList[index]);
                        })
                    : const Center(
                        child: CircularProgressIndicator(
                            color: CustomColors.redPrimary))),
          ],
        ));
  }
}
