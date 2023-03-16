import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:co_cook/screens/login_screen/login_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:co_cook/widgets/bottom_nav_bar/bottom_nav_bar.dart';

class LogOut extends StatelessWidget {
  const LogOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            logOut(context: context);
          },
          child: Text('로그아웃')
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0, onTap: (int i) {}),
    );
  }
}

Future<void> signOutGoogle() async{
  final GoogleSignIn googleSignIn = GoogleSignIn(); // 구글 로그인 함수 불러오기
  await googleSignIn.signOut();
  print('로그아웃!');
}

void logOut({required BuildContext context}) async{
  final prefs = await SharedPreferences.getInstance();
  final success = await prefs.remove('userData');
  signOutGoogle();
  print('로그인 정보 삭제 완료!');
  Route login = MaterialPageRoute(builder: (context) => LoginScreen());
  Navigator.pushReplacement(context, login);
}