import 'package:flutter/material.dart';
import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

class RecipeDetailRecipeTab extends StatelessWidget {
  const RecipeDetailRecipeTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.fromLTRB(8.0, 24.0, 24.0, 24.0),
        physics: NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) => Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "1",
                        style: CustomTextStyles()
                            .subtitle2
                            .copyWith(color: CustomColors.monotoneBlack),
                      )),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: Colors.amber,
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 8, bottom: 32),
                            child: Text(
                              "먼저 재료를 준비합니다.",
                              style: CustomTextStyles()
                                  .body1
                                  .copyWith(color: CustomColors.monotoneBlack),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }
}
