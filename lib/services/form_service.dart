/// Service class for interacting with Form.io form endpoints.
///
/// Provides methods to fetch form definitions from the Form.io backend,
/// either as a list of available forms or a single form by its path or ID.

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
  /// Throws [DioError] on failure.
  Future<List<FormModel>> fetchForms() async {
    final response = await client.dio.get('/form');
    final data = response.data as List<dynamic>;

    return data.map((json) => FormModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Fetches a single form using its path or ID from Form.io.
  ///
  /// Makes a `GET /form/:pathOrId` request.
  ///
  /// [pathOrId] can be either the `path` of the form (recommended) or its `_id`.
  ///
  /// Returns a [FormModel] object.
  ///
  /// Throws [DioError] on failure.
  Future<FormModel> getFormByPath(String pathOrId) async {
    final response = await client.dio.get('/form/$pathOrId');
    return FormModel.fromJson(response.data as Map<String, dynamic>);
  }
}
