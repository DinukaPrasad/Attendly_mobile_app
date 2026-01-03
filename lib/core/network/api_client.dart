import 'package:dio/dio.dart';

class ApiClient {
  ApiClient({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<Response<dynamic>> get(String path) {
    // TODO: implement API calls with proper endpoints.
    return _dio.get(path);
  }
}
