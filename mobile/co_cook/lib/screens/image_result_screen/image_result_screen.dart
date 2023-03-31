import 'package:co_cook/screens/camera_screen/camera_screen.dart';
import 'package:co_cook/utils/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:co_cook/services/search_service.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

import 'package:co_cook/widgets/card/list_card.dart';
import 'package:co_cook/widgets/text_field/custom_text_field.dart';
import 'package:co_cook/widgets/button/button.dart';

class ImageResultScreen extends StatefulWidget {
  const ImageResultScreen({super.key, required this.searchWord});
  final String searchWord;

  @override
  State<ImageResultScreen> createState() => _ImageResultScreenState();
}

class _ImageResultScreenState extends State<ImageResultScreen> {
  List dataList = [];

  @override
  void initState() {
    super.initState();
    getSearchData();
  }

  Future<void> getSearchData() async {
    // API 요청
    SearchService searchService = SearchService();
    Response? response =
        await searchService.getSearchList(keyword: widget.searchWord);
    if (response?.statusCode == 200) {
      if (response!.data['data'] != null) {
        print(response.data['data']["recipeListResDto"]);
        setState(() {
          dataList = response.data['data']["recipeListResDto"];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.redLight,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: CustomColors.monotoneLight,
        elevation: 0.5,
        title: const SizedBox.shrink(), // Remove the original title
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
                '${widget.searchWord} 검색 결과',
                style: const CustomTextStyles()
                    .subtitle1
                    .copyWith(color: CustomColors.monotoneBlack),
              ),
              SizedBox(width: 48), // Add space to balance the back button width
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  if (dataList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 28, 16, 28),
                      child: Center(
                        child: Text('${dataList.length}건의 요리를 찾았어요',
                            style: CustomTextStyles()
                                .caption
                                .copyWith(color: CustomColors.monotoneBlack)),
                      ),
                    )
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListCard(data: dataList[index]),
                  );
                },
                childCount: dataList.isNotEmpty ? dataList.length : 0,
              ),
            ),
            if (dataList.isEmpty)
              SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text('검색 결과가 존재하지 않습니다.',
                        style: CustomTextStyles().body1.copyWith(
                              color: CustomColors.monotoneGray,
                            )),
                  )),
          ],
        ),
      ),
    );
  }
}
