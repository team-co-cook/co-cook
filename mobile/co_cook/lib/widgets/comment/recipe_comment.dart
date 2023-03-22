import 'package:flutter/material.dart';
import 'dart:convert'; // decode 가져오기
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:co_cook/services/detail_service.dart';

class RecipeComment extends StatefulWidget {
  const RecipeComment(
      {super.key, required this.review, required this.panelController});
  final Map review;
  final panelController;

  @override
  State<RecipeComment> createState() => _RecipeCommentState();
}

class _RecipeCommentState extends State<RecipeComment> {
  bool _isLike = false;
  bool _myComment = false;

  @override
  void initState() {
    super.initState();
    setIsLike();
  }

  void setIsLike() {
    if (widget.review['liked']) {
      setState(() {
        _isLike = true;
      });
    }
  }

  Future<void> getUserIdx() async {
    // UserIdx 가져오기
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String prefsUserData =
        prefs.getString('userData') ?? ''; // 기본값으로 빈 문자열을 사용합니다.
    Map<String, dynamic> decodePrefs = jsonDecode(prefsUserData);
    int userIdx = decodePrefs['user_idx'];
    if (widget.review['userIdx'] == userIdx) {
      setState(() {
        _myComment = true;
      });
    }
  }

  Future<void> likeDetailReview(int reviewIdx) async {
    // API 요청
    DetailService searchService = DetailService();
    Response? response =
        await searchService.likeDetailReview(reviewIdx: reviewIdx);
    if (response?.statusCode == 200) {
      if (response != null) {
        setState(() {
          _isLike = !_isLike;
        });
      }
    }
  }

  Future<void> dislikeDetailReview(int reviewIdx) async {
    // API 요청
    DetailService searchService = DetailService();
    Response? response =
        await searchService.dislikeDetailReview(reviewIdx: reviewIdx);
    if (response?.statusCode == 200) {
      if (response != null) {
        setState(() {
          _isLike = !_isLike;
        });
      }
    }
  }

  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    DateFormat dateFormat = DateFormat('yyyy. M. d.');
    return dateFormat.format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _myComment ? "내 한줄평" : widget.review['userNickname'],
                style: const CustomTextStyles()
                    .subtitle1
                    .copyWith(color: CustomColors.monotoneBlack),
              ),
              GestureDetector(
                onTap: () => print("more"),
                child: Container(
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.more_horiz,
                        color: CustomColors.monotoneBlack)),
              ),
            ],
          ),
          AspectRatio(
            aspectRatio: 16 / 10, // 비율 설정
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.network(
                widget.review['imgPath'], // 이미지 URL
                fit: BoxFit.cover, // 이미지를 박스 크기에 맞게 조정
              ),
            ),
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
              alignment: Alignment.centerLeft,
              child: Text(
                formatDate(widget.review['createdAt']),
                style: const CustomTextStyles()
                    .overline
                    .copyWith(color: CustomColors.monotoneBlack),
              )),
          Container(
              margin: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
              alignment: Alignment.centerLeft,
              child: Text(
                widget.review['content'],
                style: const CustomTextStyles()
                    .body1
                    .copyWith(color: CustomColors.monotoneBlack),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: _isLike
                    ? () {
                        dislikeDetailReview(widget.review['reviewIdx']);
                      }
                    : () {
                        likeDetailReview(widget.review['reviewIdx']);
                      },
                child: Container(
                  height: 40,
                  child: Row(
                    children: [
                      Icon(
                        _isLike ? Icons.thumb_up : Icons.thumb_up_outlined,
                        size: 16,
                        color: _isLike
                            ? CustomColors.redPrimary
                            : CustomColors.monotoneBlack,
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
                        child: Text(
                          widget.review['likeCnt'].toString(),
                          style: const CustomTextStyles()
                              .button
                              .copyWith(color: CustomColors.monotoneBlack),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // GestureDetector(
              //   onTap: () => widget.panelController.open(),
              //   child: Container(
              //     margin: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
              //     height: 40,
              //     color: widget.highlight
              //         ? CustomColors.redLight
              //         : CustomColors.monotoneLight,
              //     child: Row(
              //       children: [
              //         const Icon(
              //           Icons.mode_comment_outlined,
              //           size: 16,
              //         ),
              //         Container(
              //           margin: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
              //           child: Text(
              //             "32",
              //             style: const CustomTextStyles()
              //                 .button
              //                 .copyWith(color: CustomColors.monotoneBlack),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
