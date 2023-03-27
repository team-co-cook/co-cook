import 'dart:async';
import 'package:co_cook/screens/review_screen/review_screen.dart';
import 'package:co_cook/styles/shadows.dart';
import 'package:dio/dio.dart';
import 'dart:math';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:co_cook/services/detail_service.dart';
import 'package:flutter/material.dart';
import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:flutter/services.dart';
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

class _CookScreenBodyState extends State<CookScreenBody>
    with SingleTickerProviderStateMixin {
  List dataList = [];
  Map _firstData = {};

  final PageController recipeCardPageController =
      PageController(viewportFraction: 0.7);

  double _recipeCardPage = 0;
  double _completeCardPage = 1;

  late DateTime _startTime;

  // tts 관련 코드
  Timer? _debounce;
  int currentTtsIndex = -1;

  // 첫페이지 글자 애니메이션
  AnimationController? _waveAnimationController;
  Animation? _waveAnimation;

  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();

    flutterTts = FlutterTts();

    _waveAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _waveAnimation = Tween(begin: -pi, end: pi).animate(
      CurvedAnimation(
        parent: _waveAnimationController!,
        curve: Curves.linear,
      ),
    );

    _waveAnimationController!.repeat();
    getDetailStep(widget.recipeIdx);
    getDetailBasic(widget.recipeIdx);
    _startTime = DateTime.now();
    recipeCardPageController.addListener(() {
      setState(() {
        _recipeCardPage = recipeCardPageController.page ?? 0;

        flutterTts.stop();

        // debounce를 사용하여 TTS 호출을 처리
        if (_debounce?.isActive ?? false) _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 300), () {
          if (_recipeCardPage.floor() - 1 != currentTtsIndex) {
            currentTtsIndex = _recipeCardPage.floor() - 1;
            if (currentTtsIndex < dataList.length && currentTtsIndex >= 0) {
              speakText(dataList[currentTtsIndex]["content"]);
            }
          }
        });

        if (_recipeCardPage.ceil() == dataList.length + 1) {
          setState(() {
            _completeCardPage =
                (dataList.length - _recipeCardPage).clamp(0.0, 1.0);
          });
        }
        if (_recipeCardPage.floor() == dataList.length + 1) {
          // 종료 콜백 넣어주세요
          gotoReview(context, widget.recipeIdx, widget.recipeName, _startTime);
        }
      });
    });
  }

  @override
  void dispose() {
    recipeCardPageController.dispose();
    _waveAnimationController?.dispose();
    flutterTts.stop();
    super.dispose();
  }

  Future<void> speakText(String text) async {
    // 한국어 TTS 사용 예시
    await flutterTts.setLanguage("ko-KR");
    await flutterTts.speak(text);
  }

  Future<void> getDetailStep(int recipeIdx) async {
    // API 요청
    DetailService searchService = DetailService();
    Response? response =
        await searchService.getDetailStep(recipeIdx: recipeIdx);
    if (response?.statusCode == 200) {
      print(response!.data['data']['steps']);
      if (response!.data['data'] != null) {
        setState(() {
          dataList = response.data['data']['steps'];
        });
      }
    }
  }

  Future<void> getDetailBasic(int recipeIdx) async {
    // API 요청
    DetailService searchService = DetailService();
    Response? response =
        await searchService.getDetailBasic(recipeIdx: recipeIdx);
    if (response?.statusCode == 200) {
      if (response != null) {
        setState(() {
          _firstData = response.data['data'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return dataList.isEmpty || _firstData.isEmpty
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
                              (dataList.length)) *
                          (_recipeCardPage),
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
                              itemCount: dataList.length + 2,
                              itemBuilder: (BuildContext context, int index) {
                                // 첫 페이지에 들어갈 커스텀 슬라이드 입니다.
                                if (index == 0) {
                                  return Container(
                                      child: Container(
                                    alignment: Alignment.centerLeft,
                                    width: double.infinity,
                                    height: double.infinity,
                                    padding: const EdgeInsets.all(16.0),
                                    child: Stack(
                                      children: [
                                        // 배경 이미지
                                        Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  _firstData['recipeImgPath']),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                        ),
                                        // 단색 배경
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                4,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(16.0),
                                                bottomRight:
                                                    Radius.circular(16.0),
                                              ),
                                              color: CustomColors.monotoneLight,
                                            ),
                                          ),
                                        ),
                                        // 중앙 큰 글씨
                                        Positioned.fill(
                                          child: Center(
                                            child: Text(
                                                _firstData['recipeName'],
                                                style: CustomTextStyles()
                                                    .title1
                                                    .copyWith(
                                                        color: CustomColors
                                                            .monotoneLight,
                                                        fontSize: 48,
                                                        shadows: [
                                                      CustomShadows.text
                                                    ])),
                                          ),
                                        ),
                                        // 단색 배경 중앙 작은 글씨
                                        Positioned(
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              6, // 단색 배경 높이의 중앙
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            child: Center(
                                              child: _buildWaveText(
                                                  '"코쿡, 다음"이라고 말해보세요.'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                                }

                                // 마지막 페이지 슬라이드입니다.
                                if (index == dataList.length + 1) {
                                  return Container(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      width: double.infinity,
                                      height: double.infinity,
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                          color: CustomColors.greenPrimary,
                                          borderRadius:
                                              BorderRadius.circular(16.0)),
                                      child: Row(children: [
                                        Opacity(
                                          opacity: _completeCardPage,
                                          child: Text("완성!",
                                              style: const CustomTextStyles()
                                                  .title2
                                                  .copyWith(
                                                    color: CustomColors
                                                        .monotoneLight,
                                                  )),
                                        ),
                                        Opacity(
                                          opacity: 1 - _completeCardPage,
                                          child: Text("밀어서 요리 종료하기",
                                              style: const CustomTextStyles()
                                                  .title2
                                                  .copyWith(
                                                    color: CustomColors
                                                        .monotoneLight,
                                                  )),
                                        ),
                                      ]),
                                    ),
                                  );
                                }
                                return Container(
                                    margin: const EdgeInsets.all(16.0),
                                    child: Opacity(
                                      opacity: _completeCardPage,
                                      child: Center(
                                        child: Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            padding: const EdgeInsets.all(16.0),
                                            decoration: BoxDecoration(
                                                color:
                                                    CustomColors.monotoneLight,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        16.0)),
                                            child: Row(
                                              children: [
                                                LayoutBuilder(builder:
                                                    (context, constraints) {
                                                  return Container(
                                                    width:
                                                        constraints.maxHeight,
                                                    height:
                                                        constraints.maxHeight,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 16.0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: FadeInImage.memoryNetwork(
                                                          fadeInDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      200),
                                                          fit: BoxFit.cover,
                                                          placeholder:
                                                              kTransparentImage,
                                                          image: dataList[
                                                                  index - 1]
                                                              ["imgPath"]),
                                                    ),
                                                  );
                                                }),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 16.0,
                                                                  bottom: 16.0),
                                                          child: WordBreakText(
                                                              dataList[index -
                                                                  1]["content"],
                                                              style: const CustomTextStyles()
                                                                  .title2
                                                                  .copyWith(
                                                                      color: CustomColors
                                                                          .monotoneBlack,
                                                                      height:
                                                                          1.4)),
                                                        ),
                                                      ),
                                                      dataList[index - 1]
                                                                  ["timer"] !=
                                                              null
                                                          ? CookScreenTimer(
                                                              time: dataList[
                                                                      index - 1]
                                                                  ["timer"],
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

  Widget _buildWaveText(String text) {
    return AnimatedBuilder(
      animation: _waveAnimation!,
      builder: (BuildContext context, Widget? child) {
        return RichText(
          text: TextSpan(
            children: text.split('').map<InlineSpan>((String char) {
              int index = text.indexOf(char);
              double offset = 0.1 *
                  sin((_waveAnimation!.value * 2 * pi) + (index * 0.20 * pi));
              return WidgetSpan(
                child: Transform.translate(
                  offset: Offset(0, offset * 10),
                  child: Text(char,
                      style: CustomTextStyles()
                          .subtitle1
                          .copyWith(color: CustomColors.redPrimary)),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

void gotoReview(BuildContext context, int recipeIdx, String recipeName,
    DateTime startTime) async {
  Route reviewScreen = MaterialPageRoute(
      builder: (context) => ReviewScreen(
          recipeIdx: recipeIdx, recipeName: recipeName, startTime: startTime));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => Navigator.pushReplacement(context, reviewScreen));
}
