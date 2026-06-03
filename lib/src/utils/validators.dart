/// A collection of reusable form validators for common authentication fields.
///
/// Use these directly with [TextFormField.validator] or pass them via
/// [AuthUIConfig] to override the defaults in the pre-built screens.
class AuthValidators {
  AuthValidators._();

  /// Validates that [value] is a non-empty, properly formatted email address.
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required.';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email address.';
    return null;
  }

  /// Validates that [value] is at least 6 characters long.
  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required.';
    if (value.length < 6) return 'Password must be at least 6 characters.';
    return null;
  }

  /// Validates that [value] is non-empty.
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required.';
    return null;
  }

  /// Validates that [value] matches [password].
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Please confirm your password.';
    if (value != password) return 'Passwords do not match.';
    return null;
  }
}
