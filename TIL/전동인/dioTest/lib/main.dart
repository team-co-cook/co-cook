import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:dio_test/dio_services.dart';

void main() {
  runApp(MaterialApp(
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
              Text('Dio TEST입니다.', style: TextStyle(fontSize: 20)),
              GestureDetector(
                onTap: () async {
                  print('클릭!');
                  Dio _dio = DioServices().to(); // 작성한 서비스 불러오기
                  Response response; // 리스폰스 명시
                  response = await _dio.get('/api/users/2'); // get요청
                  print(response); // 결과 출력
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color.fromRGBO(125, 125, 125, 1)),
                  child: const Center(
                    child: Text(
                      "API 요청 버튼입니다만?",
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