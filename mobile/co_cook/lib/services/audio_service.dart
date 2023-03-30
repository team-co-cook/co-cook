import 'dart:io';

import 'package:dio/dio.dart';
import 'package:co_cook/services/dio_service.dart';

class AudioService {
  // POST : 음성파일 추가
  Future<Response?> postAudio(String path) async {
    FormData audioFormData = FormData.fromMap({
      'audio':
          await MultipartFile.fromFile(path, filename: path.split('/').last),
    });

    String url = 'http://j8b302.p.ssafy.io:3000/upload';
    try {
      Dio dio = Dio(); // 새로운 Dio 객체 생성
      return await dio.post(url, data: audioFormData);
    } on DioError catch (e) {
      // DioError 처리
      print("postAudio Error : ${e.response}");
      return e.response; // DioError가 발생한 경우에도 무조건 리턴
    }
  }

  // POST : 음성파일 추가
  Future<Response?> postAudioDJ(String path) async {
    FormData audioFormData = FormData.fromMap({
      'audio':
          await MultipartFile.fromFile(path, filename: path.split('/').last),
    });

    String url = 'http://j8b302.p.ssafy.io:3000/upload/dj';
    try {
      Dio dio = Dio(); // 새로운 Dio 객체 생성
      return await dio.post(url, data: audioFormData);
    } on DioError catch (e) {
      // DioError 처리
      print("postAudio Error : ${e}");
      return e.response; // DioError가 발생한 경우에도 무조건 리턴
    }
  }
}
