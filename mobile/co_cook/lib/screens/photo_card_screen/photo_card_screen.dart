import 'dart:convert'; // decode 가져오기
import 'dart:io';
import 'package:dio/dio.dart'; // Response 가져오기 위함.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:image_picker/image_picker.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.monotoneBlack,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: PhotoCard(
                  widget: widget,
                  cookingTimeString: cookingTimeString,
                  timeString: timeString)),
        ],
      ),
    );
  }
}
