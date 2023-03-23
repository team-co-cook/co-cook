import 'package:co_cook/styles/shadows.dart';
import 'package:flutter/material.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

import 'package:dio/dio.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:co_cook/utils/bookmark.dart';
import 'package:co_cook/services/detail_service.dart';
import 'package:co_cook/widgets/button/bookmark_button.dart';

class RecipeDetailScreenAppBar extends StatefulWidget {
  const RecipeDetailScreenAppBar(
      {super.key,
      required this.recipeIdx,
      required double scrollControllerOffset,
      required this.maxAppBarHeight,
      required this.minAppBarHeight})
      : _scrollControllerOffset = scrollControllerOffset;

  final int recipeIdx;
  final double _scrollControllerOffset;
  final double maxAppBarHeight;
  final double minAppBarHeight;

  @override
  State<RecipeDetailScreenAppBar> createState() =>
      _RecipeDetailScreenAppBarState();
}

class _RecipeDetailScreenAppBarState extends State<RecipeDetailScreenAppBar> {
  Map data = {};

  @override
  void initState() {
    super.initState();
    getDetailBasic(widget.recipeIdx);
  }

  Future<void> getDetailBasic(int recipeIdx) async {
    // API 요청
    DetailService searchService = DetailService();
    Response? response =
        await searchService.getDetailBasic(recipeIdx: recipeIdx);
    if (response?.statusCode == 200) {
      if (response != null) {
        setState(() {
          data = response.data['data'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double safePadding = MediaQuery.of(context).padding.top;
    double _maxSafeAppBarHeight = safePadding + widget.maxAppBarHeight;
    double _minSafeAppBarHeight = safePadding + widget.minAppBarHeight;

    return data.isEmpty
        ? const Center(
            child: CircularProgressIndicator(color: CustomColors.redPrimary))
        : Container(
            width: double.infinity,
            height: widget._scrollControllerOffset > 0
                ? _maxSafeAppBarHeight - widget._scrollControllerOffset <=
                        _minSafeAppBarHeight
                    ? _minSafeAppBarHeight
                    : _maxSafeAppBarHeight - widget._scrollControllerOffset
                : _maxSafeAppBarHeight + widget._scrollControllerOffset.abs(),
            color: CustomColors.monotoneLight,
            child: Stack(
              children: [
                Opacity(
                  opacity: 1 -
                      (widget._scrollControllerOffset /
                              (_maxSafeAppBarHeight - _minSafeAppBarHeight))
                          .clamp(0, 1)
                          .toDouble(),
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(children: [
                          FadeInImage.memoryNetwork(
                              width: double.infinity,
                              height: double.infinity,
                              fadeInDuration: const Duration(milliseconds: 200),
                              fit: BoxFit.cover,
                              placeholder: kTransparentImage,
                              image: data['recipeImgPath']),
                          Positioned(
                            left: 24.0,
                            bottom: 24.0,
                            child: Text(data['recipeName'],
                                style: const CustomTextStyles().title2.copyWith(
                                  color: CustomColors.monotoneLight,
                                  shadows: const [CustomShadows.text],
                                )),
                          ),
                        ]),
                      ),
                      Container(
                        width: double.infinity,
                        height: 64,
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
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
                                        data['recipeDifficulty'],
                                        style: const CustomTextStyles()
                                            .caption
                                            .copyWith(
                                                color:
                                                    CustomColors.monotoneBlack),
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
                                        "${data['recipeRunningTime']}분",
                                        style: const CustomTextStyles()
                                            .caption
                                            .copyWith(
                                                color:
                                                    CustomColors.monotoneBlack),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => toggleBookmark(
                                  context, data['isFavorite'], () {
                                getDetailBasic(widget.recipeIdx);
                              }, widget.recipeIdx, data["recipeName"]),
                              child: BookmarkButton(isAdd: data['isFavorite']),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Opacity(
                  opacity: ((widget._scrollControllerOffset - safePadding) /
                          (_maxSafeAppBarHeight - _minSafeAppBarHeight))
                      .clamp(0, 1)
                      .toDouble(),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        width: double.infinity,
                        height: widget.minAppBarHeight,
                        alignment: Alignment.center,
                        child: Text("${data['recipeName']}",
                            style: CustomTextStyles().subtitle1.copyWith(
                                  color: CustomColors.monotoneBlack,
                                ))),
                  ),
                ),
                Opacity(
                    opacity: 1 -
                        (widget._scrollControllerOffset /
                                (_maxSafeAppBarHeight - _minSafeAppBarHeight))
                            .clamp(0, 1)
                            .toDouble(),
                    child: Container(
                        height: widget.minAppBarHeight,
                        margin: EdgeInsets.only(top: safePadding),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: CustomColors.monotoneLight,
                              shadows: [CustomShadows.text]),
                          onPressed: () => Navigator.pop(context),
                        ))),
                Opacity(
                    opacity: (widget._scrollControllerOffset /
                            (_maxSafeAppBarHeight - _minSafeAppBarHeight))
                        .clamp(0, 1)
                        .toDouble(),
                    child: Container(
                        height: widget.minAppBarHeight,
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
