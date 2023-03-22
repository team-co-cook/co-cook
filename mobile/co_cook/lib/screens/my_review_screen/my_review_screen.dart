// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'dart:convert';

// import 'package:co_cook/services/detail_service.dart';
// import 'package:co_cook/styles/colors.dart';
// import 'package:co_cook/styles/text_styles.dart';
// import 'package:co_cook/widgets/comment/recipe_comment.dart';

// import 'package:sliding_up_panel/sliding_up_panel.dart';

// class MyReviewScreen extends StatefulWidget {
//   const MyReviewScreen({Key? key}) : super(key: key);

//   @override
//   State<MyReviewScreen> createState() => _MyReviewScreenState();
// }

// class _MyReviewScreenState extends State<MyReviewScreen> {
//   List listData = [];

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<void> getDetailReview(int recipeIdx) async {
//     // API 요청
//     DetailService searchService = DetailService();
//     Response? response =
//         await searchService.getDetailReview(recipeIdx: recipeIdx);
//     print(response!.data['data']);
//     if (response?.statusCode == 200) {
//       if (response != null) {
//         setState(() {
//           listData = response!.data['data']['reviewsListResDto'];
//         });
//       }
//     }
//   }

//   void reGet() {
//     getDetailReview(widget.recipeIdx);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: CustomColors.monotoneLight,
//         elevation: 0.5,
//         title: const SizedBox.shrink(), // Remove the original title
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(30.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               GestureDetector(
//                 onTap: () => Navigator.of(context).pop(),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(
//                     Icons.arrow_back,
//                     color: CustomColors.monotoneBlack,
//                   ),
//                 ),
//               ),
//               Text(
//                 '내가 작성한 한줄평',
//                 style: const CustomTextStyles()
//                     .subtitle1
//                     .copyWith(color: CustomColors.monotoneBlack),
//               ),
//               SizedBox(width: 48), // Add space to balance the back button width
//             ],
//           ),
//         ),
//       ),
//       body: Container(
//         color: CustomColors.monotoneLight,
//         child: Stack(children: [
//           ListView.builder(
//             shrinkWrap: true,
//             padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 24.0),
//             physics: NeverScrollableScrollPhysics(),
//             itemCount: listData.length,
//             itemBuilder: (context, index) => RecipeComment(
//                 panelController: widget.panelController,
//                 review: listData[index],
//                 reGet: reGet),
//           ),
//         ]),
//       ),
//     );
//   }
// }
