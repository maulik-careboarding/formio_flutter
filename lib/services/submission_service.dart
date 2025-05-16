/// A service for managing form submissions with Form.io's API.
///
/// Supports creating new submissions and optionally fetching existing ones
/// using the REST endpoints `/form/:path/submission`.

import '../core/exceptions.dart';
import '../models/submission.dart';
import '../network/api_client.dart';
import '../network/endpoints.dart';

class SubmissionService {
  /// API client used to make HTTP requests.
  final ApiClient client;

  SubmissionService(this.client);

  /// Sends a new form submission to the given form path.
  ///
  /// [formPath] is the full path to the form (e.g. '/registration')
  /// [data] is the map of form field values.
  ///
  /// Throws [SubmissionException] on error.
  Future<SubmissionModel> submit(String formPath, Map<String, dynamic> data) async {
    try {
      final url = ApiEndpoints.postSubmission(formPath);
      final response = await client.dio.post(url, data: {'data': data});
      return SubmissionModel.fromJson(response.data ?? {});
    } catch (e) {
      throw SubmissionException('Failed to submit form: $e');
    }
  }

  /// (Optional) Fetches a submission by its ID under a form.
  ///
  /// Useful for edit/view workflows.
  Future<SubmissionModel> fetchById(String formPath, String submissionId) async {
    try {
      final response = await client.dio.get('$formPath/submission/$submissionId');
      return SubmissionModel.fromJson(response.data ?? {});
    } catch (e) {
      throw SubmissionException('Failed to fetch submission: $e');
    }
  }
}
