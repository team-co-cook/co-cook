import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const MaterialApp(
      home: MyApp()
  )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text('TTS TEST입니다.', style: TextStyle(fontSize: 20)),
              GestureDetector(
                onTap: () async {
                  print('클릭!');
                  FlutterTts flutterTts = FlutterTts();

                  // 한국어 TTS 사용 예시
                  await flutterTts.setLanguage("ko-KR");
                  await flutterTts.speak("라면을 넣고 1분동안 더 끓여줍니다.");
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color.fromRGBO(125, 125, 125, 1)),
                  child: const Center(
                    child: Text(
                      "안녕하신가요?",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}