import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:co_cook/widgets/button/toggle_button.dart';
import 'package:co_cook/widgets/card/list_card.dart';

import 'package:co_cook/services/list_service.dart';
import 'package:co_cook/services/auth_service.dart';

class IngredientListScreen extends StatefulWidget {
  const IngredientListScreen({super.key, required this.ingredients});
  final List ingredients;

  @override
  State<IngredientListScreen> createState() => _IngredientListScreenState();
}

class _IngredientListScreenState extends State<IngredientListScreen> {
  List dataList = [];
  late Map<String, bool> ingredientIsToggle;

  @override
  void initState() {
    super.initState();

    ingredientIsToggle = {}; // 이 부분을 추가하여 초기화를 진행합니다.

    for (String ingredient in widget.ingredients) {
      ingredientIsToggle[ingredient] = true; // 초기값으로 모든 재료를 true로 설정
    }

    getListData();
  }

  Future<void> getListData() async {
    List<String> selectedIngredients = ingredientIsToggle.keys
        .where((ingredient) =>
            ingredientIsToggle[ingredient] ??
            false) // 값이 true인 항목만 선택, 값이 null이면 false로 처리
        .toList();

    // 선택된 재료를 콤마로 구분된 스트링으로 변환
    String selectedIngredientsString = selectedIngredients.join(',');

    // API 요청
    ListService apiService = ListService();
    Response? response = await apiService.getIngredientList(
        ingredients: selectedIngredientsString);
    if (response?.statusCode == 200) {
      if (response?.data['data'] != null) {
        setState(() {
          dataList = response!.data['data'];
        });
      }
    }
  }

  // 재료 버튼 생성
  Widget _buildIngredientButtons() {
    return SingleChildScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 48.0), // 최소 높이 설정
        child: Row(
          mainAxisSize: MainAxisSize.min, // Row의 mainAxisSize 설정
          mainAxisAlignment: MainAxisAlignment.start,
          children: widget.ingredients.map((ingredient) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 8),
              child: ButtonToggle(
                  label: ingredient,
                  isToggleOn: ingredientIsToggle[ingredient] == true,
                  onPressed: () {
                    setState(() {
                      ingredientIsToggle[ingredient] =
                          !ingredientIsToggle[ingredient]!;
                      getListData();
                    });
                  }),
            );
          }).toList(),
        ),
      ),
    );
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
                '재료 찾기',
                style: const CustomTextStyles()
                    .subtitle1
                    .copyWith(color: CustomColors.monotoneBlack),
              ),
              SizedBox(width: 48),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildIngredientButtons(),
            Expanded(
              child: dataList.isNotEmpty
                  ? ListView.custom(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      childrenDelegate: SliverChildListDelegate(
                        [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 16, 0, 24),
                              child: Text('${dataList.length}건의 요리를 찾았어요',
                                  style: CustomTextStyles().caption.copyWith(
                                      color: CustomColors.monotoneBlack)),
                            ),
                          ),
                          ...dataList
                              .map<Widget>((data) => Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    child: ListCard(data: data),
                                  ))
                              .toList(),
                        ],
                      ),
                    )
                  : Center(
                      child: Text('이런, 검색 결과가 없습니다!',
                          style: CustomTextStyles()
                              .subtitle2
                              .copyWith(color: CustomColors.monotoneGray)),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
