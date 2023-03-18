import 'package:flutter/material.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

import 'package:co_cook/widgets/text_field/custom_text_field.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? _searchWord;
  final _focusNode = FocusNode(); // 포커싱 여부를 추적하는 클래스 인스턴스

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColors.monotoneLight,
          elevation: 1.0,
          toolbarHeight: 120,
          title: Padding(
              padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
              child: CustomTextField(
                onChanged: onWordChanged,
                isFocus: false,
                isSearch: true,
                onSubmitted: (p0) {},
              )),
        ),
        body: Column(
          children: [
            GestureDetector(
              onTap: () async {
                // CameraScreen으로 이동
              },
              child: Image.asset(
                'assets/images/button_img/CameraSearchLargeX2.png',
                width: 280,
              ),
            ),
          ],
        ));
  }

  // 커스텀 텍스트 필드에 내려주기 위한 onChange-setState 함수
  void onWordChanged(String value) {
    setState(() {
      _searchWord = value;
    });
  }
}
