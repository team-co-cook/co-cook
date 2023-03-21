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
      required this.isSpeak,
      required this.toggleSpeak});
  final double dotSize;
  final double size;
  final double volume;
  final bool isSpeak;
  final Function toggleSpeak;

  @override
  State<CookScreenSoundMeter> createState() => _CookScreenSoundMeterState();
}

class _CookScreenSoundMeterState extends State<CookScreenSoundMeter> {
  late double _currentPosition = 0;
  late Timer _positionTimer;

  void _movePosition() {
    _positionTimer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
      print(_currentPosition);
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
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          soundMeterdot(Duration(milliseconds: 600)),
          soundMeterdot(Duration(milliseconds: 700)),
          soundMeterdot(Duration(milliseconds: 800)),
          soundMeterdot(Duration(milliseconds: 900))
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

class CookScreenRecoder extends StatefulWidget {
  const CookScreenRecoder({Key? key}) : super(key: key);

  @override
  State<CookScreenRecoder> createState() => _CookScreenRecoderState();
}

class _CookScreenRecoderState extends State<CookScreenRecoder> {
  Record myRecording = Record();
  Timer? timer;

  bool _isRecording = false;

  double volume = 0.0;
  double minVolume = -45.0;

  startTimer() async {
    timer ??=
        Timer.periodic(Duration(milliseconds: 100), (timer) => updateVolume());
  }

  updateVolume() async {
    Amplitude ampl = await myRecording.getAmplitude();
    if (ampl.current > minVolume) {
      if (ampl.current > -15) {
        // 말하는중임
      }
      setState(() {
        volume = (ampl.current - minVolume) / minVolume;
      });
      print("Volume : $volume, ampl.current : ${ampl.current}");
    }
  }

  int volume0to(int maxVolumeToDisplay) {
    return (volume * maxVolumeToDisplay).round().abs();
  }

  Future<bool> startRecording() async {
    if (await myRecording.hasPermission()) {
      if (!await myRecording.isRecording()) {
        await myRecording.start();
      }
      startTimer();
      return true;
    } else {
      return false;
    }
  }

  _stopRecording() async {
    myRecording.stop();
    setState(() {
      volume = 0.0;
    });
  }

  bool isSpeak = false;
  void toggleSpeak() {
    setState(() {
      isSpeak = !isSpeak;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _stopRecording();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          CookScreenSoundMeter(
              volume: 0, isSpeak: isSpeak, toggleSpeak: toggleSpeak),
          TextButton(onPressed: () => toggleSpeak, child: Text("토글"))
        ],
      ),
    );
  }
}
