import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

import 'package:co_cook/screens/cook_screen/widgets/cook_screen_body.dart';
import 'package:co_cook/screens/cook_screen/widgets/cook_screen_recoder.dart';
import 'package:co_cook/screens/cook_screen/widgets/cook_screen_request_rotate.dart';
import 'package:co_cook/widgets/button/button.dart';
import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:co_cook/services/detail_service.dart';
import 'package:shimmer/shimmer.dart';

class CookScreen extends StatefulWidget {
  const CookScreen({super.key, required this.recipeIdx});
  final int recipeIdx;

  @override
  State<CookScreen> createState() => _CookScreenState();
}

class _CookScreenState extends State<CookScreen> {
  final ValueNotifier<String> controlNotifier =
      ValueNotifier<String>(''); // 음성명령어 상태를 전달하기 위한 노티파이어
  final ValueNotifier<bool> isTtsPlaying =
      ValueNotifier<bool>(false); // tts 상태관리 노티파이어
  late StreamSubscription<AccelerometerEvent> _accelerometerSub;
  bool isRotated = false;
  Map _recipeData = {};

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    startAccelerometerListener();
    getDetailBasic(widget.recipeIdx);
    Wakelock.enable();
  }

  void startAccelerometerListener() {
    _accelerometerSub = accelerometerEvents.listen((AccelerometerEvent event) {
      if (event.x > 9.0 || event.x < -9.0) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ]);
        if (!isRotated) {
          setState(() {
            isRotated = true;
          });
          _accelerometerSub.cancel();
        }
      }
    });
  }

  bool isPowerMode = false;
  void setPowerMode(mode) {
    setState(() {
      isPowerMode = mode;
    });
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    Wakelock.disable();
  }

  void shutdownCook(BuildContext context) async {
    _accelerometerSub.cancel();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    Navigator.pop(context);
  }

  Future<void> getDetailBasic(int recipeIdx) async {
    // API 요청
    DetailService searchService = DetailService();
    Response? response =
        await searchService.getDetailBasic(recipeIdx: recipeIdx);
    if (response?.statusCode == 200) {
      if (response != null) {
        setState(() {
          _recipeData = response.data['data'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return !isRotated
        ? const CookScreenRequestRotate()
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: CustomColors.monotoneLight,
              elevation: 0.5,
              toolbarHeight: 60,
              flexibleSpace: Stack(children: [
                isPowerMode
                    ? Positioned(
                        top: 0,
                        left: 0,
                        bottom: 0,
                        right: 0,
                        child: Shimmer.fromColors(
                            baseColor: Color.fromARGB(255, 23, 23, 23),
                            highlightColor: CustomColors.redPrimary,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.white,
                            )),
                      )
                    : Container(),
                SafeArea(
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 40.0, right: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _recipeData['recipeName'] != null
                            ? Text(_recipeData['recipeName'],
                                style: const CustomTextStyles().title2.copyWith(
                                      color: isPowerMode
                                          ? const Color.fromARGB(
                                              255, 255, 255, 255)
                                          : CustomColors.monotoneBlack,
                                    ))
                            : Text(''),
                        CookScreenRecoder(
                            controlNotifier: controlNotifier,
                            isPowerMode: isPowerMode,
                            setPowerMode: setPowerMode,
                            isTtsPlaying: isTtsPlaying),
                        CommonButton(
                            label: "종료",
                            color: ButtonType.red,
                            onPressed: () {
                              showCloseConfirmDialog(context, shutdownCook);
                            }),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
            body: _recipeData['recipeName'] != null
                ? CookScreenBody(
                    controlNotifier: controlNotifier,
                    recipeIdx: widget.recipeIdx,
                    recipeName: _recipeData['recipeName'],
                    isPowerMode: isPowerMode,
                    isTtsPlaying: isTtsPlaying)
                : Container());
  }
}

Future<void> showCloseConfirmDialog(BuildContext context, onPressed) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('종료하시겠습니까?',
            style: CustomTextStyles()
                .body1
                .copyWith(color: CustomColors.monotoneBlack)),
        content: Text('진행사항은 저장되지 않습니다.',
            style: CustomTextStyles()
                .body1
                .copyWith(color: CustomColors.monotoneBlack)),
        actions: [
          TextButton(
            child: Text('취소',
                style: CustomTextStyles()
                    .body1
                    .copyWith(color: CustomColors.monotoneBlack)),
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          TextButton(
            child: Text('종료',
                style: CustomTextStyles()
                    .body1
                    .copyWith(color: CustomColors.redPrimary)),
            onPressed: () {
              Navigator.of(context).pop();
              onPressed(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      );
    },
  );
}
