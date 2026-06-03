/// Firebase Auth Kit — pre-built Firebase authentication UI and services
/// for Flutter.
///
/// Provides ready-to-use login and signup screens with support for
/// email/password, Google Sign-In, and phone OTP authentication.
///
/// ## Quick start
///
/// ```dart
/// import 'package:firebase_auth_kit/firebase_auth_kit.dart';
///
/// AuthLoginScreen(
///   onSuccess: () => Navigator.pushReplacementNamed(context, '/home'),
/// )
/// ```
library firebase_auth_kit;

export 'src/core/auth_controller.dart';
export 'src/ui/login_screen.dart';
export 'src/ui/signup_screen.dart';
export 'src/ui/config/auth_ui_config.dart';
export 'src/ui/config/auth_color_scheme.dart';
export 'src/ui/theme/auth_theme.dart';
export 'src/utils/validators.dart';
