import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:co_cook/services/recommend_service.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

import 'package:co_cook/widgets/button/toggle_button.dart';
import 'package:co_cook/widgets/card/list_card.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key, required this.listName, required this.imgPath});
  final listName;
  final imgPath;

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  void initState() {
    super.initState();
    getTimeRecommendData("/home/random");
  }

  List dataList = [];

  Future<void> getTimeRecommendData(String apiPath) async {
    // API 요청
    RecommendService recommendService = RecommendService();
    Response? response = await recommendService.getCardData(apiPath);
    if (response?.statusCode == 200) {
      Map? decodeRes = await jsonDecode(response.toString());
      if (decodeRes != null) {
        setState(() {
          dataList = decodeRes["data"]["recipes"];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColors.monotoneLight,
          elevation: 0,
          toolbarHeight: 120,
          automaticallyImplyLeading: false,
          flexibleSpace: Stack(
            children: [
              FlexibleSpaceBar(
                background: Image.network(
                  widget.imgPath,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top,
                left: 0,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: CustomColors.monotoneLight),
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
                  style: CustomTextStyles()
                      .title1
                      .copyWith(color: CustomColors.monotoneLight),
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
                            child: Row(
                              children: [
                                SizedBox(width: 8),
                                ButtonToggle(
                                    label: '전체',
                                    isToggleOn: true,
                                    onPressed: () {}),
                                SizedBox(width: 8),
                                ButtonToggle(
                                    label: '쉬움',
                                    isToggleOn: false,
                                    onPressed: () {}),
                                SizedBox(width: 8),
                                ButtonToggle(
                                    label: '보통',
                                    isToggleOn: false,
                                    onPressed: () {}),
                                SizedBox(width: 8),
                                ButtonToggle(
                                    label: '어려움',
                                    isToggleOn: false,
                                    onPressed: () {}),
                                SizedBox(width: 8),
                              ],
                            ),
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
                            child: Row(
                              children: [
                                SizedBox(width: 8),
                                ButtonToggle(
                                    label: '전체',
                                    isToggleOn: true,
                                    onPressed: () {}),
                                SizedBox(width: 8),
                                ButtonToggle(
                                    label: '20분 이내',
                                    isToggleOn: false,
                                    onPressed: () {}),
                                SizedBox(width: 8),
                                ButtonToggle(
                                    label: '40분 이내',
                                    isToggleOn: false,
                                    onPressed: () {}),
                                SizedBox(width: 8),
                                ButtonToggle(
                                    label: '1시간 이내',
                                    isToggleOn: false,
                                    onPressed: () {}),
                                SizedBox(width: 8),
                              ],
                            ),
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
                  child: dataList.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: dataList.length,
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          padding: const EdgeInsets.all(16),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: ListCard(data: dataList[index]),
                            );
                          })
                      : const Center(
                          child: CircularProgressIndicator(
                              color: CustomColors.redPrimary)),
                ),
              ),
            ],
          ),
        ));
  }
}
