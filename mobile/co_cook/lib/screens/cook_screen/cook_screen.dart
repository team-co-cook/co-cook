import 'dart:async';

import 'package:co_cook/screens/cook_screen/widgets/cook_screen_body.dart';
import 'package:co_cook/screens/cook_screen/widgets/cook_screen_request_rotate.dart';
import 'package:co_cook/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

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
                      CookScreenSoundMeter(),
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

class CookScreenSoundMeter extends StatelessWidget {
  const CookScreenSoundMeter({super.key, this.size = 8});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size * 4 + 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size / 2),
              color: CustomColors.redSecondary,
            ),
          ),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size / 2),
              color: CustomColors.redSecondary,
            ),
          ),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size / 2),
              color: CustomColors.redSecondary,
            ),
          ),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size / 2),
              color: CustomColors.redSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
