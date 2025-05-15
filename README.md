# 📦 formio_flutter

A dynamic Form.io renderer for Flutter. This package allows you to render and submit Form.io forms directly in your Flutter app using native widgets — including support for all standard, advanced, data, layout, and premium components.

---

## ✨ Features

- ✅ Renders Form.io JSON forms into native Flutter widgets
- ✅ Supports dynamic form structure, validation, and conditional fields
- ✅ Handles all core Form.io components:
  - Basic (textfield, checkbox, radio, select, etc.)
  - Advanced (datetime, day, currency, survey, signature)
  - Data (datagrid, container, hidden, editgrid)
  - Layout (panel, tabs, columns, table, well)
  - Premium (file, nestedform, captcha)
- 📡 Built-in API client using Dio
- 🧠 FormProvider for state management
- 📤 Submission support via `SubmissionService`

---

## 📦 Installation

Add the dependency in your `pubspec.yaml`:

```yaml
dependencies:
  formio_flutter:
    git:
      url: https://github.com/mskayali/formio_flutter.git
```
## 🛠️ Getting Started

1. Fetch a Form from Form.io
```dart
final formService = FormService(ApiClient());
final form = await formService.getFormByPath('/contact');
```

2. Render the Form

```dart
FormRenderer(
  form: form,
  onChanged: (data) => print('Current values: $data'),
  onSubmit: (data) => print('Submitted: $data'),
  onError: (err) => print('Failed: $err'),
)
```

## 🧱 Project Structure

```bash
lib/
├── formio_flutter.dart         # Library entry point
├── models/                     # Form, component, submission models
├── services/                   # API services
├── widgets/                    # Components + FormRenderer
├── core/                       # Constants, utils, exceptions
├── network/                    # API client + endpoints
└── providers/                 # Optional form state provider
```
### 📤 Submitting Data
Handled automatically by FormRenderer when a "submit" button is tapped.

If using manually:

```dart
final submissionService = SubmissionService(ApiClient());
await submissionService.submit('/contact', {
  'name': 'John',
  'email': 'john@example.com',
});
```

## Example

```dart
MaterialApp(
  home: Scaffold(
    body: FutureBuilder<FormModel>(
      future: FormService(ApiClient()).getFormByPath('/feedback'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return Padding(
          padding: EdgeInsets.all(16),
          child: FormRenderer(form: snapshot.data!),
        );
      },
    ),
  ),
);
```

### 🔧 Roadmap
 - [x] Core components

 - [x] Layout and advanced components

 - [x] Form submission support

 - [ ] Conditional logic

 - [ ] Validation rules (regex, min/max, etc.)

 - [ ] Multi-page forms

 - [ ] Offline support / caching

### 🤝 Contributing
Pull requests, issues and feedback are welcome. Please open an issue first for major changes.

