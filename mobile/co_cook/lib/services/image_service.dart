import 'dart:io';

import 'package:dio/dio.dart';
import 'package:co_cook/services/dio_service.dart';

class ImageService {
  // POST : 음성파일 추가
  Future<Response?> postImage(FormData data) async {
    String url = 'http://j8b302.p.ssafy.io:3000/upload/img';
    try {
      Dio dio = Dio(); // 새로운 Dio 객체 생성
      return await dio.post(
        url,
        data: data,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
    } on DioError catch (e) {
      // DioError 처리
      print("postAudio Error : ${e.response}");
      return e.response; // DioError가 발생한 경우에도 무조건 리턴
    }
  }
}
