import 'package:dio/dio.dart';
import 'package:co_cook/services/dio_service.dart';

class DetailService {
  // 이 메서드는 각 API 요청 메서드에서 호출됩니다.
  Future<Dio> _getDio() async {
    return await DioServices()
        .getDioWithHeaders(); // 현재 DB에 있는 정보를 토대로 해더를 추가합니다.
  }

  // GET : Detail Basic
  Future<Response?> getDetailBasic({required int recipeIdx}) async {
    try {
      Dio _dio = await _getDio(); // 새로운 Dio 객체 생성
      return await _dio.get('/recipe/info/$recipeIdx');
    } on DioError catch (e) {
      // DioError 처리
      return e.response; // DioError가 발생한 경우에도 무조건 리턴
    }
  }

  // GET : Detail Info
  Future<Response?> getDetailInfo({required int recipeIdx}) async {
    try {
      Dio _dio = await _getDio(); // 새로운 Dio 객체 생성
      return await _dio.get('/recipe/detail/$recipeIdx');
    } on DioError catch (e) {
      // DioError 처리
      return e.response; // DioError가 발생한 경우에도 무조건 리턴
    }
  }

  // GET : Detail Step
  Future<Response?> getDetailStep({required int recipeIdx}) async {
    try {
      Dio _dio = await _getDio(); // 새로운 Dio 객체 생성
      return await _dio.get('/recipe/step/$recipeIdx');
    } on DioError catch (e) {
      // DioError 처리
      return e.response; // DioError가 발생한 경우에도 무조건 리턴
    }
  }

  // GET : Detail Review
  Future<Response?> getDetailReview({required int recipeIdx}) async {
    try {
      Dio _dio = await _getDio(); // 새로운 Dio 객체 생성
      return await _dio.get('/recipe/review/$recipeIdx');
    } on DioError catch (e) {
      // DioError 처리
      return e.response; // DioError가 발생한 경우에도 무조건 리턴
    }
  }

  // POST : Detail Review Like
  Future<Response?> likeDetailReview({required int reviewIdx}) async {
    try {
      Dio _dio = await _getDio(); // 새로운 Dio 객체 생성
      return await _dio.post('/review/like/$reviewIdx');
    } on DioError catch (e) {
      // DioError 처리
      return e.response; // DioError가 발생한 경우에도 무조건 리턴
    }
  }

  // DELETE : Detail Review Like
  Future<Response?> dislikeDetailReview({required int reviewIdx}) async {
    try {
      Dio _dio = await _getDio(); // 새로운 Dio 객체 생성
      return await _dio.delete('/review/like/$reviewIdx');
    } on DioError catch (e) {
      // DioError 처리
      return e.response; // DioError가 발생한 경우에도 무조건 리턴
    }
  }

  // POST : Review Create
  Future<Response?> createReview(FormData reviewData) async {
    try {
      Dio _dio = await _getDio(); // 새로운 Dio 객체 생성
      return await _dio.post(
        '/review',
        data: reviewData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
    } on DioError catch (e) {
      // DioError 처리
      return e.response; // DioError가 발생한 경우에도 무조건 리턴
    }
  }

  // DELETE : Delete Review
  Future<Response?> deleteReview({required int reviewIdx}) async {
    try {
      Dio _dio = await _getDio(); // 새로운 Dio 객체 생성
      return await _dio.delete('/review/$reviewIdx');
    } on DioError catch (e) {
      // DioError 처리
      return e.response; // DioError가 발생한 경우에도 무조건 리턴
    }
  }
}
