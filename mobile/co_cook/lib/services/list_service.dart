import 'package:dio/dio.dart';
import 'package:co_cook/services/dio_service.dart';

typedef Future<Response?> DataFetcher(
    {required String difficulty, required int time});

class ListService {
  // 이 메서드는 각 API 요청 메서드에서 호출됩니다.
  Future<Dio> _getDio() async {
    return await DioServices()
        .getDioWithHeaders(); // 현재 DB에 있는 정보를 토대로 해더를 추가합니다.
  }

  // 테마 리스트 가져오기
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

  // 카테고리 리스트 가져오기
  Future<Response?> getCategoryList(
      {required String category,
      required String difficulty,
      required int time}) async {
    try {
      Dio _dio = await _getDio(); // 새로운 Dio 객체 생성
      return await _dio.get(
          '/list/category?categoryName=$category&difficulty=$difficulty&time=$time');
    } on DioError catch (e) {
      // DioError 처리
      return e.response; // DioError가 발생한 경우에도 무조건 리턴
    }
  }

  // 전체 레시피 가져오기
  Future<Response?> getAllList(
      {required String difficulty, required int time}) async {
    try {
      Dio _dio = await _getDio(); // 새로운 Dio 객체 생성
      return await _dio.get('/list/all?&difficulty=$difficulty&time=$time');
    } on DioError catch (e) {
      // DioError 처리
      return e.response; // DioError가 발생한 경우에도 무조건 리턴
    }
  }

  // 내가 찜한 레시피
  Future<Response?> getFavoriteList() async {
    try {
      Dio _dio = await _getDio(); // 새로운 Dio 객체 생성
      return await _dio.get('/list/favorite');
    } on DioError catch (e) {
      // DioError 처리
      return e.response; // DioError가 발생한 경우에도 무조건 리턴
    }
  }

  // 내가 찜한 레시피
  Future<Response?> getIngredientList({required String ingredients}) async {
    try {
      Dio _dio = await _getDio(); // 새로운 Dio 객체 생성
      return await _dio.get('/list/ingredients?ingredients=$ingredients');
    } on DioError catch (e) {
      // DioError 처리
      return e.response; // DioError가 발생한 경우에도 무조건 리턴
    }
  }

  // 분기용 함수 ListScreen으로 갈 때, 아래 함수도 같이 보낸다.
  DataFetcher getThemeDataFetcher(String themeName) {
    return ({required String difficulty, required int time}) {
      return getThemeList(
          themeName: themeName, difficulty: difficulty, time: time);
    };
  }

  DataFetcher getCategoryDataFetcher(String category) {
    return ({required String difficulty, required int time}) {
      return getCategoryList(
          category: category, difficulty: difficulty, time: time);
    };
  }

  DataFetcher getAllDataFetcher() {
    return ({required String difficulty, required int time}) {
      return getAllList(difficulty: difficulty, time: time);
    };
  }
}
