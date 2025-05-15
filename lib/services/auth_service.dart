/// Service class for authenticating users against the Form.io API.
///
/// Handles login operations and token retrieval for secure communication
/// with protected Form.io endpoints.

import '../models/user.dart';
import '../network/api_client.dart';

class AuthService {
  /// An instance of the API client to perform HTTP operations.
  final ApiClient client;

  /// Constructs an [AuthService] using the provided [ApiClient].
  AuthService(this.client);

  /// Logs a user in to the Form.io project.
  ///
  /// Sends a `POST /user/login` request with the user's email and password.
  ///
  /// On success, returns a [UserModel] with the JWT token and user ID populated.
  ///
  /// Example:
  /// ```dart
  /// final user = UserModel(email: 'test@example.com', password: '1234');
  /// final response = await authService.login(user);
  /// ```
  ///
  /// Throws [DioError] on failure (invalid credentials, server error, etc).
  Future<UserModel> login(UserModel credentials) async {
    final response = await client.dio.post('/user/login', data: credentials.toLoginJson());

    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Optionally, implement logout or token refresh in future.
}
