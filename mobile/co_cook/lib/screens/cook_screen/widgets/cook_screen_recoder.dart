import 'dart:async';
import 'dart:io';

import 'package:co_cook/screens/cook_screen/widgets/cook_screen_sound_meter.dart';
import 'package:flutter/material.dart';
import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

import 'package:record/record.dart';

class CookScreenRecoder extends StatefulWidget {
  const CookScreenRecoder({Key? key}) : super(key: key);

  @override
  State<CookScreenRecoder> createState() => _CookScreenRecoderState();
}

class _CookScreenRecoderState extends State<CookScreenRecoder> {
  Record _recorder = Record();
  Directory directory = Directory('cookAudioFiles');
  late Timer? _recordingTimer = null;
  int audioFilePk = 0;

  bool _isRecording = false;

  void startTimer() async {
    _recordingTimer = Timer.periodic(
        const Duration(milliseconds: 100), (timer) => updateVolume());
  }

  void _startRecord() async {
    if (await _recorder.hasPermission()) {
      print("녹음시작!!!!!!!!!!");
      // if (!_isRecording) {
      //   await _recorder.start(
      //     path: 'cookAudioFiles/$audioFilePk.m4a',
      //     encoder: AudioEncoder.aacLc,
      //     bitRate: 128000,
      //     samplingRate: 44100,
      //   );
      //   startTimer();
      // }
    }
    print(await _recorder.isRecording().toString());
  }

  void _stopRecord() {
    setState(() {
      volume = 0.0;
      _isRecording = false;
    });
    _recordingTimer?.cancel();
    _recorder.stop();
  }

  double volume = 0.0;
  double minVolume = -45.0;

  updateVolume() async {
    Amplitude ampl = await _recorder.getAmplitude();
    if (ampl.current > minVolume && mounted) {
      // ampl이 -10보다 큰 경우를 말하고 있다고 판단, 녹음이 되고 있지 않는 경우
      if (ampl.current > -10 && !_isRecording) {
        // 녹음 시작
        setState(() {
          _isRecording = true;
        });
        // 계속 말하는 중인지 기다리기
        Future.delayed(Duration(milliseconds: 500)).then((_) {
          if (ampl.current > -15) {
            // 계속 말하는 중이면 더 기다리기
            return Future.delayed(Duration(milliseconds: 500));
          }
          // 말 안하는 중이면 null return해서 종료
          return null;
        }).then((_) {
          // 녹음 종료
          setState(() {
            _isRecording = false;
            audioFilePk++;
          });
          // print(_recorder.path());
        });
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // _stopRecord();
    if (directory.existsSync()) {
      directory.listSync().forEach((file) => file.deleteSync());
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          CookScreenSoundMeter(
              volume: _isRecording ? volume0to(100).toDouble() : 0,
              isSpeak: _isRecording),
          TextButton(
              onPressed: () => _startRecord(),
              child: Text(volume0to(100).toString())),
          TextButton(
              onPressed: () => _stopRecord(),
              child: Text(_isRecording.toString())),
        ],
      ),
    );
  }
}
