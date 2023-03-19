import 'package:flutter/material.dart';
import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

class RecipeComment extends StatefulWidget {
  const RecipeComment(
      {super.key,
      this.highlight = false,
      this.myComment = false,
      required this.panelController});
  final bool highlight;
  final bool myComment;
  final panelController;

  @override
  State<RecipeComment> createState() => _RecipeCommentState();
}

class _RecipeCommentState extends State<RecipeComment> {
  bool _isLike = false;

  void _toggleLike() {
    setState(() {
      _isLike = !_isLike;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color:
          widget.highlight ? CustomColors.redLight : CustomColors.monotoneLight,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.myComment ? "내 한줄평" : "data",
                style: const CustomTextStyles()
                    .subtitle1
                    .copyWith(color: CustomColors.monotoneBlack),
              ),
              GestureDetector(
                onTap: () => print("more"),
                child: Container(
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.more_horiz,
                        color: CustomColors.monotoneBlack)),
              ),
            ],
          ),
          Container(
            height: 168,
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(16.0)),
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
              alignment: Alignment.centerLeft,
              child: Text(
                "2023. 3. 13.",
                style: const CustomTextStyles()
                    .overline
                    .copyWith(color: CustomColors.monotoneBlack),
              )),
          Container(
              margin: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
              alignment: Alignment.centerLeft,
              child: Text(
                "댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용댓글내용",
                style: const CustomTextStyles()
                    .body1
                    .copyWith(color: CustomColors.monotoneBlack),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: _toggleLike,
                child: Container(
                  height: 40,
                  color: widget.highlight
                      ? CustomColors.redLight
                      : CustomColors.monotoneLight,
                  child: Row(
                    children: [
                      Icon(
                        _isLike ? Icons.thumb_up : Icons.thumb_up_outlined,
                        size: 16,
                        color: _isLike
                            ? CustomColors.redPrimary
                            : CustomColors.monotoneBlack,
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
                        child: Text(
                          "245",
                          style: const CustomTextStyles()
                              .button
                              .copyWith(color: CustomColors.monotoneBlack),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => widget.panelController.open(),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                  height: 40,
                  color: widget.highlight
                      ? CustomColors.redLight
                      : CustomColors.monotoneLight,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.mode_comment_outlined,
                        size: 16,
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
                        child: Text(
                          "32",
                          style: const CustomTextStyles()
                              .button
                              .copyWith(color: CustomColors.monotoneBlack),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
