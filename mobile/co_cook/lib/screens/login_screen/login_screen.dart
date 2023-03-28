import 'dart:convert';
import 'package:dio/dio.dart'; // Response 가져오기 위함.
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

import 'package:co_cook/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:co_cook/screens/main_screen/main_screen.dart';
import 'package:co_cook/screens/signup_screen/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: CustomColors.redLight,
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 191,
              right: MediaQuery.of(context).size.width / 2 - 109,
              child: Image.asset(
                'assets/images/logo/main_logo_red_x1.png',
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 2 + 100,
              left: MediaQuery.of(context).size.width / 2 - 140,
              child: GestureDetector(
                onTap: () async {
                  signInWithGoogle(context); // 구글 로그인 리다이렉트
                },
                child: Image.asset(
                  'assets/images/button_img/google_login_btn.png',
                  width: 280,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> signInWithGoogle(BuildContext context) async {
  final GoogleSignIn googleSignIn = GoogleSignIn(); // 구글 로그인 함수 불러오기
  // print('로그인 시작!');
  try {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    // print('로그인 상태확인 $googleSignInAccount');
    if (googleSignInAccount == null) {
      // 사용자가 로그인 창을 닫거나 로그인을 취소한 경우
      // print('사용자가 로그인을 취소했습니다.');
      return;
    }

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    // print('토큰 수납!');
    // print(googleSignInAuthentication.accessToken);
    String userToken = googleSignInAuthentication.accessToken.toString();

    // print('유저정보 확인!');
    AuthService _apiService = AuthService();
    Map<String, dynamic> userData = {'access_token': userToken};
    Response? response = await _apiService.loginUser(userData);
    // print(
    //     '응답: ${response}'); // {"message":"OK","status":200,"data":{"user_idx":null,"email":"xxxx@gmail.com","nickname":null,"jwtToken":null}}

    // 디코딩
    Map<String, dynamic> decodeRes = response?.data;
    // print('디코딩 : $decodeRes');

    if (decodeRes['data']['user_idx'] == null) {
      // print('회원가입으로 이동!');
      String userEmail = decodeRes['data']['email'];
      Route signup = MaterialPageRoute(
          builder: (context) =>
              SignupScreen(email: userEmail, token: userToken));
      Navigator.pushReplacement(context, signup);
    } else {
      // print('로컬에 유저정보 저장!');
      // shared preferences에 저장
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userData', jsonEncode(decodeRes['data']));

      // print('홈으로 이동!');
      Route home = MaterialPageRoute(builder: (context) => const MainScreen());
      Navigator.pushReplacement(context, home);
    }
  } catch (error) {
    // 예외 처리
    // print('구글 로그인 실패');
    print(error);
    return;
  }
}
