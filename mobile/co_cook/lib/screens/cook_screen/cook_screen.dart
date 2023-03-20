import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:co_cook/screens/cook_screen/widgets/cook_screen_request_rotate.dart';
import 'package:co_cook/utils/route.dart';
import 'package:co_cook/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:transparent_image/transparent_image.dart';

class CookScreen extends StatefulWidget {
  const CookScreen({super.key});

  @override
  State<CookScreen> createState() => _CookScreenState();
}

class _CookScreenState extends State<CookScreen> {
  late StreamSubscription<AccelerometerEvent> _accelerometerSub;
  bool isRotated = false;
  DeviceOrientation _orientation = DeviceOrientation.portraitUp;

  @override
  void initState() {
    super.initState();
    startAccelerometerListener();
  }

  void startAccelerometerListener() {
    _accelerometerSub = accelerometerEvents.listen((AccelerometerEvent event) {
      // 화면이 정방향일 때
      if (-9 < event.x && event.x < 9 && !isRotated) {
        setState(() {
          _orientation = DeviceOrientation.portraitUp;
        });
        // 화면이 가로방향일 때
      } else if (event.x > 9) {
        if (!isRotated) {
          setState(() {
            isRotated = true;
          });
        }
        setState(() {
          _orientation = DeviceOrientation.landscapeLeft;
        });
      } else if (event.x < -9) {
        if (!isRotated) {
          setState(() {
            isRotated = true;
          });
        }
        setState(() {
          _orientation = DeviceOrientation.landscapeRight;
        });
      }
    });
  }

  @override
  void _orientationDispose(BuildContext context) {
    setState(() {
      _orientation = DeviceOrientation.portraitUp;
    });
    _accelerometerSub.cancel();
    Navigator.pop(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([_orientation]);
    return _orientation == DeviceOrientation.portraitUp
        ? const CookScreenRequestRotate()
        : Scaffold(
            backgroundColor: CustomColors.redLight,
            appBar: AppBar(
              backgroundColor: CustomColors.monotoneLight,
              elevation: 0.5,
              toolbarHeight: 60,
              flexibleSpace: SafeArea(
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 40.0, right: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("부대찌개",
                          style: const CustomTextStyles().subtitle1.copyWith(
                                color: CustomColors.monotoneBlack,
                              )),
                      Text("음성인식되는곳"),
                      CommonButton(
                          label: "종료",
                          color: ButtonType.red,
                          onPressed: () {
                            _orientationDispose(context);
                          })
                    ],
                  ),
                ),
              ),
            ),
            body: CookScreenBody());
  }
}

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
      "timer": 1,
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
      "timer": 4,
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

  PageController _recipeCardPageController =
      PageController(viewportFraction: 0.8);

  double _recipeCardPage = 0;

  @override
  void initState() {
    super.initState();
    _recipeCardPageController.addListener(() {
      print(_recipeCardPage);
      setState(() {
        _recipeCardPage = _recipeCardPageController.page ?? 0;
      });

      // 여기에 index가 변경될 때 실행할 로직을 추가합니다.
    });
  }

  @override
  void dispose() {
    _recipeCardPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    controller: _recipeCardPageController,
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
                                            BorderRadius.circular(16.0),
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
                                          child: Text(
                                              dataList[index]["content"],
                                              style: const CustomTextStyles()
                                                  .title2
                                                  .copyWith(
                                                    color: CustomColors
                                                        .monotoneBlack,
                                                  )),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: 48,
                                          child: Text("asdf"),
                                        )
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
                    onTap: () => _recipeCardPageController.previousPage(
                        duration: Duration(milliseconds: 300),
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
                    onTap: () => _recipeCardPageController.nextPage(
                        duration: Duration(milliseconds: 300),
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
