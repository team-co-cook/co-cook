import 'package:flutter/material.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

class CategoryRecommend extends StatelessWidget {
  const CategoryRecommend({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map> dataList = [
      {
        "id": 0,
        "categoryName": "메인 요리",
        "imgPath": "https://picsum.photos/200/300"
      },
      {
        "id": 1,
        "categoryName": "밑반찬",
        "imgPath": "https://picsum.photos/200/300"
      },
      {
        "id": 2,
        "categoryName": "간식",
        "imgPath": "https://picsum.photos/200/300"
      }
    ];

    return Container(
      margin: EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CategoryRecommendCard(data: dataList[0], onTap: () => print("0")),
          CategoryRecommendCard(data: dataList[1], onTap: () => print("1")),
          CategoryRecommendCard(data: dataList[2], onTap: () => print("2"))
        ],
      ),
    );
  }
}

class CategoryRecommendCard extends StatelessWidget {
  const CategoryRecommendCard({
    super.key,
    required this.data,
    required this.onTap,
  });
  final Map data;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onTap,
        child: Stack(children: [
          Container(
            width: ((MediaQuery.of(context).size.width - 48) / 3 - 8),
            height: 128,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(data["imgPath"]),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(1, 1),
                  blurRadius: 6.0,
                  spreadRadius: 0.0,
                )
              ],
            ),
          ),
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                  child: Text(data["categoryName"],
                      style: CustomTextStyles().subtitle1.copyWith(
                          color: CustomColors.monotoneLight,
                          shadows: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(1, 1),
                              blurRadius: 6.0,
                              spreadRadius: 0.0,
                            )
                          ])))),
        ]));
  }
}
