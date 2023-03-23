import 'package:dio/dio.dart';
import 'package:co_cook/services/dio_service.dart';

class RecommendService {
  // 이 메서드는 각 API 요청 메서드에서 호출됩니다.
  Future<Dio> _getDio() async {
    return await DioServices()
        .getDioWithHeaders(); // 현재 DB에 있는 정보를 토대로 해더를 추가합니다.
  }

  // POST : 음성파일 추가
  Future<Response?> postAudio(int recipeIdx) async {
    try {
      Dio dio = await _getDio(); // 새로운 Dio 객체 생성
      return await dio.post('/favorite', data: {"recipeIdx": recipeIdx});
    } on DioError catch (e) {
      // DioError 처리
      print("getTimeRecommend Error : ${e.response}");
      return e.response; // DioError가 발생한 경우에도 무조건 리턴
    }
  }

  // PUT
  // Future<Response> putUser(int userId, Map<String, dynamic> userData) async {
  //   Dio _dio = await _getDio(); // 새로운 Dio 객체 생성
  //   return await _dio.put('/api/users/$userId', data: userData);
  // }

  // DELETE
  // Future<Response> deleteUser(int userId) async {
  //   Dio _dio = await _getDio(); // 새로운 Dio 객체 생성
  //   return await _dio.delete('/api/users/$userId');
  // }
}


// ----------------------------------------------------
// 위젯에서 사용하는 방법
// import 'package:splash_login/api_service.dart';

// ApiService _apiService = ApiService();

// // GET 메서드 호출
// Response getUserResponse = await _apiService.getUser(2);

// // POST 메서드 호출
// Map<String, dynamic> userData = {'name': 'John Doe', 'email': 'johndoe@example.com'};
// Response postUserResponse = await _apiService.postUser(userData);

// // PUT 메서드 호출
// Map<String, dynamic> updatedUserData = {'name': 'John Doe Jr.'};
// Response putUserResponse = await _apiService.putUser(2, updatedUserData);

// // DELETE
// Response getUserResponse = await _apiService.deleteUser(2);