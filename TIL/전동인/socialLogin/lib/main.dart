import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

Future<void> signInWithGoogle() async {
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

  // final OAuthCredential credential = GoogleAuthProvider.credential(
  //   accessToken: googleSignInAuthentication.accessToken,
  //   idToken: googleSignInAuthentication.idToken,
  // );
  print('로그인!');
  print(googleSignInAuthentication);
  print(googleSignInAuthentication.accessToken);
  print(googleSignInAuthentication.idToken);
}

Future<void> signOutGoogle() async{
  await googleSignIn.signOut();
  print('로그아웃!');
}

void main() {
  runApp(const MaterialApp(
    home:  MyApp()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Text('Test'),
            TextButton(onPressed: (){
              signInWithGoogle();
            }, child: Text('로그인')),
            TextButton(onPressed: (){
              signOutGoogle();
            }, child: Text('로그아웃'))
          ],
        )
      ),
    );
  }
}