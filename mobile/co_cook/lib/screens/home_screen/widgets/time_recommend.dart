import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

import 'package:co_cook/widgets/card/grid_card.dart';

class TimeRecommend extends StatefulWidget {
  const TimeRecommend({super.key, required this.dataList});
  final List<Map> dataList;

  @override
  State<TimeRecommend> createState() => _TimeRecommendState();
}

class _TimeRecommendState extends State<TimeRecommend> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("오늘 저녁,",
                  style: const CustomTextStyles().title2.copyWith(
                        color: CustomColors.redPrimary,
                      )),
              Container(
                margin: const EdgeInsets.only(top: 8),
                child: Text("이런 요리 어때요?",
                    style: const CustomTextStyles().subtitle1.copyWith(
                          color: CustomColors.monotoneBlack,
                        )),
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.82,
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return GridCard(
                data: widget.dataList[index],
              );
            },
            itemCount: 3,
            viewportFraction: 0.65,
            scale: 0.7,
            autoplay: true,
            autoplayDelay: 7000,
            duration: 1000,
          ),
        )
      ]),
    );
  }
}
