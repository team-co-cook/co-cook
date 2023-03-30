import 'package:flutter/material.dart';
import 'dart:convert'; // decode 가져오기
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:co_cook/services/detail_service.dart';

class RecipeComment extends StatefulWidget {
  const RecipeComment(
      {super.key,
      required this.review,
      required this.panelController,
      this.reGet});
  final Map review;
  final panelController;
  final reGet;

  @override
  State<RecipeComment> createState() => _RecipeCommentState();
}

class _RecipeCommentState extends State<RecipeComment> {
  bool _myComment = false;

  @override
  void initState() {
    super.initState();
    getUserIdx();
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
        widget.reGet();
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
          widget.reGet();
        });
      }
    }
  }

  Future<void> deleteReview(int reviewIdx) async {
    // API 요청
    DetailService searchService = DetailService();
    Response? response = await searchService.deleteReview(reviewIdx: reviewIdx);
    if (response?.statusCode == 200) {
      if (response != null) {
        setState(() {
          widget.reGet();
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
              Theme(
                data: ThemeData(
                  splashFactory: NoSplash.splashFactory, // 스플래시 효과를 제거합니다.
                  highlightColor: Colors.transparent, // 하이라이트 효과를 제거합니다.
                ),
                child: PopupMenuButton<int>(
                  itemBuilder: (BuildContext context) => [
                    if (_myComment)
                      PopupMenuItem<int>(
                        value: 1,
                        child: Text("삭제"),
                      ),
                    PopupMenuItem<int>(
                      value: 2,
                      child: Text("신고"),
                    ),
                  ],
                  onSelected: (int value) {
                    switch (value) {
                      case 1:
                        print("삭제 버튼을 클릭했습니다.");
                        deleteReview(widget.review['reviewIdx']);
                        break;
                      case 2:
                        print("신고 버튼을 클릭했습니다.");
                        break;
                    }
                  },
                  icon: const Icon(Icons.more_horiz,
                      color: CustomColors.monotoneBlack),
                ),
              )
            ],
          ),
          AspectRatio(
            aspectRatio: 16 / 10, // 비율 설정
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: FadeInImage.memoryNetwork(
                  fadeInDuration: const Duration(milliseconds: 200),
                  fit: BoxFit.cover,
                  placeholder: kTransparentImage,
                  image: widget.review['imgPath']),
            ),
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
              alignment: Alignment.centerLeft,
              child: widget.review['createdAt'] == null
                  ? Text('알수없음')
                  : Text(
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
                onTap: widget.review['liked']
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
                        widget.review['liked']
                            ? Icons.thumb_up
                            : Icons.thumb_up_outlined,
                        size: 16,
                        color: widget.review['liked']
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
