import 'package:dio/dio.dart';
import 'package:co_cook/services/dio_service.dart';

class SearchService {
  // 이 메서드는 각 API 요청 메서드에서 호출됩니다.
  Future<Dio> _getDio() async {
    return await DioServices()
        .getDioWithHeaders(); // 현재 DB에 있는 정보를 토대로 해더를 추가합니다.
  }

  // GET - 키워드 검색하기
  Future<Response?> getSearchList({required String keyword}) async {
    try {
      Dio _dio = await _getDio(); // 새로운 Dio 객체 생성
      return await _dio.get('/list/search?keyword=$keyword');
    } on DioError catch (e) {
      // DioError 처리
      return e.response; // DioError가 발생한 경우에도 무조건 리턴
    }
  }

  // GET - 인기 검색어 가져오기
  Future<Response?> getTrendList() async {
    try {
      Dio _dio = await _getDio(); // 새로운 Dio 객체 생성
      return await _dio.get('/search/popular');
    } on DioError catch (e) {
      // DioError 처리
      return e.response; // DioError가 발생한 경우에도 무조건 리턴
    }
  }
}
