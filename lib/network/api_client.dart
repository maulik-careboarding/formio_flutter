/// A lightweight API client using Dio for interacting with Form.io endpoints.
///
/// This client handles base configuration, authorization token injection, and
/// shared headers for all HTTP requests.
import 'package:dio/dio.dart';

class ApiClient {
  /// Dio instance used for making HTTP requests.
  final Dio dio;

  /// Creates a new instance of [ApiClient].
  ///
  /// Optionally accepts a [baseUrl] for the Form.io backend.
  /// If not provided, it defaults to `https://your-formio-url.com`.
  ApiClient({String? baseUrl}) : dio = Dio(BaseOptions(baseUrl: baseUrl ?? 'https://your-formio-url.com', headers: {'Content-Type': 'application/json'}));

  /// Sets the JWT token to be used for authenticated requests.
  ///
  /// This method attaches the token to the `x-jwt-token` header.
  ///
  /// Example:
  /// ```dart
  /// client.setAuthToken('your-jwt-token');
  /// ```
  void setAuthToken(String token) {
    dio.options.headers['x-jwt-token'] = token;
  }

  /// Makes a GET request to the specified [endpoint] and returns the response.
  Future<Response<Map<String,dynamic>>> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) {
    return dio.get(
      path,
      data:data,
      queryParameters:queryParameters,
      options:options,
      cancelToken:cancelToken,
      onReceiveProgress:onReceiveProgress,
    );
  }

  /// Makes a POST request to the specified [endpoint] and returns the response.
  Future<Response<Map<String,dynamic>>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) {
    return dio.post(
      path,
      data:data,
      queryParameters:queryParameters,
      options:options,
      cancelToken:cancelToken,
      onReceiveProgress:onReceiveProgress,
    );
  }
  
  /// Removes the JWT token from headers.
  ///
  /// This method can be used during logout or token refresh events.
  void clearAuthToken() {
    dio.options.headers.remove('x-jwt-token');
  }
}
