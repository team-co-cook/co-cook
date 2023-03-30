import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:co_cook/services/audio_service.dart';

import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:porcupine_flutter/porcupine.dart';
import 'package:porcupine_flutter/porcupine_error.dart';
import 'package:porcupine_flutter/porcupine_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:co_cook/widgets/sound_meter/sound_meter.dart';

class CookScreenRecoder extends StatefulWidget {
  const CookScreenRecoder({Key? key}) : super(key: key);

  @override
  State<CookScreenRecoder> createState() => _CookScreenRecoderState();
}

class _CookScreenRecoderState extends State<CookScreenRecoder> {
  /////////////////////////////////////////////////////////////////////////////
  ///PicoVioce
  ///
  late List apiKeys;
  late int apiKeyIndex;
  int maxIndex = 3;

  final List<String> keywordAssets = Platform.isAndroid
      ? [
          "assets/keywords/cocook_ko_android.ppn",
          "assets/keywords/seongwun_ko_android.ppn"
        ]
      : [
          "assets/keywords/cocook_ko_ios.ppn",
          "assets/keywords/seongwun_ko_ios.ppn"
        ];

  late PorcupineManager _porcupineManager;

  void createPorcupineManager() async {
    apiKeys = [
      dotenv.env['PICOVOICE_API_KEY_1'],
      dotenv.env['PICOVOICE_API_KEY_2'],
      dotenv.env['PICOVOICE_API_KEY_3'],
      dotenv.env['PICOVOICE_API_KEY_4']
    ];

    try {
      // PorcupineManager를 생성하고 키워드 검출을 시작합니다.
      _porcupineManager = await PorcupineManager.fromKeywordPaths(
          apiKeys[apiKeyIndex],
          keywordAssets, // os별 분기처리 해야됨!!
          _wakeWordCallback,
          modelPath: "assets/keywords/porcupine_params_ko.pv",
          sensitivities: [0.8, 0.8] // 기본값은 0.5 높을수록 더 잘 응답한다. 오답일 경우도 늘어난다.
          );
      await _porcupineManager.start();
    } catch (e) {
      if (e is PorcupineActivationLimitException) {
        // 다음 인덱스를 사용합니다.
        apiKeyIndex++;

        // 최대 인덱스에 도달하면 다시 0번 인덱스로 돌아갑니다.
        if (apiKeyIndex > maxIndex) {
          apiKeyIndex = 0;
        }

        // PorcupineManager를 생성하고 키워드 검출을 시작합니다.
        _porcupineManager = await PorcupineManager.fromKeywordPaths(
            apiKeys[apiKeyIndex],
            keywordAssets, // os별 분기처리 해야됨!!
            _wakeWordCallback,
            modelPath: "assets/keywords/porcupine_params_ko.pv",
            sensitivities: [0.8, 0.8] // 기본값은 0.5 높을수록 더 잘 응답한다. 오답일 경우도 늘어난다.
            );
        await _porcupineManager.start();
      } else {
        // 다른 예외는 다시 throw합니다.
        throw e;
      }
    }
  }

  _wakeWordCallback(int value) async {
    // value는 감지된 키워드의 인덱스입니다. keywordAssets에서 정의한 순서와 일치합니다.
    if (value == 0) {
      // 코국 키워드에 대한 작업 수행
      print('코쿡');
      await _porcupineManager.stop().then((value) => _startRecord());
    } else if (value == 1) {
      // 성운 키워드에 대한 작업 수행
      print('성운');
      await _porcupineManager.stop().then((value) => _startRecord());
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  ///Recoder
  ///
  Record _recorder = Record(); // 녹음 라이브러리
  late Directory cookTempDir; // 음성파일이 저장될 임시디렉토리
  Timer? _recordingTimer; // 마이크 볼륨 추적할 타이머
  bool _isRecording = false; // 녹음 여부
  bool _isSay = false; // 음성호출 이후 사용자가 말을 했는지 여부

  int audioFilePk = 0; // 녹음파일 제목 pk값

  late AudioPlayer _audioPlayer; // 음성인식시 효과음 재생할 player 선언

  @override
  void initState() {
    super.initState();

    setTempDir();
    setState(() {
      _audioPlayer = AudioPlayer();
    });
    createPorcupineManager();

    // 오늘자 기준 키  인덱스 설정
    DateTime now = DateTime.now();
    apiKeyIndex = now.day % 4;
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

  void startTimer() async {
    _recordingTimer = Timer.periodic(
        const Duration(milliseconds: 100), (timer) => updateVolume());
  }

  void _startRecord() async {
    if (await _recorder.hasPermission()) {
      // 마이크 권한이 있을 때
      if (!await _recorder.isRecording()) {
        // 녹음이 실행되고 있을 때
        await _audioPlayer.play(AssetSource('audios/ai_activate.mp3'));
        await Future.delayed(const Duration(microseconds: 300));
        await _recorder
            .start(
          path: '${cookTempDir.path}/$audioFilePk.m4a',
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          samplingRate: 44100,
        )
            .then((_) {
          setState(() {
            _isRecording = true;
          });
          startTimer();
        }).then((_) {
          Future.delayed(const Duration(milliseconds: 3000)).then((_) {
            if (ampl > -10) {
              // 계속 말하는 중이면 더 기다리기
              return Future.delayed(const Duration(milliseconds: 500));
            }
            // 말 안하는 중이면 null return해서 종료
            return null;
          }).then((_) {
            // 녹음 종료
            _stopRecord().then((_) {
              _isRecording = false;
              if (_isSay) {
                // 사용자가 말 했을 때
                postAudio('${cookTempDir.path}/$audioFilePk.m4a');
                _audioPlayer.play(
                    DeviceFileSource('${cookTempDir.path}/$audioFilePk.m4a'));
                setState(() {
                  _isSay = false;
                });
              } else {
                // 안했을 때
                _audioPlayer.play(AssetSource('audios/ai_cancel.mp3'));
              }
            }).then((value) {
              audioFilePk++;
              _porcupineManager.start();
            });
          });
        });
      }
    } else {
      // 마이크 권한이 없을 때
    }
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

  Future<bool> _stopRecord() async {
    setState(() {
      volume = 0.0;
      ampl = 0.0;
    });
    _recordingTimer?.cancel();
    _recorder.stop();
    return true;
  }

  Future<bool> _diposeRecord() async {
    _recordingTimer?.cancel();
    _recorder.stop();
    return true;
  }

  // volume controller
  double volume = 0.0;
  double ampl = 0.0;
  double minVolume = -45.0;

  updateVolume() async {
    Amplitude ampl = await _recorder.getAmplitude();
    if (ampl.current > minVolume && mounted) {
      // ampl이 -10보다 큰 경우를 말하고 있다고 판단, 녹음이 되고 있지 않는 경우
      if (ampl.current > -10 && !_isSay) {
        setState(() {
          _isSay = true;
        });
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
    _diposeRecord();
    if (cookTempDir.existsSync()) {
      cookTempDir.listSync().forEach((file) => file.deleteSync());
    }
    _porcupineManager.stop();
    _porcupineManager.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          SoundMeter(
              volume: _isRecording ? volume0to(100).toDouble() : 0,
              isSpeak: _isRecording,
              isSay: _isSay),
        ],
      ),
    );
  }
}
