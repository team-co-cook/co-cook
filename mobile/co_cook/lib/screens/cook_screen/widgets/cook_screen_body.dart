import 'dart:async';

import 'package:flutter/material.dart';
import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:word_break_text/word_break_text.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'cook_screen_timer.dart';

class CookScreenBody extends StatefulWidget {
  const CookScreenBody({
    super.key,
  });

  @override
  State<CookScreenBody> createState() => _CookScreenBodyState();
}

class _CookScreenBodyState extends State<CookScreenBody> {
  List dataList = [
    {
      "imgPath":
          "https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/5c9563bc-94c6-4c5b-8b38-4c9f8f07ecdc1.jpg",
      "timer": null,
      "content": "양파는 채 썰어 준비하고 닭가슴살은 약 1cm크기로 깍둑썰기 하고 대파 또는 쪽파는 송송 썰어 준비해요.",
      "currentStep": 1
    },
    {
      "imgPath":
          "https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/f2a447fa-6e70-40ee-89a1-41714556f8052.jpg",
      "timer": 2,
      "content": "닭가슴살은 청주 또는 맛술을 넣고 소금, 후추 밑간 해요.",
      "currentStep": 2
    },
    {
      "imgPath":
          "https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/d48a5b76-489a-4b1d-9180-6121d0822c4c3.jpg",
      "timer": 3,
      "content": "예열된 팬에 기름을 두르고 스크램블 하여 준비해요.",
      "currentStep": 3
    },
    {
      "imgPath":
          "https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/3d4ca029-f3ee-476d-95b5-475d01cd7cae4.jpg",
      "timer": 121,
      "content": "스크램블 한 팬에 채 썬 양파를 넣고 볶다가 밑간 한 닭가슴살을 넣어 볶아요.",
      "currentStep": 4
    },
    {
      "imgPath":
          "https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/8ba4455e-ad21-4dad-ac6b-5f7c9bfef92d5.jpg",
      "timer": 5,
      "content": "닭가슴살이 반정도 익으면 간장, 올리고당을 넣어 살짝 조려요.",
      "currentStep": 5
    },
    {
      "imgPath":
          "https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/418266c1-2556-4380-9181-be41adc4e5a26.jpg",
      "timer": 6,
      "content": "그릇에 밥을 담고 스크램블애그, 볶은 닭가슴살, 쪽파 순서로 올려요.",
      "currentStep": 6
    },
    {
      "imgPath":
          "https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/cebbfdb8-db73-4cda-b78c-4aa4b12ef9627.jpg",
      "timer": 7,
      "content": "기호에 따라 마요네즈를 뿌려 완성해요.",
      "currentStep": 7
    }
  ];

  final PageController recipeCardPageController =
      PageController(viewportFraction: 0.7);

  double _recipeCardPage = 0;

  @override
  void initState() {
    super.initState();
    recipeCardPageController.addListener(() {
      print("page : ${_recipeCardPage.round()}");
      setState(() {
        _recipeCardPage = recipeCardPageController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    recipeCardPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Container(
              width: (MediaQuery.of(context).size.width / dataList.length) *
                  (_recipeCardPage + 1),
              height: 4,
              color: CustomColors.greenPrimary,
            ),
          ),
          Expanded(
            child: Stack(children: [
              Container(
                  margin: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                  child: PageView.builder(
                    controller: recipeCardPageController,
                    itemCount: dataList.length,
                    itemBuilder: (BuildContext context, int index) => Container(
                        margin: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                  color: CustomColors.monotoneLight,
                                  borderRadius: BorderRadius.circular(16.0)),
                              child: Row(
                                children: [
                                  LayoutBuilder(
                                      builder: (context, constraints) {
                                    return Container(
                                      width: constraints.maxHeight,
                                      height: constraints.maxHeight,
                                      margin:
                                          const EdgeInsets.only(right: 16.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: FadeInImage.memoryNetwork(
                                            fadeInDuration: const Duration(
                                                milliseconds: 200),
                                            fit: BoxFit.cover,
                                            placeholder: kTransparentImage,
                                            image: dataList[index]["imgPath"]),
                                      ),
                                    );
                                  }),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                top: 16.0, bottom: 16.0),
                                            child: WordBreakText(
                                                dataList[index]["content"],
                                                style: const CustomTextStyles()
                                                    .title2
                                                    .copyWith(
                                                      color: CustomColors
                                                          .monotoneBlack,
                                                    )),
                                          ),
                                        ),
                                        dataList[index]["timer"] != null
                                            ? CookScreenTimer(
                                                time: dataList[index]["timer"],
                                                play: false)
                                            : Container()
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        )),
                  )),
              Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () => recipeCardPageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      color: Colors.transparent,
                    ),
                  )),
              Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () => recipeCardPageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      color: Colors.transparent,
                    ),
                  ))
            ]),
          ),
        ],
      ),
    );
  }
}
