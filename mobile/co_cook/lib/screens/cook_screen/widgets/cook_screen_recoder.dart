import 'dart:io';
import 'dart:async';
import 'dart:convert'; // decode 가져오기
import 'package:dio/dio.dart';
import 'package:record/record.dart';
import 'package:flutter/material.dart';
import 'package:tflite_audio/tflite_audio.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:co_cook/services/audio_service.dart';
import 'package:co_cook/widgets/sound_meter/sound_meter.dart';

class CookScreenRecoder extends StatefulWidget {
  const CookScreenRecoder(
      {Key? key,
      required this.controlNotifier,
      required this.isPowerMode,
      required this.setPowerMode,
      required this.isTtsPlaying})
      : super(key: key);
  final ValueNotifier<String> controlNotifier;
  final bool isPowerMode;
  final Function setPowerMode;
  final ValueNotifier<bool> isTtsPlaying;

  @override
  State<CookScreenRecoder> createState() => _CookScreenRecoderState();
}

class _CookScreenRecoderState extends State<CookScreenRecoder> {
  @override
  void initState() {
    super.initState();
    _fetchNameSetTemp();
    _audioPlayer = AudioPlayer();
    startWakeWordRecord();
    widget.isTtsPlaying.addListener(_onTtsPlayingChanged); // tts play 리스너
  }

  @override
  void dispose() {
    super.dispose();
    _diposeRecord();
    if (cookTempDir.existsSync()) {
      cookTempDir.listSync().forEach((file) => file.deleteSync());
    }
    _recognitionSubscription.cancel();
    TfliteAudio.stopAudioRecognition();
    widget.isTtsPlaying.removeListener(_onTtsPlayingChanged); // tts play 리스너
  }

  //////////////
  String _nickname = '';

  // 닉네임 가져오기
  Future<void> _fetchNickname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String prefsUserData =
        prefs.getString('userData') ?? ''; // 기본값으로 빈 문자열을 사용합니다.
    Map<String, dynamic> decodePrefs = jsonDecode(prefsUserData);
    String? nickname = decodePrefs['nickname'];

    if (nickname != null) {
      setState(() {
        _nickname = nickname;
      });
    }
  }

  void _fetchNameSetTemp() async {
    await _fetchNickname();
    await setTempDir();
  }

  // tts play 리스너
  void _onTtsPlayingChanged() {
    if (widget.isTtsPlaying.value) {
      _recognitionSubscription.pause();
    } else {
      Future.delayed(const Duration(milliseconds: 700))
          .then((_) => {_recognitionSubscription.resume()});
    }
  }

  ////////////////////////////////////////////////////////////////////////////

  late Stream<Map<dynamic, dynamic>> recognitionStream;
  late StreamSubscription<Map<dynamic, dynamic>> _recognitionSubscription;
  String result = '';

  void startWakeWordRecord() {
    recognitionStream = TfliteAudio.startAudioRecognition(
        sampleRate: 44100,
        bufferSize: 20000,
        numOfInferences: 100000,
        detectionThreshold: 0.6);
    _recognitionSubscription = recognitionStream.listen((event) {
      if (event["recognitionResult"] == '2 헤이코쿡') {
        _recognitionSubscription.cancel();
        TfliteAudio.stopAudioRecognition();
        _startRecord();
      } else if (event["recognitionResult"] == '1 야윤성운') {
        _recognitionSubscription.cancel();
        TfliteAudio.stopAudioRecognition();
        widget.setPowerMode(true);
        _startRecord();
      }
    });
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
          path: '${cookTempDir.path}/$_nickname-$audioFilePk.m4a',
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          samplingRate: 44100,
        )
            .then((_) {
          setState(() {
            _isRecording = true;
          });
          startTimer();
        });

        await Future.delayed(const Duration(milliseconds: 2000)).then((_) {
          if (ampl > -10) {
            // 계속 말하는 중이면 더 기다리기
            return Future.delayed(const Duration(milliseconds: 500));
          }
          // 말 안하는 중이면 null return해서 종료
          return null;
        });
        // 녹음 종료
        await _stopRecord().then((_) async {
          _isRecording = false;
          if (_isSay) {
            // 사용자가 말 했을 때
            await Future.delayed(const Duration(milliseconds: 500));
            await postAudio('${cookTempDir.path}/$_nickname-$audioFilePk.m4a');
            setState(() {
              _isSay = false;
            });
            startWakeWordRecord();
          } else {
            // 안했을 때
            _audioPlayer.play(AssetSource('audios/ai_cancel.mp3'));
            startWakeWordRecord();
          }
        }).then((value) {
          audioFilePk++;
          widget.setPowerMode(false);
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
    Response? response = widget.isPowerMode
        ? await searchService.postAudio(path)
        : await searchService.postAudio(path);
    print(response);
    if (response?.statusCode == 200) {
      if (response != null) {
        print("전송 성공 : ${response.data}");
        setState(() {
          result = response.data['result'];
        });
        widget.controlNotifier.value = response.data['result'];
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
