import 'dart:async';

import 'package:co_cook/screens/cook_screen/widgets/cook_screen_body.dart';
import 'package:co_cook/screens/cook_screen/widgets/cook_screen_recoder.dart';
import 'package:co_cook/screens/cook_screen/widgets/cook_screen_request_rotate.dart';
import 'package:co_cook/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'widgets/cook_screen_sound_meter.dart';

class CookScreen extends StatefulWidget {
  const CookScreen({super.key});

  @override
  State<CookScreen> createState() => _CookScreenState();
}

class _CookScreenState extends State<CookScreen> {
  late StreamSubscription<AccelerometerEvent> _accelerometerSub;
  bool isRotated = false;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    startAccelerometerListener();
    super.initState();
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

  @override
  void dispose() {
    _accelerometerSub.cancel();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !isRotated
        ? const CookScreenRequestRotate()
        : Scaffold(
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
                          style: const CustomTextStyles().title2.copyWith(
                                color: CustomColors.monotoneBlack,
                              )),
                      CookScreenRecoder(),
                      CommonButton(
                          label: "종료",
                          color: ButtonType.red,
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                  ),
                ),
              ),
            ),
            body: CookScreenBody());
  }
}
