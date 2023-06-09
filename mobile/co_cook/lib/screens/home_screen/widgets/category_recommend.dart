import 'package:co_cook/styles/shadows.dart';
import 'package:co_cook/widgets/shimmer/custom_shimmer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:co_cook/services/list_service.dart';
import 'package:co_cook/services/recommend_service.dart';
import 'package:co_cook/screens/list_screen/list_screen.dart';

class CategoryRecommend extends StatefulWidget {
  const CategoryRecommend({super.key});

  @override
  State<CategoryRecommend> createState() => _CategoryRecommendState();
}

class _CategoryRecommendState extends State<CategoryRecommend> {
  @override
  void initState() {
    super.initState();
    getTimeRecommendData("/home/category");
  }

  List? dataList;

  Future<void> getTimeRecommendData(String apiPath) async {
    // API 요청
    RecommendService recommendService = RecommendService();
    Response? response = await recommendService.getCardData(apiPath);
    if (response?.statusCode == 200) {
      if (response?.data['data'] != null) {
        setState(() {
          dataList = response!.data['data'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 8.0),
      child: dataList != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CategoryRecommendCard(data: dataList![0]),
                CategoryRecommendCard(data: dataList![1]),
                CategoryRecommendCard(data: dataList![2])
              ],
            )
          : const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CategoryRecommendCard(),
                CategoryRecommendCard(),
                CategoryRecommendCard()
              ],
            ),
    );
  }
}

class CategoryRecommendCard extends StatelessWidget {
  const CategoryRecommendCard({
    super.key,
    this.data,
  });
  final Map? data;

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
        end: 0.98,
        onTap: () {
          data != null
              ? gotoList(context, data!['categoryName'], data!["imgPath"])
              : null;
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: CustomColors.redLight,
            boxShadow: const [CustomShadows.card],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: data != null
                ? Stack(children: [
                    SizedBox(
                      width: ((MediaQuery.of(context).size.width - 48) / 3 - 8),
                      height: 128,
                      child: FadeInImage.memoryNetwork(
                          fadeInDuration: const Duration(milliseconds: 200),
                          fit: BoxFit.cover,
                          placeholder: kTransparentImage,
                          image: data!["imgPath"]),
                    ),
                    Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Color.fromARGB(71, 0, 0, 0),
                        )),
                    Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Center(
                            child: Text(data!["categoryName"],
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
                  ])
                : CustomShimmer(
                    width: ((MediaQuery.of(context).size.width - 48) / 3 - 8),
                    height: 128,
                  ),
          ),
        ));
  }
}

void gotoList(BuildContext context, String listName, String imgPath) {
  Route themeScreen = MaterialPageRoute(
      builder: (context) => ListScreen(
            listName: listName,
            imgPath: imgPath,
            dataFetcher: ListService().getCategoryDataFetcher(listName),
          ));
  Navigator.push(context, themeScreen);
}
