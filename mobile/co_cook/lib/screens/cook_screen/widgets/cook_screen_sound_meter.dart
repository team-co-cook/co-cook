import 'dart:async';

import 'package:flutter/material.dart';
import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

import 'package:record/record.dart';

class CookScreenSoundMeter extends StatefulWidget {
  const CookScreenSoundMeter(
      {super.key,
      this.dotSize = 8,
      this.size = 48,
      required this.volume,
      required this.isSpeak});
  final double dotSize;
  final double size;
  final double volume;
  final bool isSpeak;

  @override
  State<CookScreenSoundMeter> createState() => _CookScreenSoundMeterState();
}

class _CookScreenSoundMeterState extends State<CookScreenSoundMeter> {
  late double _currentPosition = 0;
  late Timer? _positionTimer;

  void _movePosition() {
    _positionTimer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
      setState(() {
        if (widget.isSpeak) {
          _currentPosition = 0;
        } else {
          if (_currentPosition == -1) {
            _currentPosition = 1;
          } else {
            _currentPosition = -1;
          }
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _movePosition();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _positionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          soundMeterdot(Duration(milliseconds: widget.isSpeak ? 200 : 600)),
          soundMeterdot(Duration(milliseconds: widget.isSpeak ? 50 : 700)),
          soundMeterdot(Duration(milliseconds: widget.isSpeak ? 100 : 800)),
          soundMeterdot(Duration(milliseconds: widget.isSpeak ? 300 : 900))
        ],
      ),
    );
  }

  Widget soundMeterdot(Duration duration) {
    return AnimatedContainer(
      duration: duration,
      curve: Curves.easeInOutQuad,
      transform: Transform.translate(offset: Offset(0, _currentPosition * 10))
          .transform,
      alignment: Alignment.center,
      width: widget.dotSize,
      height: widget.dotSize + (widget.volume / 100 * widget.size),
      decoration: BoxDecoration(
          color: CustomColors.redPrimary,
          borderRadius: BorderRadius.circular(4)),
    );
  }
}
