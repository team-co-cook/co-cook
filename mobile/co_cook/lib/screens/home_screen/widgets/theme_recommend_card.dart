import 'package:flutter/material.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class ThemeRecommendCard extends StatelessWidget {
  const ThemeRecommendCard({
    super.key,
    required this.data,
  });
  final Map data;

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      end: 0.98,
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(1, 1),
                blurRadius: 6.0,
                spreadRadius: 0.0,
              )
            ],
          ),
          margin: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
          width: 120,
          height: 120,
          child: ClipOval(
            child: FadeInImage.memoryNetwork(
                fadeInDuration: const Duration(milliseconds: 200),
                fit: BoxFit.cover,
                placeholder: kTransparentImage,
                image: data["imgPath"]),
          ),
        ),
        Positioned(
            top: 28,
            left: 24,
            right: 24,
            child: Text(data["themeName"],
                style: const CustomTextStyles().subtitle1.copyWith(
                    color: CustomColors.monotoneLight,
                    shadows: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(1, 1),
                        blurRadius: 6.0,
                        spreadRadius: 0.0,
                      )
                    ])))
      ]),
    );
  }
}
