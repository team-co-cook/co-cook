import 'package:co_cook/main.dart';
import 'package:co_cook/screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:co_cook/screens/user_screen/user_screen.dart';
import 'package:co_cook/screens/login_screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isMoved = false;
  bool _isVisible = false;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    // 1초 후에 _isMoved 값을 변경하여 애니메이션을 발생시킴
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isMoved = true;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _isVisible = true;
        });
        // _navigateToNextScreen();
      });
      Future.delayed(const Duration(seconds: 1), () {
        _navigateToNextScreen();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFD91604),
        child: Stack(
          children: [
            Center(
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 500),
                tween: Tween<double>(begin: 0, end: _isMoved ? -100 : 0),
                builder: (BuildContext context, double value, Widget? child) {
                  return Transform.translate(
                    offset: Offset(0, value),
                    child: child,
                  );
                },
                child: Image.asset(
                  'assets/images/logo/main_logo_white_x1.png',
                ),
              ),
            ),
            Positioned(
              bottom: 300,
              left: MediaQuery.of(context).size.width / 2 - 18,
              child: Visibility(
                visible: _isVisible,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // 이미 로그인 되어 있는지 판단하고, 홈/로그인 분기합니다.
  void _navigateToNextScreen() async {
    // 데이터 가져오기
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userData =
        prefs.getString('userData') ?? ''; // 기본값으로 빈 문자열을 사용합니다.
    // print('DB유저정보: ${userData}');

    if (userData != null && userData.isNotEmpty) {
      // 로컬에 유저정보가 존재한다면,
      // final Map<String, dynamic> userData = json.decode(jsonString);
      setState(() {
        _isLoggedIn = true;
      });
    }

    if (_isLoggedIn) {
      Route home = MaterialPageRoute(builder: (context) => const MainScreen());
      Navigator.pushReplacement(context, home); // 로그인 상태이면 홈화면으로 이동합니다.
    } else {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            // 연결할 페이지
            pageBuilder: (c, a1, a2) => LoginScreen(),
            // 적용할 애니메이션
            transitionsBuilder: (c, a1, a2, child) =>
                FadeTransition(opacity: a1, child: child),
            // 적용 시간 설정
            transitionDuration: Duration(milliseconds: 500),
          )); // 로그인 상태가 아니면 로그인화면으로 이동합니다.
    }
  }
}
