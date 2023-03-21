import 'dart:async';

import 'package:flutter/material.dart';
import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class CookScreenTimer extends StatefulWidget {
  const CookScreenTimer({super.key, required this.time, required this.play});
  final int time;
  final bool play;

  @override
  State<CookScreenTimer> createState() => _CookScreenTimerState();
}

class _CookScreenTimerState extends State<CookScreenTimer> {
  late int _currentSeconds;
  late Timer _timer;
  bool _isPlay = false;

  @override
  void initState() {
    super.initState();
    _currentSeconds = widget.time;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startEndTimer() {
    if (!_isPlay) {
      setState(() {
        _isPlay = true;
      });
      _timerFunction();
    } else {
      _timer.cancel();
      setState(() {
        _isPlay = false;
        _currentSeconds = widget.time;
      });
    }
  }

  void _timerFunction() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_currentSeconds > 0) {
          _currentSeconds--;
        } else {
          _startEndTimer();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: ZoomTapAnimation(
        onTap: () => _startEndTimer(),
        end: 0.98,
        child: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Color.fromARGB(212, 61, 168, 51),
            borderRadius: BorderRadius.circular(16.0),
          ),
          alignment: Alignment.center,
          child: Stack(children: [
            Container(
              margin: EdgeInsets.only(left: 16.0),
              child: Row(
                children: [
                  Icon(
                    _isPlay ? Icons.stop : Icons.play_arrow,
                    color: CustomColors.monotoneLight,
                    size: 32,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    alignment: Alignment.center,
                    child: Text(
                        "${(_currentSeconds / 60).floor().toString().padLeft(2, "0")}:${(_currentSeconds % 60).toString().padLeft(2, "0")}",
                        style: const CustomTextStyles().subtitle1.copyWith(
                              color: CustomColors.monotoneLight,
                            )),
                  ),
                ],
              ),
            ),
            Positioned(child: LayoutBuilder(builder: (context, constraints) {
              return Container(
                alignment: Alignment.centerRight,
                child: Container(
                  width: (constraints.maxWidth / widget.time) * _currentSeconds,
                  height: constraints.maxHeight,
                  decoration: BoxDecoration(
                    backgroundBlendMode: BlendMode.colorBurn,
                    borderRadius: BorderRadius.circular(14.0),
                    color: Color.fromARGB(172, 61, 168, 51),
                  ),
                ),
              );
            })),
          ]),
        ),
      ),
    );
  }
}
