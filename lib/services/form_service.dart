/// Service class for interacting with Form.io form endpoints.
///
/// Provides methods to fetch form definitions from the Form.io backend,
/// either as a list of available forms or a single form by its path or ID.

import 'package:dio/dio.dart';

import '../models/form.dart';
import '../network/api_client.dart';

class FormService {
  /// An instance of the API client to make HTTP requests.
  final ApiClient client;

  /// Constructs a [FormService] using the provided [ApiClient].
  FormService(this.client);

  /// Fetches all available forms from the Form.io backend.
  ///
  /// Makes a `GET /form` request.
  ///
  /// Returns a list of [FormModel] objects.
  ///
  /// Throws [DioException] on failure.
  Future<List<FormModel>> fetchForms() async {
    try {
      final response = await client.dio.get('/form');
      if (response.data is List<dynamic>) {
        final data = response.data as List<dynamic>;
        return data.map((json) => FormModel.fromJson(json as Map<String, dynamic>)).toList();
      }

      // handle response
    } on DioException {
      // Log DioException details for debugging
      rethrow;
    } catch (e) {
      // Log other exceptions for debugging
      rethrow;
    }
    throw 'Failed to fetch forms';
  }

  /// Fetches a single form using its path or ID from Form.io.
  ///
  /// Makes a `GET /form/:pathOrId` request.
  ///
  /// [pathOrId] can be either the `path` of the form (recommended) or its `_id`.
  ///
  /// Returns a [FormModel] object.
  ///
  /// Throws [DioException] on failure.
  Future<FormModel> getFormByPath(String pathOrId) async {
    final response = await client.dio.get('/form/$pathOrId');
    return FormModel.fromJson(response.data as Map<String, dynamic>);
  }
}
