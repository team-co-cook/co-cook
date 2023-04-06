import 'package:co_cook/styles/shadows.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/utils/bookmark.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:co_cook/widgets/button/bookmark_button.dart';
import 'package:co_cook/widgets/shimmer/custom_shimmer.dart';
import 'package:co_cook/screens/recipe_detail_screen/recipe_detail_screen.dart';

class GridCard extends StatefulWidget {
  const GridCard({super.key, this.data});
  final Map? data; // 카드 데이터

  @override
  State<GridCard> createState() => _GridCardState();
}

class _GridCardState extends State<GridCard> {
  @override
  void initState() {
    super.initState();
    setState(() {
      isAdd = widget.data != null ? widget.data!["isFavorite"] : false;
    });
  }

  @override
  void didUpdateWidget(GridCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      setState(() {
        isAdd = widget.data != null ? widget.data!["isFavorite"] : false;
      });
    }
  }

  late bool isAdd;

  void toggleIsAdd() {
    setState(() {
      isAdd = !isAdd;
      widget.data!["isFavorite"] = !widget.data!["isFavorite"];
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
      onTap: () => widget.data != null
          ? routeScreen(
              context, RecipeDetailScreen(recipeIdx: widget.data!['recipeIdx']))
          : null,
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
                      color: CustomColors.redLight,
                      boxShadow: const [CustomShadows.card],
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: widget.data != null
                            ? FadeInImage.memoryNetwork(
                                fadeInDuration:
                                    const Duration(milliseconds: 200),
                                fit: BoxFit.cover,
                                placeholder: kTransparentImage,
                                image: widget.data!["recipeImgPath"])
                            : const CustomShimmer()),
                  ),
                  widget.data != null
                      ? Positioned(
                          right: 16,
                          child: GestureDetector(
                            onTap: () => toggleBookmark(
                                context,
                                isAdd,
                                toggleIsAdd,
                                widget.data!["recipeIdx"],
                                widget.data!["recipeName"]),
                            child: BookmarkButton(isAdd: isAdd),
                          ))
                      : Container(),
                ]);
              },
            ),
            widget.data != null
                ? Container(
                    width: double.infinity,
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.data!["recipeName"],
                      overflow: TextOverflow.ellipsis,
                      style: const CustomTextStyles()
                          .title2
                          .copyWith(color: CustomColors.monotoneBlack),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: const CustomShimmer(
                      width: 160,
                      height: 20,
                    ),
                  ),
            widget.data != null
                ? Row(
                    children: [
                      const Icon(
                        Icons.stacked_line_chart,
                        size: 12,
                        color: CustomColors.monotoneBlack,
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
                        child: Text(
                          widget.data!["recipeDifficulty"],
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
                          "${widget.data!["recipeRunningTime"].toString()}분",
                          style: const CustomTextStyles()
                              .caption
                              .copyWith(color: CustomColors.monotoneBlack),
                        ),
                      )
                    ],
                  )
                : Container(
                    alignment: Alignment.centerLeft,
                    child: const CustomShimmer(
                      width: 90,
                      height: 20,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
