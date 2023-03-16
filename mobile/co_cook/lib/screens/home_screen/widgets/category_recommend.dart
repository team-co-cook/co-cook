import 'package:flutter/material.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

class CategoryRecommend extends StatelessWidget {
  const CategoryRecommend({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [CategoryCard()],
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print("인식 연결!!"),
      child: Stack(children: [
        Container(
          width: (MediaQuery.of(context).size.width / 3 - 24), // 부모 요소의 너비를 가져옴
          height: 128, // 부모 요소의 너비와 같은 값으로 설정
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: const DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                  "assets/images/background/search_photo_background.png"),
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
                child: Text("메인요리",
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
      ]),
    );
  }
}
