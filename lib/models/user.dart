/// Represents a user in the Form.io system, primarily for authentication.
///
/// This model is used for logging in, storing user credentials, and
/// handling JWT tokens returned from the Form.io authentication endpoint.

class UserModel {
  /// User's email address used for login.
  final String email;

  /// User's password used for login.
  final String password;

  /// JWT token issued upon successful authentication.
  final String? token;

  /// Unique ID of the user (if available).
  final String? userId;

  /// Constructs a [UserModel] instance for login or authentication tracking.
  UserModel({required this.email, required this.password, this.token, this.userId});

  /// Converts the user credentials into a JSON-compatible map for login.
  ///
  /// Only email and password are included in this request body.
  ///
  /// Example:
  /// ```json
  /// {
  ///   "data": {
  ///     "email": "john@example.com",
  ///     "password": "secure123"
  ///   }
  /// }
  /// ```
  Map<String, dynamic> toLoginJson() {
    return {
      'data': {'email': email, 'password': password},
    };
  }

  /// Creates a [UserModel] from a JSON response, usually from the auth API.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(email: json['data']?['email'] ?? '', password: '', token: json['token'], userId: json['user']?['_id']);
  }
}
