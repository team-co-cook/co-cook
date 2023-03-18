import 'package:dio/dio.dart';
import 'package:co_cook/services/dio_service.dart';

class ListService {
  // 이 메서드는 각 API 요청 메서드에서 호출됩니다.
  Future<Dio> _getDio() async {
    return await DioServices()
        .getDioWithHeaders(); // 현재 DB에 있는 정보를 토대로 해더를 추가합니다.
  }

  // GET
  Future<Response?> getThemeList(
      {required String themeName,
      required String difficulty,
      required int time}) async {
    try {
      Dio _dio = await _getDio(); // 새로운 Dio 객체 생성
      return await _dio.get(
          '/list/theme?themeName=$themeName&difficulty=$difficulty&time=$time');
    } on DioError catch (e) {
      // DioError 처리
      return e.response; // DioError가 발생한 경우에도 무조건 리턴
    }
  }

  // POST
  // Future<Response?> loginUser(Map<String, dynamic> userData) async {
  //   try {
  //     Dio _dio = await _getDio(); // 새로운 Dio 객체 생성
  //     return await _dio.post('/account/check', data: userData);
  //   } on DioError catch (e) {
  //     // DioError 처리
  //     return e.response; // DioError가 발생한 경우에도 무조건 리턴
  //   }
  // }

  // PUT
  // Future<Response?> changeNickname(
  //     Map<String, dynamic> userData, int userIdx) async {
  //   try {
  //     Dio _dio = await _getDio(); // 새로운 Dio 객체 생성
  //     return await _dio.put('/mypage/nickname/$userIdx', data: userData);
  //   } on DioError catch (e) {
  //     // DioError 처리
  //     return e.response; // DioError가 발생한 경우에도 무조건 리턴
  //   }
  // }

  // DELETE
  // Future<Response> deleteUser(int userId) async {
  //   Dio _dio = await _getDio(); // 새로운 Dio 객체 생성
  //   return await _dio.delete('/api/users/$userId');
  // }
}
