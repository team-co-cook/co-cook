import 'package:flutter/material.dart';

import 'package:co_cook/styles/colors.dart';

class BookmarkButton extends StatefulWidget {
  const BookmarkButton({super.key, required this.isAdd});
  final bool isAdd; // 북마크 추가여부

  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
            child: CustomPaint(
          size: Size(36, (36 * 1.2).toDouble()),
          painter: RPSCustomPainter(isAdd: widget.isAdd),
        )),
        Positioned(
            child: Container(
                child: widget.isAdd
                    ? const Icon(
                        Icons.star,
                        color: CustomColors.monotoneLight,
                      )
                    : const Icon(
                        Icons.add,
                        color: CustomColors.monotoneGray,
                      )))
      ],
    );
  }
}

// 배경 도형
class RPSCustomPainter extends CustomPainter {
  RPSCustomPainter({required this.isAdd});
  final bool isAdd;

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width, 0);
    path_0.lineTo(0, 0);
    path_0.lineTo(0, size.height * 0.7551028);
    path_0.lineTo(size.width * 0.5000000, size.height);
    path_0.lineTo(size.width, size.height * 0.7551028);
    path_0.lineTo(size.width, 0);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color =
        isAdd ? CustomColors.redPrimary : CustomColors.monotoneLightGray;
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
