import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:co_cook/screens/login_screen/login_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:co_cook/widgets/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';

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
                // Add your onPressed code here!
              },
            ),
          ),
        ],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  // Add your onPressed code here!
                },
                child: Text(
                  '내가 찜한 레시피',
                  style: CustomTextStyles()
                      .subtitle1
                      .copyWith(color: CustomColors.monotoneBlack),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Add your onPressed code here!
                },
                child: Text(
                  '내가 작성한 한줄평',
                  style: CustomTextStyles()
                      .subtitle1
                      .copyWith(color: CustomColors.monotoneBlack),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Add your onPressed code here!
                },
                child: Text(
                  '이용약관',
                  style: CustomTextStyles()
                      .subtitle1
                      .copyWith(color: CustomColors.monotoneBlack),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Add your onPressed code here!
                },
                child: Text(
                  '개인정보처리방침',
                  style: CustomTextStyles()
                      .subtitle1
                      .copyWith(color: CustomColors.monotoneBlack),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Add your onPressed code here!
                },
                child: Text(
                  '공지사항',
                  style: CustomTextStyles()
                      .subtitle1
                      .copyWith(color: CustomColors.monotoneBlack),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Add your onPressed code here!
                },
                child: Text(
                  '자주하는 질문',
                  style: CustomTextStyles()
                      .subtitle1
                      .copyWith(color: CustomColors.monotoneBlack),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Add your onPressed code here!
                },
                child: Text(
                  '고객문의',
                  style: CustomTextStyles()
                      .subtitle1
                      .copyWith(color: CustomColors.monotoneBlack),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Add your onPressed code here!
                },
                child: Text(
                  '회원탈퇴',
                  style: CustomTextStyles()
                      .subtitle1
                      .copyWith(color: CustomColors.redPrimary),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Add your onPressed code here!
                },
                child: Text(
                  '로그아웃',
                  style: CustomTextStyles()
                      .subtitle1
                      .copyWith(color: CustomColors.redPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> signOutGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn(); // 구글 로그인 함수 불러오기
  await googleSignIn.signOut();
  print('로그아웃!');
}

void logOut({required BuildContext context}) async {
  final prefs = await SharedPreferences.getInstance();
  final success = await prefs.remove('userData');
  signOutGoogle();
  print('로그인 정보 삭제 완료!');
  Route login = MaterialPageRoute(builder: (context) => LoginScreen());
  Navigator.pushReplacement(context, login);
}
