import 'dart:convert'; // decode 가져오기
import 'package:co_cook/widgets/button/button.dart';
import 'package:dio/dio.dart'; // Response 가져오기 위함.
import 'package:flutter/material.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

import 'package:co_cook/widgets/text_field/custom_text_field.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  String _text = '';
  bool _isError = false;
  String _errorMessage = '';
  final _focusNode = FocusNode(); // 포커싱 여부를 추적하는 클래스 인스턴스

  @override
  void initState() {
    super.initState();
  }

  // 위젯이 소멸될 때 호출되는 메서드
  @override
  void dispose() {
    _focusNode.dispose(); // 현재 위젯에서 포커스 해제
    super.dispose();
  }

  // 키보드 외 화면을 눌렀을 때, 포커스 해제
  void _dismissKeyboard(BuildContext context) {
    final currentFocus = FocusScope.of(context); // 현재 포커싱된 위젯을 반환
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      // 현재 포커싱된 위젯이 최상위 FocusScope가 아니면서, 포커싱이 존재한다면.
      currentFocus.focusedChild?.unfocus(); // 현재 포커싱된 자식 위젯의 포커싱을 해제
    }
  }

  // 커스텀 텍스트 필드에 내려주기 위한 onChange-setState 함수
  void onTextChanged(String value) {
    setState(() {
      _text = value;
      _isError = false;
      _errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GestureDetector(
        onTap: () {
          _dismissKeyboard(context);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: CustomColors.greenPrimary,
            elevation: 0.5,
            toolbarHeight: 120,
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  '완성!',
                  style: const CustomTextStyles()
                      .title1
                      .copyWith(color: CustomColors.monotoneLight),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '내가 만든 음식을\n사진으로 남겨보세요',
                      style: CustomTextStyles().subtitle1.copyWith(
                          color: CustomColors.monotoneBlack, height: 1.5),
                    ),
                    SizedBox(height: 16),
                    LayoutBuilder(builder: (context, constraints) {
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: constraints.maxWidth,
                          height: constraints.maxWidth * 0.7,
                          decoration: BoxDecoration(
                              color: CustomColors.monotoneLight,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: CustomColors.monotoneLightGray,
                                  width: 1)),
                          alignment: Alignment.center,
                          child: Icon(Icons.add_a_photo,
                              size: 20, color: CustomColors.monotoneGray),
                        ),
                      );
                    }),
                    SizedBox(height: 40),
                    Text(
                      '이 레시피는 어떠셨나요?\n한줄평을 남겨주세요',
                      style: CustomTextStyles().subtitle1.copyWith(
                          color: CustomColors.monotoneBlack, height: 1.5),
                    ),
                    SizedBox(height: 16),
                    CustomTextField(onChanged: onTextChanged),
                    SizedBox(height: 8),
                    Text(
                      '예시\n  ·  난이도가 적절한 좋은 레시피에요!\n  ·  생각보다 너무 쉬웠어요.\n  ·  시간이 예상보다 오래 걸렸어요.',
                      style: CustomTextStyles().caption.copyWith(
                          color: CustomColors.monotoneGray, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
