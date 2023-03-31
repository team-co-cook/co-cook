import 'dart:async';
import 'dart:io';

import 'package:co_cook/widgets/button/button.dart';
import 'package:dio/dio.dart';
import 'package:record/record.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:co_cook/services/audio_service.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

import 'package:co_cook/widgets/sound_meter/sound_meter.dart';
import 'package:co_cook/screens/ingredient_list_screen/ingredient_list_screen.dart';

class VoiceSearchScreen extends StatefulWidget {
  const VoiceSearchScreen({super.key, this.isPushed = false});
  final bool isPushed;

  @override
  State<VoiceSearchScreen> createState() => _VoiceSearchScreenState();
}

class _VoiceSearchScreenState extends State<VoiceSearchScreen> {
  /////////////////////////////////////////////////////////////////////////////
  ///Recoder
  ///
  Record _recorder = Record(); // 녹음 라이브러리
  late Directory aiVoiceTempDir; // 음성파일이 저장될 임시디렉토리
  late Directory aiVoiceTrimTempDir; // 음성파일이 저장될 임시디렉토리
  late Timer? _recordingTimer; // 마이크 볼륨 추적할 타이머
  bool _isListening = false;
  bool _isRecording = false; // 녹음 여부
  late DateTime _startListenTime;
  late DateTime _startRecordTime;

  List<String> _reciveIngredientList = [];
  int _loadIngreciveIngredientCount = 0;

  int audioFilePk = 0; // 녹음파일 제목 pk값

  late AudioPlayer _audioPlayer = AudioPlayer(); // 음성인식시 효과음 재생할 player 선언

  @override
  void initState() {
    setTempDir();
    // 디렉토리 생성
    super.initState();
  }

  Future<void> setTempDir() async {
    final Directory tempDir = await getTemporaryDirectory();
    setState(() {
      aiVoiceTempDir = Directory('${tempDir.path}/searchAudioFile');
      aiVoiceTrimTempDir = Directory('${tempDir.path}/searchTrimAudioFile');
    });
    if (!aiVoiceTempDir.existsSync()) {
      aiVoiceTempDir.createSync();
    }
    if (!aiVoiceTrimTempDir.existsSync()) {
      aiVoiceTrimTempDir.createSync();
    }
  }

  void _startListen() async {
    setState(() {
      _isListening = true;
      _startListenTime = DateTime.now();
    });
    if (await _recorder.hasPermission() && !await _recorder.isRecording()) {
      _recorder.start(
        path: '${aiVoiceTempDir.path}/$audioFilePk.m4a',
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        samplingRate: 44100,
      );
    }
    _recordingTimer = Timer.periodic(
        const Duration(milliseconds: 100), (timer) => updateVolume());
  }

  void _stopListen() async {
    _recorder.stop();
    _recordingTimer?.cancel();
    setState(() {
      _isListening = false;
      ampl = 0.0;
      volume = 0.0;
      _loadIngreciveIngredientCount = 0;
    });
    if (aiVoiceTempDir.existsSync()) {
      aiVoiceTempDir.listSync().forEach((file) => file.deleteSync());
    }
    if (aiVoiceTrimTempDir.existsSync()) {
      aiVoiceTrimTempDir.listSync().forEach((file) => file.deleteSync());
    }
  }

  void _startRecord() async {
    setState(() {
      _isRecording = true;
      _startRecordTime = DateTime.now();
    });
    await Future.delayed(const Duration(milliseconds: 500)).then((_) {
      if (ampl > -10) {
        // 계속 말하는 중이면 더 기다리기
        return Future.delayed(const Duration(milliseconds: 500));
      }
      // 말 안하는 중이면 null return해서 종료
      return null;
    }).then((value) async {
      setState(() {
        _isRecording = false;
        _isListening = false;
        _loadIngreciveIngredientCount++;
      });
      await _recorder.stop(); // 녹음된 음성파일 저장
      aiProcess(audioFilePk); // 녹음된 음성파일 편집 후 서버로 전송(비동기)
      await Future.delayed(const Duration(milliseconds: 500)); // 딜레이(오류방지)
      audioFilePk++; // pk값 바꿔주기
      await _recorder.start(
        // 다음 녹음세션 시작
        path: '${aiVoiceTempDir.path}/$audioFilePk.m4a',
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        samplingRate: 44100,
      );
      setState(() {
        // 녹음중 상태 바꿔주기
        _isListening = true;
        _startListenTime = DateTime.now(); // 현재 시간부터 녹음 다시 시작
      });
    });
  }

  Future<void> aiProcess(int audioPk) async {
    await _audioPlayer
        .setSourceDeviceFile("${aiVoiceTempDir.path}/$audioPk.m4a");
    Duration audioDuration =
        await _audioPlayer.getDuration() ?? const Duration(seconds: 0);
    int audioDurationDefference =
        _startRecordTime.difference(_startListenTime).inMilliseconds;
    await trimAudio(
            "${aiVoiceTempDir.path}/$audioPk.m4a",
            "${aiVoiceTrimTempDir.path}/$audioPk.m4a",
            (audioDurationDefference - 500) >= 0
                ? (audioDurationDefference - 500) / 1000
                : 0,
            audioDuration.inMilliseconds / 1000)
        .then(
      (value) => Future.delayed(const Duration(seconds: 3)),
    );
    await postAudio("${aiVoiceTrimTempDir.path}/$audioPk.m4a");
  }

