/// Centralized API endpoint definitions for Form.io operations.
///
/// These helper functions and constants provide consistent paths
/// for use in services such as FormService, SubmissionService, etc.

class ApiEndpoints {
  /// Returns the full path to fetch a form schema.
  /// Example: `/registration`
  static String getForm(String path) => path;

  /// Returns the path to create a new submission.
  /// Example: `/registration/submission`
  static String postSubmission(String formPath) => '$formPath/submission';

  /// Returns the path to fetch a specific submission.
  static String getSubmissionById(String formPath, String id) => '$formPath/submission/$id';

  /// Returns the login endpoint (if using Form.io authentication).
  static const String login = '/user/login';

  /// Returns the registration endpoint.
  static const String register = '/user/register';

  /// Returns the current user profile endpoint.
  static const String currentUser = '/user/me';

  /// Returns a path to fetch project or form-level configuration.
  static const String projectConfig = '/project';
}
