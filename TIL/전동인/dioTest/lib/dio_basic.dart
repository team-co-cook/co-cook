import 'package:dio/dio.dart';

//유형별 dio 요청 방법

// get
Dio _dio = Dio();
await _dio.get($url);

// post
Dio _dio = Dio();
Map<String, dynamic> _data = {
  "test" : 1,
  "test2" : 2,
};
await _dio.post($url,data:_data);

// put
Dio _dio = Dio();
Map<String, dynamic> _data = {
  "test" : 1,
  "test2" : 2,
};
await _dio.put($url,data:_data);

// delete
Dio _dio = Dio();
Map<String, dynamic> _data = {
  "test" : 1,
  "test2" : 2,
};
await _dio.delete($url,data:_data);