  Future<void> trimAudio(String inputPath, String outputPath, double startTime,
      double endTime) async {
    // FFmpeg 명령어 작성
    final String command =
        '-y -i $inputPath -ss $startTime -to $endTime -vn -acodec copy $outputPath';

    // FFmpeg 실행
    await FFmpegKit.executeAsync(command);
  }

  // 오디오 전송
  Future<void> postAudio(String path) async {
    // API 요청
    AudioService searchService = AudioService();
    Response? response = await searchService.postAudioIngredient(path);
    if (response?.statusCode == 200 &&
        response != null &&
        !_reciveIngredientList.contains(response.data["result"])) {
      setState(() {
        _loadIngreciveIngredientCount--;
        _reciveIngredientList.insert(0, response.data["result"]);
      });
    } else {
      setState(() {
        _loadIngreciveIngredientCount--;
      });
    }
  }

  void _removeTag(String label) {
    setState(() {
      _reciveIngredientList.remove(label);
    });
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
      debugPrint("Volume : $volume, ampl.current : ${ampl.current}");
    }
  }

  int volume0to(int maxVolumeToDisplay) {
    return (volume * maxVolumeToDisplay).round().abs();
  }

  // 재료 검색 결과 목록으로 이동
  void gotoVoiceList() {
    if (_reciveIngredientList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("검색어가 존재하지 않습니다."),
        duration: Duration(seconds: 1),
      ));
      return;
    }
    _stopListen();
    Route ingredientListScreen = MaterialPageRoute(
        builder: (context) =>
            IngredientListScreen(ingredients: _reciveIngredientList));
    Navigator.push(context, ingredientListScreen);
  }

  /////////////////////////////////////////////////////////////////////////////
  ///

  @override
  void dispose() {
    _recorder.stop();
    if (aiVoiceTempDir.existsSync()) {
      aiVoiceTempDir.listSync().forEach((file) => file.deleteSync());
    }
    if (aiVoiceTrimTempDir.existsSync()) {
      aiVoiceTrimTempDir.listSync().forEach((file) => file.deleteSync());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isPushed
          ? AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: CustomColors.monotoneLight,
              elevation: 0.5,
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back,
                  color: CustomColors.monotoneBlack,
                ),
              ),
            )
          : null,
      body: Container(
        alignment: Alignment.topCenter,
        color: CustomColors.redLight,
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 5),
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 5 * 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ZoomTapAnimation(
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
                        color: _isListening
                            ? _isRecording
                                ? CustomColors.greenPrimary
                                : CustomColors.redPrimary
                            : CustomColors.monotoneLightGray,
                        width: 8,
                        strokeAlign: BorderSide.strokeAlignOutside),
                    boxShadow: [
                      BoxShadow(
                        color: _isRecording
                            ? CustomColors.greenPrimary
                            : CustomColors.redPrimary,
                        offset: const Offset(0, 0),
                        blurRadius: volume0to(100).toDouble(),
                        spreadRadius: 0.0,
                      )
                    ],
                  ),
                  alignment: Alignment.center,
                  child: SoundMeter(
                    volume: volume0to(100).toDouble(),
                    isSpeak: _isListening,
                    isSay: _isRecording,
                    dotSize: 12,
                    size: 72,
                  ),
                ),
              ),
              ZoomTapAnimation(
                onTap: () {
                  !_isListening ? _startListen() : _stopListen();
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 40.0, bottom: 20),
                  child: Text(_isListening ? "듣고있어요" : "탭하여 시작",
                      style: const CustomTextStyles().title1.copyWith(
                            color: _isListening
                                ? CustomColors.redPrimary
                                : CustomColors.monotoneLightGray,
                          )),
                ),
              ),
              Text("냉장고 속 재료를\n말해보세요",
                  textAlign: TextAlign.center,
                  style: const CustomTextStyles().subtitle2.copyWith(
                        color: CustomColors.monotoneGray,
                      )),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 32.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
                            child: Wrap(
                                alignment: WrapAlignment.center,
                                direction: Axis.horizontal, // 나열 방향
                                spacing: 8, // 좌우 간격
                                runSpacing: 8, // 상하 간격
                                children: List.from(List<Widget>.generate(
                                    _loadIngreciveIngredientCount,
                                    (index) => voiceSearchTag(null)))
                                  ..addAll(_reciveIngredientList
                                      .map((item) => voiceSearchTag(item)))),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.only(top: 24.0, bottom: 40.0),
                        child: CommonButton(
                            label: "완료",
                            color: ButtonType.red,
                            onPressed: () => gotoVoiceList())),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget voiceSearchTag(String? label) {
    return ZoomTapAnimation(
      onTap: () => label == null ? null : _removeTag(label),
      child: Container(
          height: 48,
          padding: const EdgeInsets.only(left: 16, right: 16),
          decoration: BoxDecoration(
              color: CustomColors.monotoneLight,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(23, 0, 0, 0),
                  offset: Offset(1, 1),
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                )
              ]),
          child: IntrinsicWidth(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                label == null
                    ? Container(
                        alignment: Alignment.center,
                        height: 20,
                        width: 20,
                        child: const CircularProgressIndicator(
                            color: CustomColors.redPrimary))
                    : Text(
                        label ?? "",
                        style: const CustomTextStyles()
                            .button
                            .copyWith(color: CustomColors.monotoneBlack),
                      ),
                Container(
                  margin: const EdgeInsets.only(left: 4),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                  ),
                )
              ],
            ),
          )),
    );
  }
}
