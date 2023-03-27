import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:dio/dio.dart'; // Response 가져오기 위함.
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

import 'package:co_cook/widgets/card/grid_card.dart';
import 'package:co_cook/services/recommend_service.dart';

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

  List dataList = [];

  Future<void> getTimeRecommendData(String apiPath) async {
    // API 요청
    RecommendService recommendService = RecommendService();
    Response? response = await recommendService.getCardData(apiPath);
    if (response?.statusCode == 200) {
      Map? decodeRes = await jsonDecode(response.toString());
      print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      print(decodeRes);
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("오늘 저녁,",
                  style: const CustomTextStyles().title2.copyWith(
                        color: CustomColors.redPrimary,
                      )),
              Container(
                margin: const EdgeInsets.only(top: 8),
                child: Text("이런 요리 어때요?",
                    style: const CustomTextStyles().subtitle1.copyWith(
                          color: CustomColors.monotoneBlack,
                        )),
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.83,
          child: dataList.isNotEmpty
              ? Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(top: 8.0),
                      child: GridCard(
                        data: dataList[index],
                      ),
                    );
                  },
                  itemCount: dataList.length,
                  viewportFraction: 0.65,
                  scale: 0.7,
                  autoplay: false,
                  autoplayDelay: 7000,
                  duration: 1000,
                )
              : const Center(
                  child: CircularProgressIndicator(
                      color: CustomColors.redPrimary)),
        )
      ]),
    );
  }
}
