import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DioServices {
  // 싱글톤 패턴을 사용하기 위한 인스턴스 생성
  static final DioServices _dioServices = DioServices._internal();
  factory DioServices() => _dioServices;

  DioServices._internal();

  // 로그인 여부에 따라서 옵션을 생성하기 위해 로그인판단-해더 추가 로직을 메서드로 구현
  Future<Dio> getDioWithHeaders() async {
    // SharedPreferences에서 userData를 가져오는 과정
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userData = prefs.getString('userData') ?? '';
    String jwtToken = '';

    if (userData.isNotEmpty) {
      Map<String, dynamic> parsedUserData = jsonDecode(userData);
      jwtToken = parsedUserData["jwtToken"] ?? '';
    }

    BaseOptions _options = BaseOptions(
      baseUrl: 'http://j8b302.p.ssafy.io:8080/api/v1',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      sendTimeout: const Duration(seconds: 5),
      headers: {
        if (jwtToken.isNotEmpty) 'AUTH-TOKEN': jwtToken,
      },
    );

    Dio _dio = Dio(_options); // Dio 객체에 옵션을 추가합니다.
    _dio.interceptors.add(CustomLogInterceptor()); // Dio 객체에 커스텀 인터셉터를 추가합니다.
    return _dio;
  }
}

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

/*
싱글톤 패턴(디자인 패턴중 하나)의 이점
공유 리소스: 싱글톤 패턴을 사용하면 클래스의 인스턴스를 하나만 생성하고 여러 곳에서 공유할 수 있습니다. DioServices의 경우, 동일한 인스턴스를 여러 곳에서 사용할 수 있어 리소스를 효율적으로 관리할 수 있습니다.

전역 액세스: 싱글톤 패턴을 사용하면 전역적으로 액세스할 수 있는 공유 객체를 제공합니다. 이를 통해 전역 상태를 유지할 수 있으며, 여러 부분에서 동일한 서비스를 사용할 때 일관성을 유지할 수 있습니다.

초기화 제어: 싱글톤 패턴을 사용하면 클래스의 인스턴스 생성 및 초기화를 제어할 수 있습니다. 이를 통해 프로그램의 시작 시점에 인스턴스를 생성하거나, 필요에 따라 지연 초기화를 수행할 수 있습니다.

메모리 효율성: 인스턴스가 하나만 생성되므로 메모리 사용량이 줄어듭니다. 이는 메모리를 효율적으로 사용할 수 있게 해 주며, 동일한 서비스에 대해 여러 인스턴스를 생성하는 것보다 메모리 낭비를 줄일 수 있습니다.

DioServices에서 싱글톤 패턴을 사용하면 동일한 설정 및 인터셉터를 사용하는 Dio 객체를 여러 곳에서 공유할 수 있습니다. 이를 통해 코드의 일관성과 효율성을 높일 수 있으며, 메모리 사용량도 줄일 수 있습니다.
*/