import 'package:co_cook/screens/recipe_detail_screen/recipe_detail_screen.dart';
import 'package:flutter/material.dart';

import 'package:transparent_image/transparent_image.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:co_cook/widgets/button/bookmark_button.dart';

import 'package:co_cook/utils/bookmark.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

// 상위 위젯에서 그리드 사용시
//
// GridView.builder(
//   shrinkWrap: true,
//   itemCount: 2,
//   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//     crossAxisCount: 2, // 2개의 열
//     crossAxisSpacing: 16.0, // 열 간격
//     mainAxisSpacing: 16.0, // 행 간격
//     childAspectRatio: 0.7, // 아이템의 가로 세로 비율
//   ),
//   itemBuilder: (BuildContext context, int index) {
//     return RecipeCardTile(cardData: {index: 1});
//   },
// )

class GridCard extends StatefulWidget {
  const GridCard({super.key, required this.data});
  final Map data; // 카드 데이터

  @override
  State<GridCard> createState() => _GridCardState();
}

class _GridCardState extends State<GridCard> {
  @override
  void initState() {
    super.initState();
    setState(() {
      isAdd = widget.data["isFavorite"] ?? false;
    });
  }

  late bool isAdd;

  void toggleIsAdd() {
    setState(() {
      isAdd = !isAdd;
    });
  }

  void routeScreen(BuildContext context, Widget screen) {
    Route targetScreen = MaterialPageRoute(builder: (context) => screen);
    Navigator.push(context, targetScreen);
  }

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      end: 0.98,
      onTap: () => routeScreen(context, RecipeDetailScreen()),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Stack(children: [
                  Container(
                    width: constraints.maxWidth, // 부모 요소의 너비를 가져옴
                    height: constraints.maxWidth, // 부모 요소의 너비와 같은 값으로 설정
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(1, 1),
                          blurRadius: 6.0,
                          spreadRadius: 0.0,
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: FadeInImage.memoryNetwork(
                          fadeInDuration: const Duration(milliseconds: 200),
                          fit: BoxFit.cover,
                          placeholder: kTransparentImage,
                          image: widget.data["recipeImgPath"]),
                    ),
                  ),
                  Positioned(
                      right: 16,
                      child: GestureDetector(
                        onTap: () => toggleBookmark(
                            context,
                            isAdd,
                            toggleIsAdd,
                            widget.data["recipeIdx"],
                            widget.data["recipeName"]),
                        child: BookmarkButton(isAdd: isAdd),
                      )),
                ]);
              },
            ),
            Container(
              width: double.infinity,
              height: 40,
              alignment: Alignment.centerLeft,
              child: Text(
                widget.data["recipeName"],
                overflow: TextOverflow.ellipsis,
                style: const CustomTextStyles()
                    .title2
                    .copyWith(color: CustomColors.monotoneBlack),
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.stacked_line_chart,
                  size: 12,
                  color: CustomColors.monotoneBlack,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
                  child: Text(
                    widget.data["recipeDifficulty"],
                    style: const CustomTextStyles()
                        .caption
                        .copyWith(color: CustomColors.monotoneBlack),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                  child: const Icon(
                    Icons.schedule,
                    size: 12,
                    color: CustomColors.monotoneBlack,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
                  child: Text(
                    "${widget.data["recipeRunningTime"].toString()}분",
                    style: const CustomTextStyles()
                        .caption
                        .copyWith(color: CustomColors.monotoneBlack),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
