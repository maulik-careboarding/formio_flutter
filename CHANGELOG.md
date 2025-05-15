# Changelog

All notable changes to this project will be documented in this file.

This project follows [Semantic Versioning](https://semver.org).

---

## [0.1.0] - 2025-05-15

### ✨ Added
- Initial release of `formio`.
- ✅ Dynamic rendering of Form.io components:
  - Basic components: `textfield`, `textarea`, `number`, `checkbox`, `select`, `radio`, `button`, etc.
  - Advanced components: `datetime`, `currency`, `signature`, `survey`, `day`, `time`, etc.
  - Layout components: `panel`, `tabs`, `columns`, `well`, `fieldset`, `table`, etc.
  - Data components: `container`, `datagrid`, `editgrid`, `datamap`, `hidden`.
  - Premium components: `file`, `nestedform`, `captcha`.
  - Custom component placeholder with `customBuilder` support.
- 🔧 ComponentFactory for dynamic widget instantiation.
- 📤 Form submission via `SubmissionService`.
- 📡 API service integration using Dio.
- 📦 `FormRenderer` widget with:
  - Validation
  - Submission
  - Custom error handling
- 🧠 `FormProvider` with `ChangeNotifier` support.
- 📄 Project-level documentation:
  - `README.md`
  - `LICENSE` (MIT, Spinex.io)
  - `CHANGELOG.md`

---

## [Unreleased]

### 🚧 Upcoming
- Field-level validation rules (min/max, regex, custom logic)
- Conditional rendering based on form state
- File uploads with backend support
- Offline saving / draft mode
- Internationalization (i18n) and localization

---

