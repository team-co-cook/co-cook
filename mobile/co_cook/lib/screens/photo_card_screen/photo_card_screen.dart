import 'dart:convert'; // decode 가져오기
import 'dart:io';
import 'package:dio/dio.dart'; // Response 가져오기 위함.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:image_picker/image_picker.dart';
// 사진 저장용
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

import 'package:co_cook/screens/photo_card_screen/widgets/photo_card.dart';

class PhotoCardScreen extends StatefulWidget {
  const PhotoCardScreen(
      {Key? key,
      required this.cookName,
      required this.time,
      required this.text,
      required this.image})
      : super(key: key);
  final String cookName;
  final DateTime time;
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
    return formatter.format(widget.time);
  }

  String _getCookingTimeString() {
    final now = DateTime.now();
    final difference = now.difference(widget.time);

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;

    return '조리시간 ${hours.toString().padLeft(2, '0')}분 ${minutes.toString().padLeft(2, '0')}초';
  }

  GlobalKey globalKey = GlobalKey();

  Future<void> _saveToGallery() async {
    // 권한 요청
    final status = await Permission.photos.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('갤러리 접근 권한이 필요합니다.')));
      return;
    }

    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    // 이미지 저장
    final result = await ImageGallerySaver.saveImage(pngBytes);
    if (result['isSuccess'] == true) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('갤러리에 저장되었습니다.')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('갤러리 저장에 실패했습니다.')));
    }
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
            RepaintBoundary(
              key: globalKey,
              child: PhotoCard(
                widget: widget,
                cookingTimeString: cookingTimeString,
                timeString: timeString,
              ),
            ),
            SizedBox(height: 20), // 원하는 간격 조절
            ElevatedButton(
              onPressed: _saveToGallery,
              style: ElevatedButton.styleFrom(
                primary: Colors.white, // 버튼 색상
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // 버튼 모서리 둥글게
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.share,
                      color: CustomColors.monotoneBlack, // 아이콘 색상
                    ),
                    SizedBox(width: 10),
                    Text(
                      '공유하기',
                      style: TextStyle(
                        color: CustomColors.monotoneBlack, // 텍스트 색상
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
