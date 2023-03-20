import 'package:flutter/material.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:co_cook/widgets/button/bookmark_button.dart';

import 'package:co_cook/utils/bookmark.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:co_cook/screens/recipe_detail_screen/recipe_detail_screen.dart';

class ListCard extends StatefulWidget {
  const ListCard({
    super.key,
    required this.data,
    this.showImage = true,
  });
  final Map data; // 데이터 담겨올 변수
  final bool showImage; // 이미지, 북마크 표시여부, 기본값 = true

  @override
  State<ListCard> createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  void initState() {
    super.initState();
    setState(() {
      isAdd = widget.data["isFavorite"];
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
      onTap: () => routeScreen(context, RecipeDetailScreen()), // 클릭시 이벤트 연결
      child: Container(
          // 전체 컨테이너
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: CustomColors.monotoneLight,
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(8, 0, 0, 0),
                offset: Offset(1, 1),
                blurRadius: 6.0,
                spreadRadius: 0.0,
              )
            ],
          ),
          width: double.infinity, // 부모 요소의 너비를 가져옴
          height: 120,
          child: Row(
            children: [
              widget.showImage
                  ? LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return Container(
                          width: constraints.maxHeight, // 부모 요소의 너비를 가져옴
                          height: constraints.maxHeight, // 부모 요소의 너비와 같은 값으로 설정
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  bottomLeft: Radius.circular(16.0)),
                              color: Colors.white),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16.0),
                                bottomLeft: Radius.circular(16.0)),
                            child: FadeInImage.memoryNetwork(
                                fadeInDuration:
                                    const Duration(milliseconds: 200),
                                fit: BoxFit.cover,
                                placeholder: kTransparentImage,
                                image: widget.data["recipeImgPath"]),
                          ),
                        );
                      },
                    )
                  : Container(),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                              alignment: Alignment.bottomLeft,
                              height: 48,
                              child: Text(
                                widget.data["recipeName"], // 카드 타일의 제목
                                overflow: TextOverflow.ellipsis,
                                style: const CustomTextStyles().title2.copyWith(
                                    color: CustomColors.monotoneBlack),
                              ),
                            ),
                          ),
                          widget.showImage
                              ? GestureDetector(
                                  onTap: () => toggleBookmark(
                                      context,
                                      isAdd,
                                      toggleIsAdd,
                                      widget.data["recipeIdx"],
                                      widget.data["recipeName"]),
                                  child: BookmarkButton(isAdd: isAdd))
                              : Container()
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.stacked_line_chart,
                            size: 12,
                            color: CustomColors.monotoneBlack,
                          ),
                          Container(
                            margin:
                                const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
                            child: Text(
                              widget.data["recipeDifficulty"],
                              style: const CustomTextStyles()
                                  .caption
                                  .copyWith(color: CustomColors.monotoneBlack),
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
                            margin:
                                const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
                            child: Text(
                              "${widget.data["recipeRunningTime"].toString()}분",
                              style: const CustomTextStyles()
                                  .caption
                                  .copyWith(color: CustomColors.monotoneBlack),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
