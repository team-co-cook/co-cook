import 'package:dio/dio.dart';

final dio = Dio();

// 테스트할 상세주소 https://reqres.in/api/users/2
class DioServices {
  static final DioServices _dioServices = DioServices._internal();
  factory DioServices() => _dioServices;
  Map<String, dynamic> dioInformation = {};

  static Dio _dio = Dio();

  DioServices._internal() {
    BaseOptions _options = BaseOptions(
      baseUrl: 'https://reqres.in', // 이후 주소로 받는 부분은 path라는 이름으로 자동 추가됨.
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      sendTimeout: const Duration(seconds: 5),
      // headers: {},
    );
    _dio = Dio(_options);
    _dio.interceptors.add(CustomLogInterceptor());
  }

  Dio to() {
    return _dio;
  }
}

// CustomLog
// dio.interceptors.add(CustomLogInterceptor());

// 커스텀 로그 인터셉터, 요청 전/후, 에러 시에 컨트롤 가능
class CustomLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // request 전, 컨트롤
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // response 후, 컨트롤
    print(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // error 캐치 시, 컨트롤
    print(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    super.onError(err, handler);
  }
}

// service 사용법
// Dio _dio = DioServices().to();
// await _dio.get('/api/users/2');


// 기본 사용법
// Future getServerDataWithDio() async {
//   String url = 'https://reqres.in/api/users/2';
//   BaseOptions options = BaseOptions(
//     baseUrl: 'https://reqres.in',
//     connectTimeout: Duration(seconds: 5),
//     receiveTimeout: Duration(seconds: 5),
//   );
//   Dio dio = Dio(options);
//   try {
//     Response resp = await dio.get(
//       '/api/users/2',
//       //queryParameters: {"search": "dio"},
//     );
//     print('Response:');
//     print('Status: ${resp.statusCode}');
//     print('Header:\n${resp.headers}');
//     print('Data:\n${resp.data}');
//
//   } catch (e) {
//     print('Exception: $e');
//   }
// }