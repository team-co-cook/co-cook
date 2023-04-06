import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:co_cook/services/detail_service.dart';
import 'package:co_cook/services/auth_service.dart';
import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:co_cook/screens/my_review_screen/widgets/my_review.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MyReviewScreen extends StatefulWidget {
  const MyReviewScreen({Key? key}) : super(key: key);

  @override
  State<MyReviewScreen> createState() => _MyReviewScreenState();
}

class _MyReviewScreenState extends State<MyReviewScreen> {
  final PanelController _panelController =
      PanelController(); // 새 PanelController 추가
  List listData = [];

  @override
  void initState() {
    super.initState();
    getMyReview();
  }

  Future<void> getMyReview() async {
    // API 요청
    AuthService authService = AuthService();
    Response? response = await authService.getMyReview();
    if (response?.statusCode == 200) {
      if (response?.data['data'] != null) {
        setState(() {
          listData = response!.data['data'];
        });
      }
    }
  }

  void reGet() {
    getMyReview();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: CustomColors.monotoneLight,
          elevation: 0.5,
          title: const SizedBox.shrink(),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_back,
                      color: CustomColors.monotoneBlack,
                    ),
                  ),
                ),
                Text(
                  '내가 작성한 한줄평',
                  style: const CustomTextStyles()
                      .subtitle1
                      .copyWith(color: CustomColors.monotoneBlack),
                ),
                SizedBox(width: 48),
              ],
            ),
          ),
        ),
        body: listData.isNotEmpty
            ? Container(
                color: CustomColors.monotoneLight,
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 24.0),
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: listData.length,
                  itemBuilder: (context, index) => RecipeComment(
                      panelController: _panelController,
                      review: listData[index],
                      reGet: reGet),
                ),
              )
            : Container());
  }
}
