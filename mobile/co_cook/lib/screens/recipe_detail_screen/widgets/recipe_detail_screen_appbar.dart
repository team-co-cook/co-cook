import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:co_cook/widgets/button/bookmark_button.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class RecipeDetailScreenAppBar extends StatelessWidget {
  const RecipeDetailScreenAppBar(
      {super.key,
      required double scrollControllerOffset,
      required this.maxAppBarHeight,
      required this.minAppBarHeight})
      : _scrollControllerOffset = scrollControllerOffset;

  final double _scrollControllerOffset;
  final double maxAppBarHeight;
  final double minAppBarHeight;

  @override
  Widget build(BuildContext context) {
    double safePadding = MediaQuery.of(context).padding.top;
    double _maxSafeAppBarHeight = safePadding + maxAppBarHeight;
    double _minSafeAppBarHeight = safePadding + minAppBarHeight;

    return Container(
      width: double.infinity,
      height: _scrollControllerOffset > 0
          ? _maxSafeAppBarHeight - _scrollControllerOffset <=
                  _minSafeAppBarHeight
              ? _minSafeAppBarHeight
              : _maxSafeAppBarHeight - _scrollControllerOffset
          : _maxSafeAppBarHeight + _scrollControllerOffset.abs(),
      color: CustomColors.monotoneLight,
      child: Stack(
        children: [
          Opacity(
            opacity: 1 -
                (_scrollControllerOffset /
                        (_maxSafeAppBarHeight - _minSafeAppBarHeight))
                    .clamp(0, 1)
                    .toDouble(),
            child: Column(
              children: [
                Expanded(
                  child: Stack(children: [
                    FadeInImage.memoryNetwork(
                        width: double.infinity,
                        fadeInDuration: const Duration(milliseconds: 200),
                        fit: BoxFit.cover,
                        placeholder: kTransparentImage,
                        image: "https://picsum.photos/200/300"),
                    Positioned(
                      left: 24.0,
                      bottom: 24.0,
                      child: Text("부대찌개",
                          style: CustomTextStyles().title2.copyWith(
                                color: CustomColors.monotoneLight,
                              )),
                    ),
                  ]),
                ),
                Container(
                  width: double.infinity,
                  height: 64,
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  color: CustomColors.monotoneLight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.stacked_line_chart,
                                size: 12,
                                color: CustomColors.monotoneBlack,
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(
                                    4.0, 0.0, 0.0, 0.0),
                                child: Text(
                                  "난이도",
                                  style: const CustomTextStyles()
                                      .caption
                                      .copyWith(
                                          color: CustomColors.monotoneBlack),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.schedule,
                                size: 12,
                                color: CustomColors.monotoneBlack,
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(
                                    4.0, 0.0, 0.0, 0.0),
                                child: Text(
                                  "50분",
                                  style: const CustomTextStyles()
                                      .caption
                                      .copyWith(
                                          color: CustomColors.monotoneBlack),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      BookmarkButton(isAdd: false)
                    ],
                  ),
                )
              ],
            ),
          ),
          Opacity(
            opacity: ((_scrollControllerOffset - safePadding) /
                    (_maxSafeAppBarHeight - _minSafeAppBarHeight))
                .clamp(0, 1)
                .toDouble(),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.bottomCenter,
              child: Container(
                  width: double.infinity,
                  height: minAppBarHeight,
                  alignment: Alignment.center,
                  child: Text("부대찌개",
                      style: CustomTextStyles().subtitle1.copyWith(
                            color: CustomColors.monotoneBlack,
                          ))),
            ),
          ),
          Opacity(
              opacity: 1 -
                  (_scrollControllerOffset /
                          (_maxSafeAppBarHeight - _minSafeAppBarHeight))
                      .clamp(0, 1)
                      .toDouble(),
              child: Container(
                  height: minAppBarHeight,
                  margin: EdgeInsets.only(top: safePadding),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: CustomColors.monotoneLight),
                    onPressed: () => Navigator.pop(context),
                  ))),
          Opacity(
              opacity: (_scrollControllerOffset /
                      (_maxSafeAppBarHeight - _minSafeAppBarHeight))
                  .clamp(0, 1)
                  .toDouble(),
              child: Container(
                  height: minAppBarHeight,
                  margin: EdgeInsets.only(top: safePadding),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: CustomColors.monotoneBlack,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ))),
        ],
      ),
    );
  }
}
