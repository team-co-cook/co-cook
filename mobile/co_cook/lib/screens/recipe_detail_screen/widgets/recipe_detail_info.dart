import 'package:flutter/material.dart';
import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

class RecipeDetailInfoTab extends StatelessWidget {
  const RecipeDetailInfoTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                                            color: CustomColors.monotoneGray,
                                          )))),
                          DataColumn(
                              label: Expanded(
                                  child: Text("용량",
                                      textAlign: TextAlign.right,
                                      style: CustomTextStyles()
                                          .caption
                                          .copyWith(
                                            color: CustomColors.monotoneGray,
                                          ))))
                        ],
                        rows: [
                          DataRow(cells: [
                            DataCell(Container(
                                width: double.infinity,
                                child: Text("대파",
                                    style:
                                        CustomTextStyles().subtitle2.copyWith(
                                              color: CustomColors.monotoneBlack,
                                            )))),
                            DataCell(Container(
                                alignment: Alignment.centerRight,
                                width: double.infinity,
                                child: Text("2",
                                    style:
                                        CustomTextStyles().subtitle2.copyWith(
                                              color: CustomColors.monotoneGray,
                                            )))),
                          ]),
                        ],
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
                      RecipeDetailInfoCard(),
                      RecipeDetailInfoCard(),
                      RecipeDetailInfoCard(),
                      RecipeDetailInfoCard(),
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
  const RecipeDetailInfoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 24, bottom: 24),
      width: (MediaQuery.sizeOf(context).width - 48) / 4 - 8,
      height: 80,
      decoration: BoxDecoration(
          color: CustomColors.monotoneLight,
          borderRadius: BorderRadius.circular(16.0)),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text("열량",
            textAlign: TextAlign.right,
            style: CustomTextStyles().caption.copyWith(
                  color: CustomColors.monotoneGray,
                )),
        Text("320Kcal",
            style: CustomTextStyles().body2.copyWith(
                  color: CustomColors.monotoneBlack,
                ))
      ]),
    );
  }
}
