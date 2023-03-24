import 'dart:convert'; // decode 가져오기
import 'dart:io';
import 'package:dio/dio.dart'; // Response 가져오기 위함.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:image_picker/image_picker.dart';
// 사진 저장용
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:gallery_saver/gallery_saver.dart';
import 'package:share_plus/share_plus.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

import 'package:co_cook/widgets/save_complete/save_complete.dart';
import 'package:co_cook/screens/photo_card_screen/widgets/photo_card.dart';

class PhotoCardScreen extends StatefulWidget {
  const PhotoCardScreen(
      {Key? key,
      required this.recipeName,
      required this.startTime,
      required this.endTime,
      required this.text,
      required this.image})
      : super(key: key);
  final String recipeName;
  final DateTime startTime;
  final DateTime endTime;
  final String text;
  final XFile image;

  @override
  _PhotoCardScreenState createState() => _PhotoCardScreenState();
}

class _PhotoCardScreenState extends State<PhotoCardScreen> {
  late final String timeString;
  late final String cookingTimeString;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko_KR');
    timeString = _getTimeString();
    cookingTimeString = _getCookingTimeString();
  }

  String _getTimeString() {
    final formatter = DateFormat('yyyy. MM. dd. (E)', 'ko_KR');
    return formatter.format(widget.startTime);
  }

  String _getCookingTimeString() {
    final difference = widget.endTime.difference(widget.startTime);

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;

    return '조리시간 ${hours.toString().padLeft(2, '0')}분 ${minutes.toString().padLeft(2, '0')}초';
  }

  final GlobalKey globalKey = GlobalKey();

  Future<String> capturePicture() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    // 이미지를 임시 파일로 저장
    final tempDir = await getTemporaryDirectory();
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final tempPath = '${tempDir.path}/$fileName.png';
    File imgFile = File(tempPath);
    await imgFile.writeAsBytes(pngBytes);

    return tempPath;
  }

  Future<void> sharePicture() async {
    String imagePath = await capturePicture();
    // 이미지를 공유
    await Share.shareFiles([imagePath], text: '포토카드를 확인해보세요!');
  }

  Future<void> savePicture() async {
    String imagePath = await capturePicture();
    // 갤러리에 저장
    GallerySaver.saveImage(imagePath).then((bool? success) {
      if (success == true) {
        print("이미지가 갤러리에 저장되었습니다.");
      } else {
        print("이미지 저장 실패");
      }
    });
  }

  void saveComplete() async {
    await savePicture();
    SaveComplete.show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.monotoneBlack,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: CustomColors.monotoneLight, // 아이콘 색상
                        size: 40,
                      )),
                ),
              ],
            ),
            SizedBox(height: 40),
            RepaintBoundary(
              key: globalKey,
              child: PhotoCard(
                widget: widget,
                cookingTimeString: cookingTimeString,
                timeString: timeString,
              ),
            ),
            SizedBox(height: 60), // 원하는 간격 조절
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: sharePicture,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // 버튼 색상
                        shape: CircleBorder(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(11, 10, 11, 12),
                        child: Icon(
                          Icons.ios_share,
                          color: CustomColors.monotoneBlack, // 아이콘 색상
                          size: 24,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('공유',
                          style: CustomTextStyles()
                              .button
                              .copyWith(color: CustomColors.monotoneLight)),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: saveComplete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // 버튼 색상
                        shape: CircleBorder(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(11, 10, 11, 12),
                        child: Icon(
                          Icons.save_alt,
                          color: CustomColors.monotoneBlack, // 아이콘 색상
                          size: 24,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('저장',
                          style: CustomTextStyles()
                              .button
                              .copyWith(color: CustomColors.monotoneLight)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
