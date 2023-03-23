import 'package:flutter/material.dart';
import 'package:co_cook/utils/route.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

import 'package:sticky_headers/sticky_headers.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:co_cook/screens/cook_screen/cook_screen.dart';
import 'package:co_cook/widgets/sliding_up_panel/sliding_up_panel.dart';
import 'package:co_cook/screens/recipe_detail_screen/widgets/recipe_detail_info.dart';
import 'package:co_cook/screens/recipe_detail_screen/widgets/recipe_detail_review.dart';
import 'package:co_cook/screens/recipe_detail_screen/widgets/ai_recipe_start_button.dart';
import 'package:co_cook/screens/recipe_detail_screen/widgets/recipe_detail_recipe_tab.dart';
import 'package:co_cook/screens/recipe_detail_screen/widgets/recipe_detail_screen_appbar.dart';

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({super.key, required this.recipeIdx});
  final int recipeIdx;

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen>
    with TickerProviderStateMixin {
  final PanelController _panelController =
      PanelController(); // 새 PanelController 추가
  late ScrollController _scrollController;

  double _scrollControllerOffset = 0.0;
  _scrollListener() {
    setState(() {
      _scrollControllerOffset = _scrollController.offset;
    });
  }

  int _tabControllerIndex = 0;
  late TabController _tabController;
  _tabListener() {
    setState(() {
      _tabControllerIndex = _tabController.index;
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_tabListener);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.redLight,
      body: Stack(children: [
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          controller: _scrollController,
          child: Container(
            padding: EdgeInsets.only(top: 280 - 64),
            child: StickyHeader(
              header: Container(
                width: double.infinity,
                height: 82,
                decoration: BoxDecoration(color: CustomColors.monotoneLight),
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 64),
                child: Column(
                  children: [
                    ZoomTapAnimation(
                        onTap: () => pushScreen(
                            context,
                            CookScreen(
                              recipeIdx: widget.recipeIdx,
                            )),
                        end: 0.98,
                        child: AiRecipeStartButton()),
                    TabBar(
                        indicatorWeight: 4.0,
                        indicatorColor: CustomColors.redPrimary,
                        labelPadding: EdgeInsets.only(top: 16, bottom: 8),
                        controller: _tabController,
                        labelColor: CustomColors.monotoneBlack,
                        labelStyle: CustomTextStyles().subtitle2,
                        unselectedLabelColor: CustomColors.monotoneGray,
                        unselectedLabelStyle: CustomTextStyles().body2,
                        tabs: [Text("정보"), Text("레시피"), Text("한줄평")])
                  ],
                ),
              ),
              content: Container(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 160),
                  width: double.infinity,
                  child: [
                    RecipeDetailInfoTab(recipeIdx: widget.recipeIdx),
                    RecipeDetailRecipeTab(recipeIdx: widget.recipeIdx),
                    RecipeDetailReviewTab(
                        panelController: _panelController,
                        recipeIdx: widget.recipeIdx)
                  ][_tabControllerIndex]),
            ),
          ),
        ),
        RecipeDetailScreenAppBar(
          recipeIdx: widget.recipeIdx,
          scrollControllerOffset: _scrollControllerOffset,
          maxAppBarHeight: 280,
          minAppBarHeight: 64,
        ),
        Positioned(
            child: CustomSlidingUpPanel(
                body: Text("댓글내용"), panelController: _panelController))
      ]),
    );
  }
}
