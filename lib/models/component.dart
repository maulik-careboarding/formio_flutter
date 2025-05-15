/// Represents a generic Form.io component (form field or layout element).
///
/// Each component defines its type (e.g., textfield, checkbox), key,
/// label, validation rules, and other configuration options.
/// This model serves as the base for dynamically rendering components
/// in a Flutter form UI.

class ComponentModel {
  /// Type of the component (e.g., "textfield", "select", "checkbox").
  final String type;

  /// Key identifier used for mapping form data.
  final String key;

  /// Display label shown on the UI.
  final String label;

  /// Whether this component is required to be filled by the user.
  final bool required;

  /// The default value for the component, if any.
  final dynamic defaultValue;

  /// The original raw JSON structure of the component.
  ///
  /// Useful for accessing custom or advanced properties not explicitly modeled.
  final Map<String, dynamic> raw;

  /// Constructs a [ComponentModel] with the given properties.
  ComponentModel({required this.type, required this.key, required this.label, required this.required, this.defaultValue, required this.raw});

  /// Creates a [ComponentModel] instance from a JSON object.
  ///
  /// This function maps essential fields such as `type`, `key`, `label`,
  /// and `validate.required` from Form.io's component JSON.
  factory ComponentModel.fromJson(Map<String, dynamic> json) {
    return ComponentModel(
      type: json['type'] as String,
      key: json['key'] as String,
      label: json['label'] ?? '',
      required: json['validate']?['required'] ?? false,
      defaultValue: json['defaultValue'],
      raw: json,
    );
  }

  /// Converts this [ComponentModel] instance into a JSON-compatible map.
  ///
  /// The original `raw` JSON is returned here to preserve full structure.
  Map<String, dynamic> toJson() => raw;
}
