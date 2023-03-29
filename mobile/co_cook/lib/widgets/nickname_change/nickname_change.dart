import 'package:flutter/material.dart';
import 'dart:convert'; // decode 가져오기
import 'package:dio/dio.dart'; // Response 가져오기
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:co_cook/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:co_cook/widgets/text_field/custom_text_field.dart';
import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:co_cook/widgets/button/button.dart';

class NicknameChange extends StatefulWidget {
  const NicknameChange({super.key, required this.panelController});
  final PanelController panelController;

  @override
  State<NicknameChange> createState() => _NicknameChangeState();
}

class _NicknameChangeState extends State<NicknameChange> {
  String? _nickname;
  String? _errorMessage;
  bool _isError = false;
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
      body: GestureDetector(
        onTap: () {
          _dismissKeyboard(context);
        },
        child: Container(
          color: CustomColors.monotoneLight,
          child: Stack(
            children: [
              Center(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('닉네임 변경', style: CustomTextStyles().title2),
                          const SizedBox(height: 16), // 공백
                          Stack(// 텍스트 필드와 에러 텍스트 위치를 위한 스택
                              children: [
                            CustomTextField(
                              onChanged: onNicknameChanged,
                              isError: _isError,
                              maxLength: 16,
                              isFocus: false,
                            ),
                            Positioned(
                                bottom: 0,
                                child:
                                    ErrorMessage(errorMessage: _errorMessage)),
                          ]),
                          SizedBox(height: 16), // 공백
                          CommonButton(
                            label: '확인',
                            color: ButtonType.red,
                            onPressed: () {
                              _changeName(context);
                            },
                          ),
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 커스텀 텍스트 필드에 내려주기 위한 onChange-setState 함수
  void onNicknameChanged(String value) {
    setState(() {
      _nickname = value;
      _isError = false;
      _errorMessage = null;
    });
  }

  // 닉네임 변경 로직
  Future<void> _changeName(BuildContext context) async {
    // 유효성 검증
    if (_nickname == null || _nickname == '') {
      setState(() {
        _errorMessage = '닉네임을 입력해주세요.';
        _isError = true;
      });
      return;
    }

    // UserIdx 가져오기
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String prefsUserData =
        prefs.getString('userData') ?? ''; // 기본값으로 빈 문자열을 사용합니다.
    Map<String, dynamic> decodePrefs = jsonDecode(prefsUserData);
    int userIdx = decodePrefs['user_idx'];

    // API 요청
    AuthService _apiService = AuthService();
    Map<String, dynamic> userData = {
      'nickname': _nickname,
    };

    Response? response = await _apiService.changeNickname(userData, userIdx);

    // 디코딩
    Map<String, dynamic> decodeRes = jsonDecode(response.toString());

    // 상태 분기
    if (decodeRes['status'] == 409) {
      // 중복 닉네임 에러 409
      // print('이미 존재하는 이메일 or 이미 존재하는 닉네임인 경우');

      setState(() {
        _errorMessage = decodeRes['message'];
        _isError = true;
      });

      return;
    } else if (decodeRes['status'] == 200) {
      // shared preferences에 저장
      decodePrefs['nickname'] = _nickname;
      prefs.setString('userData', jsonEncode(decodePrefs));
      // print('저장 완료');

      setState(() {
        _errorMessage = null;
        _isError = false;
      });

      // print('닉네임 변경 닫기!');
      widget.panelController.close();

      return;
    } else {
      // 기타 에러
      // print('기타 에러 발생');

      setState(() {
        _errorMessage = '요청이 잘못되었습니다.';
        _isError = true;
      });

      return;
    }
  }
}

// 커스텀 에러 메시지
class ErrorMessage extends StatelessWidget {
  final String? errorMessage;
  const ErrorMessage({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Container(
        alignment: Alignment.centerLeft, // 왼쪽 정렬 추가
        child: Text(errorMessage ?? '',
            style: const CustomTextStyles()
                .subtitle2
                .copyWith(color: CustomColors.redPrimary)),
      ),
    );
  }
}
