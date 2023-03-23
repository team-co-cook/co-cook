import 'dart:async';
import 'package:co_cook/screens/review_screen/review_screen.dart';
import 'package:dio/dio.dart';

import 'package:co_cook/services/detail_service.dart';
import 'package:flutter/material.dart';
import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:word_break_text/word_break_text.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'cook_screen_timer.dart';

class CookScreenBody extends StatefulWidget {
  const CookScreenBody(
      {Key? key, required this.recipeIdx, required this.recipeName})
      : super(key: key);
  final int recipeIdx;
  final String recipeName;

  @override
  State<CookScreenBody> createState() => _CookScreenBodyState();
}

class _CookScreenBodyState extends State<CookScreenBody> {
  List dataList = [];

  final PageController recipeCardPageController =
      PageController(viewportFraction: 0.7);

  double _recipeCardPage = 0;
  double _completeCardPage = 1;

  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    getDetailStep(widget.recipeIdx);
    _startTime = DateTime.now();
    recipeCardPageController.addListener(() {
      setState(() {
        _recipeCardPage = recipeCardPageController.page ?? 0;
        if (_recipeCardPage.ceil() == dataList.length) {
          setState(() {
            _completeCardPage = dataList.length - _recipeCardPage;
          });
        }
        if (_recipeCardPage.floor() == dataList.length) {
          print(_startTime); // 종료 콜백 넣어주세요
          gotoReview(context, widget.recipeIdx, widget.recipeName, _startTime);
        }
      });
    });
  }

  @override
  void dispose() {
    recipeCardPageController.dispose();
    super.dispose();
  }

  Future<void> getDetailStep(int recipeIdx) async {
    // API 요청
    DetailService searchService = DetailService();
    Response? response =
        await searchService.getDetailStep(recipeIdx: recipeIdx);
    print(response!.data['data']);
    if (response?.statusCode == 200) {
      if (response!.data['data'] != null) {
        setState(() {
          dataList = response!.data['data']['steps'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return dataList.isEmpty
        ? Center(
            child: CircularProgressIndicator(color: CustomColors.redPrimary))
        : Stack(children: [
            Opacity(
              opacity: _completeCardPage,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: CustomColors.redLight,
              ),
            ),
            Opacity(
              opacity: 1 - _completeCardPage,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: CustomColors.greenPrimary,
              ),
            ),
            SizedBox(
              height: double.infinity,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: (MediaQuery.of(context).size.width /
                              dataList.length) *
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
                              physics: const BouncingScrollPhysics(),
                              controller: recipeCardPageController,
                              itemCount: dataList.length + 1,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                    margin: const EdgeInsets.all(16.0),
                                    child: index == dataList.length
                                        ? Container(
                                            alignment: Alignment.centerLeft,
                                            width: double.infinity,
                                            height: double.infinity,
                                            padding: const EdgeInsets.all(16.0),
                                            decoration: BoxDecoration(
                                                color:
                                                    CustomColors.greenPrimary,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        16.0)),
                                            child: Row(children: [
                                              Opacity(
                                                opacity: _completeCardPage,
                                                child: Text("완성!",
                                                    style:
                                                        const CustomTextStyles()
                                                            .title2
                                                            .copyWith(
                                                              color: CustomColors
                                                                  .monotoneLight,
                                                            )),
                                              ),
                                              Opacity(
                                                opacity: 1 - _completeCardPage,
                                                child: Text("밀어서 요리 종료하기",
                                                    style:
                                                        const CustomTextStyles()
                                                            .title2
                                                            .copyWith(
                                                              color: CustomColors
                                                                  .monotoneLight,
                                                            )),
                                              ),
                                            ]),
                                          )
                                        : Opacity(
                                            opacity: _completeCardPage,
                                            child: Center(
                                              child: Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  decoration: BoxDecoration(
                                                      color: CustomColors
                                                          .monotoneLight,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0)),
                                                  child: Row(
                                                    children: [
                                                      LayoutBuilder(builder:
                                                          (context,
                                                              constraints) {
                                                        return Container(
                                                          width: constraints
                                                              .maxHeight,
                                                          height: constraints
                                                              .maxHeight,
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 16.0),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            child: FadeInImage.memoryNetwork(
                                                                fadeInDuration:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            200),
                                                                fit: BoxFit
                                                                    .cover,
                                                                placeholder:
                                                                    kTransparentImage,
                                                                image: dataList[
                                                                        index][
                                                                    "imgPath"]),
                                                          ),
                                                        );
                                                      }),
                                                      Expanded(
                                                        child: Column(
                                                          children: [
                                                            Expanded(
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                        .only(
                                                                    top: 16.0,
                                                                    bottom:
                                                                        16.0),
                                                                child: WordBreakText(
                                                                    dataList[
                                                                            index]
                                                                        [
                                                                        "content"],
                                                                    style: const CustomTextStyles()
                                                                        .title2
                                                                        .copyWith(
                                                                          color:
                                                                              CustomColors.monotoneBlack,
                                                                        )),
                                                              ),
                                                            ),
                                                            dataList[index]
                                                                        [
                                                                        "timer"] !=
                                                                    null
                                                                ? CookScreenTimer(
                                                                    time: dataList[
                                                                            index]
                                                                        [
                                                                        "timer"],
                                                                    play: false)
                                                                : Container()
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                            ),
                                          ));
                              })),
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
            ),
          ]);
  }
}

void gotoReview(BuildContext context, int recipeIdx, String recipeName,
    DateTime startTime) {
  Route reviewScreen = MaterialPageRoute(
      builder: (context) => ReviewScreen(
          recipeIdx: recipeIdx, recipeName: recipeName, startTime: startTime));
  Navigator.push(context, reviewScreen);
}
