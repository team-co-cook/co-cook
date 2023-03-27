import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:co_cook/services/search_service.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

import 'package:co_cook/widgets/card/list_card.dart';
import 'package:co_cook/widgets/text_field/custom_text_field.dart';
import 'package:co_cook/widgets/button/button.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? _searchWord;
  final _focusNode = FocusNode(); // 포커싱 여부를 추적하는 클래스 인스턴스

  List dataList = [];
  List exampleWord = ['두부', '마늘', '김치찌개', '치킨마요덮밥'];

  Future<void> getSearchData(String keyword) async {
    if (keyword == '') {
      return;
    }

    // API 요청
    SearchService searchService = SearchService();
    Response? response = await searchService.getSearchList(keyword: keyword);
    if (response?.statusCode == 200) {
      Map? decodeRes = await jsonDecode(response.toString());
      if (decodeRes != null) {
        setState(() {
          dataList = decodeRes["data"]["recipeListResDto"];
        });
      }
    }
  }

  // 위젯이 소멸될 때 호출되는 메서드
  @override
  void dispose() {
    _focusNode.dispose(); // 현재 위젯에서 포커스 해제
    super.dispose();
  }

  // 키보드 외 화면을 눌렀을 때, 포커스 해제
  void _dismissKeyboard(BuildContext context) {
    final currentFocus = FocusScope.of(context); // 현재 포커싱된 위젯을 반환
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      // 현재 포커싱된 위젯이 최상위 FocusScope가 아니면서, 포커싱이 존재한다면.
      currentFocus.focusedChild?.unfocus(); // 현재 포커싱된 자식 위젯의 포커싱을 해제
    }
  }

  void _clickSearch(String word) {
    setState(() {
      _searchWord = word;
    });
    getSearchData(word);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _dismissKeyboard(context),
      child: Scaffold(
        backgroundColor: CustomColors.redLight,
        appBar: AppBar(
          backgroundColor: CustomColors.monotoneLight,
          elevation: 0.5,
          toolbarHeight: 100,
          title: Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
              child: CustomTextField(
                onChanged: onWordChanged,
                isFocus: false,
                isSearch: true,
                onSubmitted: (value) {
                  getSearchData(value);
                },
              )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      // CameraScreen으로 이동
                    },
                    child: Image.asset(
                      'assets/images/button_img/CameraSearchLargeX2.png',
                    ),
                  ),
                  if (dataList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('${dataList.length}건의 요리를 찾았어요',
                          style: CustomTextStyles()
                              .caption
                              .copyWith(color: CustomColors.monotoneBlack)),
                    ),
                  dataList.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: dataList.length,
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 24.0),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: ListCard(data: dataList[index]),
                            );
                          })
                      : Container(
                          child: Column(
                            children: [
                              SizedBox(height: 100),
                              Text('이렇게 검색해보세요.',
                                  style: CustomTextStyles().body1.copyWith(
                                        color: CustomColors.monotoneGray,
                                      )),
                              SizedBox(height: 16.0),
                              Column(
                                children: exampleWord
                                    .map((e) => CommonButton(
                                        label: e,
                                        color: ButtonType.none,
                                        onPressed: () {
                                          _clickSearch(e);
                                        }))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 커스텀 텍스트 필드에 내려주기 위한 onChange-setState 함수
  void onWordChanged(String value) {
    setState(() {
      _searchWord = value;
    });
  }
}
