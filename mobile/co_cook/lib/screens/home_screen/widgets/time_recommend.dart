import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:co_cook/widgets/card/grid_card.dart';
import 'package:co_cook/services/recommend_service.dart';
import 'package:co_cook/widgets/shimmer/custom_shimmer.dart';

class TimeRecommend extends StatefulWidget {
  const TimeRecommend({super.key});

  @override
  State<TimeRecommend> createState() => _TimeRecommendState();
}

class _TimeRecommendState extends State<TimeRecommend> {
  @override
  void initState() {
    super.initState();
    getTimeRecommendData("/home/recommend");
  }

  List? dataList;
  String? currentTime;

  Future<void> getTimeRecommendData(String apiPath) async {
    // API 요청
    RecommendService recommendService = RecommendService();
    Response? response = await recommendService.getCardData(apiPath);
    if (response?.statusCode == 200) {
      Map? decodeRes = await jsonDecode(response.toString());
      if (decodeRes != null) {
        setState(() {
          dataList = decodeRes["data"]["recipes"];
          currentTime = decodeRes["data"]["currentTime"];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            dataList != null
                ? Text("오늘 ${currentTime ?? '추천요리'},",
                    style: const CustomTextStyles().title2.copyWith(
                          color: CustomColors.redPrimary,
                        ))
                : CustomShimmer(
                    width: 160,
                    height: 20,
                  ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: dataList != null
                  ? Text("이런 요리 어때요?",
                      style: const CustomTextStyles().subtitle1.copyWith(
                            color: CustomColors.monotoneBlack,
                          ))
                  : CustomShimmer(
                      width: 100,
                      height: 16,
                    ),
            ),
          ],
        ),
      ),
      SizedBox(
          height: MediaQuery.of(context).size.width * 0.83,
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(top: 8.0),
                child: GridCard(
                  data: dataList != null ? dataList![index] : null,
                ),
              );
            },
            itemCount: dataList != null ? dataList!.length : 3,
            viewportFraction: 0.65,
            scale: 0.7,
            autoplay: false,
            autoplayDelay: 7000,
            duration: 1000,
          ))
    ]));
  }
}
