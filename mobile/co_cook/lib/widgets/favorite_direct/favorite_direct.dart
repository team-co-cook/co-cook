import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:co_cook/widgets/card/list_card.dart';

import 'package:co_cook/services/list_service.dart';

class FavoriteDirect extends StatefulWidget {
  const FavoriteDirect({super.key});

  @override
  State<FavoriteDirect> createState() => FavoriteDirectState();
}

class FavoriteDirectState extends State<FavoriteDirect> {
  List dataList = [];
  String _nickname = '';

  @override
  void initState() {
    super.initState();
    getDetailInfo();
    _fetchNickname();
  }

  Future<void> getDetailInfo() async {
    // API 요청
    ListService searchService = ListService();
    Response? response = await searchService.getFavoriteList();
    if (response?.statusCode == 200) {
      Map? decodeRes = await jsonDecode(response.toString());
      if (decodeRes != null) {
        setState(() {
          dataList = decodeRes["data"]['recipeListResDto'];
        });
      }
    }
  }

  // 닉네임 가져오기
  Future<void> _fetchNickname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String prefsUserData =
        prefs.getString('userData') ?? ''; // 기본값으로 빈 문자열을 사용합니다.
    Map<String, dynamic> decodePrefs = jsonDecode(prefsUserData);
    String? nickname = decodePrefs['nickname'];

    if (nickname != null) {
      setState(() {
        _nickname = nickname;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: CustomColors.monotoneLight,
        elevation: 0,
        toolbarHeight: 80, // AppBar의 높이를 조정합니다.
        flexibleSpace: FlexibleSpaceBar(
          background: Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '"$_nickname"님이 찜한 레시피',
                  style: const CustomTextStyles()
                      .subtitle1
                      .copyWith(color: CustomColors.monotoneBlack),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 16, 0, 16),
                  child: Image.asset(
                    'assets/images/logo/logo_ai.png',
                    width: 100,
                  ),
                ),
                Row(
                  children: [
                    Text('AI레시피 ',
                        style: CustomTextStyles()
                            .subtitle1
                            .copyWith(color: CustomColors.monotoneBlack)),
                    Text('바로 시작하기',
                        style: CustomTextStyles()
                            .title2
                            .copyWith(color: CustomColors.redPrimary))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: dataList.isNotEmpty
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16, // 상하 간격
                    crossAxisSpacing: 16, // 좌우 간격
                    childAspectRatio: 1.2, // 카드의 가로/세로 비율
                  ),
                  itemCount: dataList.length,
                  shrinkWrap: false,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (BuildContext context, int index) {
                    return ListCard(
                      data: dataList[index],
                      showImage: false,
                    );
                  })
              : const Center(
                  child: CircularProgressIndicator(
                      color: CustomColors.redPrimary)),
        ),
      ),
    );
  }
}
