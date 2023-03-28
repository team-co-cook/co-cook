import 'package:flutter/material.dart';
import 'dart:io';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

import 'package:co_cook/screens/photo_card_screen/photo_card_screen.dart';

class PhotoCard extends StatelessWidget {
  const PhotoCard({
    super.key,
    required this.widget,
    required this.cookingTimeString,
    required this.timeString,
  });

  final PhotoCardScreen widget;
  final String cookingTimeString;
  final String timeString;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(children: [
          Container(
            width: constraints.maxWidth * 0.9,
            decoration: BoxDecoration(
              color: CustomColors.monotoneLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(widget.image.path),
                          fit: BoxFit.cover,
                          width: constraints.maxWidth,
                          height: constraints.maxWidth,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        widget.recipeName,
                        style: CustomTextStyles()
                            .title1
                            .copyWith(color: CustomColors.monotoneBlack),
                      ),
                      SizedBox(height: 8),
                      Text(
                        cookingTimeString,
                        style: CustomTextStyles().caption.copyWith(
                            color: CustomColors.monotoneBlack, height: 1.5),
                      ),
                      Text(
                        timeString,
                        style: CustomTextStyles().caption.copyWith(
                            color: CustomColors.monotoneBlack, height: 1.5),
                      ),
                      SizedBox(height: 24),
                      Text(
                        widget.text,
                        style: CustomTextStyles()
                            .subtitle1
                            .copyWith(color: CustomColors.monotoneBlack),
                      ),
                      SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
          ),
          // Logo Image
          Positioned(
            bottom: 16,
            right: 16,
            child: Image.asset(
              'assets/images/logo/main_logo_red_x1.png',
              width: 60,
            ),
          ),
        ]);
      },
    );
  }
}
