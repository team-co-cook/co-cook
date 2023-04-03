import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:co_cook/services/detail_service.dart';
import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

class RecipeDetailInfoTab extends StatefulWidget {
  const RecipeDetailInfoTab({super.key, required this.recipeIdx});
  final int recipeIdx;

  @override
  State<RecipeDetailInfoTab> createState() => _RecipeDetailInfoTabState();
}

class _RecipeDetailInfoTabState extends State<RecipeDetailInfoTab> {
  Map data = {};

  @override
  void initState() {
    super.initState();
    getDetailInfo(widget.recipeIdx);
  }

  Future<void> getDetailInfo(int recipeIdx) async {
    // API 요청
    DetailService searchService = DetailService();
    Response? response =
        await searchService.getDetailInfo(recipeIdx: recipeIdx);
    if (response?.statusCode == 200) {
      if (response?.data != null) {
        setState(() {
          data = response!.data['data'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return data.isEmpty
        ? Center(
            child: CircularProgressIndicator(color: CustomColors.redPrimary))
        : Container(
            margin: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: CustomColors.monotoneLight,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          child: Text("재료",
                              style: CustomTextStyles().subtitle1.copyWith(
                                    color: CustomColors.monotoneBlack,
                                  )),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 24),
                            child: DataTable(
                              headingRowHeight: 32,
                              dataRowHeight: 32,
                              showBottomBorder: true,
                              dividerThickness: 2.0,
                              columns: <DataColumn>[
                                DataColumn(
                                    label: Expanded(
                                        child: Text("재료명",
                                            textAlign: TextAlign.left,
                                            style: CustomTextStyles()
                                                .caption
                                                .copyWith(
                                                  color:
                                                      CustomColors.monotoneGray,
                                                )))),
                                DataColumn(
                                    label: Expanded(
                                        child: Text("용량",
                                            textAlign: TextAlign.right,
                                            style: CustomTextStyles()
                                                .caption
                                                .copyWith(
                                                  color:
                                                      CustomColors.monotoneGray,
                                                ))))
                              ],
                              rows: (data['ingredients'] ?? [])
                                  .map<DataRow>((ingredient) {
                                return DataRow(cells: [
                                  DataCell(Container(
                                      width: double.infinity,
                                      child: Text(ingredient['ingredientName'],
                                          style: CustomTextStyles()
                                              .subtitle2
                                              .copyWith(
                                                color:
                                                    CustomColors.monotoneBlack,
                                              )))),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      width: double.infinity,
                                      child: Text(ingredient['amount'],
                                          style: CustomTextStyles()
                                              .subtitle2
                                              .copyWith(
                                                color:
                                                    CustomColors.monotoneGray,
                                              )))),
                                ]);
                              }).toList(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("영양정보",
                              style: CustomTextStyles().subtitle1.copyWith(
                                    color: CustomColors.monotoneBlack,
                                  )),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text("1인분(200g) 기준",
                                style: CustomTextStyles().subtitle2.copyWith(
                                      color: CustomColors.monotoneGray,
                                    )),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RecipeDetailInfoCard(
                                title: '열량', value: '${data['calorie']}Kcal'),
                            RecipeDetailInfoCard(
                                title: '탄수화물', value: '${data['carb']}g'),
                            RecipeDetailInfoCard(
                                title: '단백질', value: '${data['protein']}g'),
                            RecipeDetailInfoCard(
                                title: '지방', value: '${data['fat']}g'),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}

class RecipeDetailInfoCard extends StatelessWidget {
  final String title;
  final String value;

  const RecipeDetailInfoCard({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 24, bottom: 24),
      width: (MediaQuery.of(context).size.width - 48) / 4 - 8,
      height: 80,
      decoration: BoxDecoration(
          color: CustomColors.monotoneLight,
          borderRadius: BorderRadius.circular(16.0)),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title,
            textAlign: TextAlign.right,
            style: CustomTextStyles().caption.copyWith(
                  color: CustomColors.monotoneGray,
                )),
        Text(value,
            style: CustomTextStyles().body2.copyWith(
                  color: CustomColors.monotoneBlack,
                ))
      ]),
    );
  }
}
