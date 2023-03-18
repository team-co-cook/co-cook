import 'package:co_cook/widgets/nickname_change/nickname_change.dart';
import 'package:flutter/material.dart';
import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:co_cook/screens/login_screen/login_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart'; // Response 가져오기 위함.
import 'package:co_cook/services/auth_service.dart';
import 'dart:convert'; // decode 가져오기

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.monotoneLight,
        elevation: 1.0,
        toolbarHeight: 120,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(10, 60, 0, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '나는윤성운',
              style: const CustomTextStyles()
                  .title1
                  .copyWith(color: CustomColors.monotoneBlack),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 60, 10, 0),
            child: IconButton(
              icon: Icon(Icons.edit, color: CustomColors.monotoneBlack),
              onPressed: () {
                gotoNicknameChange(context);
              },
            ),
          ),
        ],
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextButton(
                  text: '내가 작성한 한줄평', color: CustomColors.monotoneBlack),
              CustomTextButton(text: '이용약관', color: CustomColors.monotoneBlack),
              CustomTextButton(
                  text: '개인정보처리방침', color: CustomColors.monotoneBlack),
              CustomTextButton(text: '공지사항', color: CustomColors.monotoneBlack),
              CustomTextButton(
                  text: '자주하는 질문', color: CustomColors.monotoneBlack),
              CustomTextButton(text: '고객문의', color: CustomColors.monotoneBlack),
              CustomTextButton(
                text: '회원탈퇴',
                color: CustomColors.redPrimary,
                onPressed: () {
                  withdrawal(context);
                },
              ),
              CustomTextButton(
                  text: '로그아웃',
                  color: CustomColors.redPrimary,
                  onPressed: () {
                    logOut(context: context);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  CustomTextButton(
      {super.key, required this.text, required this.color, this.onPressed});

  final String text;
  final Color color;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: CustomTextStyles().subtitle1.copyWith(color: color),
      ),
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all<Color>(
            Colors.transparent), // 기본 터치 효과를 없애는 코드
      ),
    );
  }
}

// 구글 로그인 정보 지우기
Future<void> signOutGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn(); // 구글 로그인 함수 불러오기
  await googleSignIn.signOut();
  print('로그아웃!');
}

// 전체 로그아웃 호출 함수
void logOut({required BuildContext context}) async {
  final prefs = await SharedPreferences.getInstance();
  final success = await prefs.remove('userData');
  signOutGoogle();
  print('로그인 정보 삭제 완료!');
  Route login = MaterialPageRoute(builder: (context) => const LoginScreen());
  Navigator.pushReplacement(context, login);
}

void gotoNicknameChange(BuildContext context) {
  Route nicknameChange =
      MaterialPageRoute(builder: (context) => const NicknameChange());
  Navigator.push(context, nicknameChange);
}

void withdrawal(BuildContext context) async {
  // UserIdx 가져오기
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String prefsUserData =
      prefs.getString('userData') ?? ''; // 기본값으로 빈 문자열을 사용합니다.
  Map<String, dynamic> decodePrefs = jsonDecode(prefsUserData);
  int userIdx = decodePrefs['user_idx'];

  // api 요청하기
  AuthService _apiService = AuthService();
  Response? response = await _apiService.withdrawal(userIdx);

  if (response?.data['status'] == 204) {
    // print('로그인으로 이동!');
    Route login = MaterialPageRoute(builder: (context) => const LoginScreen());
    Navigator.pushReplacement(context, login);
  }
}
