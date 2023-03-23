import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:co_cook/services/audio_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

import 'package:co_cook/widgets/sound_meter/sound_meter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class VoiceSearchScreen extends StatefulWidget {
  const VoiceSearchScreen({super.key});

  @override
  State<VoiceSearchScreen> createState() => _VoiceSearchScreenState();
}

class _VoiceSearchScreenState extends State<VoiceSearchScreen> {
  /////////////////////////////////////////////////////////////////////////////
  ///Recoder
  ///
  Record _recorder = Record(); // 녹음 라이브러리
  late Directory cookTempDir; // 음성파일이 저장될 임시디렉토리
  late Timer? _recordingTimer; // 마이크 볼륨 추적할 타이머
  bool _isListening = false;
  bool _isRecording = false; // 녹음 여부
  bool _isSay = false; // 음성호출 이후 사용자가 말을 했는지 여부

  int audioFilePk = 0; // 녹음파일 제목 pk값

  late AudioPlayer _audioPlayer; // 음성인식시 효과음 재생할 player 선언

  @override
  void initState() {
    setTempDir();
    setState(() {
      _audioPlayer = AudioPlayer();
    });
    super.initState();
  }

  Future<void> setTempDir() async {
    final Directory tempDir = await getTemporaryDirectory();
    setState(() {
      cookTempDir = Directory('${tempDir.path}/cookAudioFiles');
    });
    if (!cookTempDir.existsSync()) {
      cookTempDir.createSync();
    }
  }

  void _startListen() async {
    setState(() {
      _isListening = true;
    });
    if (await _recorder.hasPermission() && !await _recorder.isRecording()) {
      _recorder.start();
    }
    _recordingTimer = Timer.periodic(
        const Duration(milliseconds: 100), (timer) => updateVolume());
  }

  void _stopListen() async {
    _recorder.stop();
    _recordingTimer?.cancel();
    setState(() {
      _isListening = false;
    });
    if (cookTempDir.existsSync()) {
      cookTempDir.listSync().forEach((file) => file.deleteSync());
    }
  }

  void _startRecord() async {
    await _recorder
        .stop()
        .then((value) => _recorder.start(
              path: '${cookTempDir.path}/$audioFilePk.m4a',
              encoder: AudioEncoder.aacLc,
              bitRate: 128000,
              samplingRate: 44100,
            ))
        .then((_) => setState(() {
              _isRecording = true;
            }))
        .then((_) {
      Future.delayed(const Duration(milliseconds: 500))
          .then((_) {
            if (ampl > -10) {
              // 계속 말하는 중이면 더 기다리기
              return Future.delayed(const Duration(milliseconds: 500));
            }
            // 말 안하는 중이면 null return해서 종료
            return null;
          })
          .then((_) => _recorder.stop())
          .then((value) {
            audioFilePk++;
            setState(() {
              _isRecording = false;
            });
          })
          .then((value) => _recorder.start());
    });
  }

  // 오디오 전송
  Future<void> postAudio(String path) async {
    // API 요청
    AudioService searchService = AudioService();
    Response? response = await searchService.postAudio(path);
    if (response?.statusCode == 200) {
      if (response != null) {
        print("전송 성공 : ${response.data}");
      }
    }
  }

  // volume controller
  double volume = 0.0;
  double ampl = 0.0;
  double minVolume = -45.0;

  updateVolume() async {
    Amplitude ampl = await _recorder.getAmplitude();
    if (ampl.current > minVolume && mounted) {
      if (ampl.current > -10 && !_isRecording) {
        _startRecord();
      }
      setState(() {
        ampl = ampl;
        volume = (ampl.current - minVolume) / minVolume;
      });
      print("Volume : $volume, ampl.current : ${ampl.current}");
    }
  }

  int volume0to(int maxVolumeToDisplay) {
    return (volume * maxVolumeToDisplay).round().abs();
  }

  /////////////////////////////////////////////////////////////////////////////

  @override
  void dispose() {
    _recorder.stop();
    if (cookTempDir.existsSync()) {
      cookTempDir.listSync().forEach((file) => file.deleteSync());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: CustomColors.redLight,
      child: ZoomTapAnimation(
        onTap: () {
          !_isListening ? _startListen() : _stopListen();
        },
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(70.0),
            color: CustomColors.monotoneLight,
            border: Border.all(
                color: CustomColors.monotoneLightGray,
                width: 8,
                strokeAlign: BorderSide.strokeAlignOutside),
            boxShadow: const [
              BoxShadow(
                color: CustomColors.redPrimary,
                offset: Offset(0, 0),
                blurRadius: 0.0,
                spreadRadius: 0.0,
              )
            ],
          ),
          alignment: Alignment.center,
          child: SoundMeter(
            volume: 0,
            isSpeak: false,
            isSay: false,
            dotSize: 12,
            size: 72,
          ),
        ),
      ),
    );
  }
}
