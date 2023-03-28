import 'package:co_cook/styles/shadows.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:transparent_image/transparent_image.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

import 'package:co_cook/widgets/button/toggle_button.dart';
import 'package:co_cook/widgets/card/list_card.dart';

// 이전 화면에서 호출 api 작성해서 전달하기 위한 함수 타입 선언.
typedef Future<Response?> DataFetcher(
    {required String difficulty, required int time});

class ListScreen extends StatefulWidget {
  const ListScreen(
      {super.key,
      required this.listName,
      required this.imgPath,
      required this.dataFetcher});
  final listName;
  final imgPath;
  final DataFetcher dataFetcher;

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  String difficulty = '전체';
  int time = 0;

  @override
  void initState() {
    super.initState();
    getListData();
  }

  List? dataList;

  Future<void> getListData() async {
    Response? response =
        await widget.dataFetcher(difficulty: difficulty, time: time);
    if (response?.statusCode == 200) {
      Map? decodeRes = await jsonDecode(response.toString());
      if (decodeRes != null) {
        setState(() {
          dataList = decodeRes["data"]["recipeListResDto"];
        });
      }
    }
  }

  // 난이도와 조리시간에 대한 정보를 배열로 저장
  List<String> difficulties = ['전체', '쉬움', '보통', '어려움'];
  List<Map<String, dynamic>> cookingTimes = [
    {'label': '전체', 'value': 0},
    {'label': '20분 이내', 'value': 20},
    {'label': '40분 이내', 'value': 40},
    {'label': '1시간 이내', 'value': 60},
  ];

  // 난이도 버튼 생성
  Row _buildDifficultyButtons() {
    return Row(
      children: difficulties.map((diff) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ButtonToggle(
              label: diff,
              isToggleOn: difficulty == diff,
              onPressed: () {
                setState(() {
                  difficulty = diff;
                  getListData();
                });
              }),
        );
      }).toList(),
    );
  }

  // 시간 버튼 생성
  Row _buildCookingTimeButtons() {
    return Row(
      children: cookingTimes.map((time) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ButtonToggle(
              label: time['label'],
              isToggleOn: this.time == time['value'],
              onPressed: () {
                setState(() {
                  this.time = time['value'];
                  getListData();
                });
              }),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: CustomColors.monotoneLight,
          elevation: 0,
          toolbarHeight: 120,
          flexibleSpace: Stack(
            children: [
              FlexibleSpaceBar(
                background: FadeInImage.memoryNetwork(
                    fadeInDuration: const Duration(milliseconds: 200),
                    fit: BoxFit.cover,
                    placeholder: kTransparentImage,
                    image: widget.imgPath),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top,
                left: 0,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: CustomColors.monotoneLight,
                    shadows: [CustomShadows.text],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Positioned(
                left: 16,
                bottom: 16,
                child: Text(
                  widget.listName,
                  style: CustomTextStyles().title1.copyWith(
                    color: CustomColors.monotoneLight,
                    shadows: const [CustomShadows.text],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 0, 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: Text('난이도',
                              style: CustomTextStyles()
                                  .subtitle2
                                  .copyWith(color: CustomColors.redPrimary)),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            scrollDirection: Axis.horizontal,
                            child: _buildDifficultyButtons(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: Text('조리시간',
                              style: CustomTextStyles()
                                  .subtitle2
                                  .copyWith(color: CustomColors.redPrimary)),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            scrollDirection: Axis.horizontal,
                            child: _buildCookingTimeButtons(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: dataList == null || dataList!.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: dataList?.length ?? 5,
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            padding: const EdgeInsets.all(16),
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                child: ListCard(data: dataList?[index]),
                              );
                            })
                        : Container(
                            child: Center(
                              child: Text(
                                '해당하는 음식이 없어요',
                                style: CustomTextStyles().body1.copyWith(
                                    color: CustomColors.monotoneBlack),
                              ),
                            ),
                          )),
              ),
            ],
          ),
        ));
  }
}
