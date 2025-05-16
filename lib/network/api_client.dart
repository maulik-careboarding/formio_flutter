import 'package:dio/dio.dart';

class ApiClient {
  /// Static base URL shared across all instances.
  static Uri _baseUrl = Uri.parse('https://your-formio-url.com');

  /// Dio instance used for making HTTP requests.
  late final Dio dio;

  /// Allows setting the base URL once. Future instances use the same.
  static void setBaseUrl(Uri url) {
    _baseUrl = url;
  }

  /// Returns the currently set base URL.
  static Uri get baseUrl => _baseUrl;

  /// Creates a new instance of [ApiClient] using the shared base URL.
  ApiClient() {
    dio = Dio(BaseOptions(
      baseUrl: _baseUrl.toString(),
      headers: {'Content-Type': 'application/json'},
    ));
  }

  void setAuthToken(String token) {
    dio.options.headers['x-jwt-token'] = token;
  }

  void clearAuthToken() {
    dio.options.headers.remove('x-jwt-token');
  }

  Future<Response<Map<String, dynamic>>> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) {
    return dio.get(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<Map<String, dynamic>>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) {
    return dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }
}
