import 'package:flutter/material.dart';
import 'auth_color_scheme.dart';

/// Configuration class for customizing the pre-built auth screens.
///
/// Use [enableEmailPassword], [enableGoogle], and [enableOtp] to control
/// which sign-in methods are shown. When more than one method is enabled,
/// the screen automatically switches to a tab-bar layout.
///
/// ### Background customisation
/// The whole screen is rendered as a [Stack]. You can supply any of the
/// following to control what appears behind the auth content:
///
/// | Option | Effect |
/// |---|---|
/// | [backgroundColor] | Solid colour fill |
/// | [backgroundGradient] | Gradient fill |
/// | [backgroundImage] | [DecorationImage] (asset / network) |
/// | [backgroundWidget] | Arbitrary widget drawn as the bottom layer |
///
/// If none are provided the screen defaults to a plain white background.
///
/// ### Header customisation
/// The header section (where the lock icon lives by default) is fully
/// customisable:
///
/// | Option | Effect |
/// |---|---|
/// | [headerBackground] | Background [Decoration] for the header bar (replaces the blue gradient) |
/// | [headerBackgroundWidget] | Widget drawn behind the header content |
/// | [headerLogoWidget] | Replaces the default lock icon |
/// | [headerTitleStyle] | [TextStyle] for the header title |
/// | [headerSubtitleStyle] | [TextStyle] for the header subtitle |
/// | [showHeaderDecorations] | Set `false` to hide the subtle circle overlays |
///
/// Example — image background, custom logo, no blue:
/// ```dart
/// AuthLoginScreen(
///   config: AuthUIConfig(
///     enableEmailPassword: true,
///     backgroundImage: DecorationImage(
///       image: AssetImage('assets/bg.jpg'),
///       fit: BoxFit.cover,
///     ),
///     headerBackground: BoxDecoration(color: Colors.transparent),
///     headerLogoWidget: FlutterLogo(size: 40),
///   ),
///   onSuccess: () {},
/// )
/// ```
class AuthUIConfig {
  // ── Color scheme ───────────────────────────────────────────────────────

  /// Override individual colours used across all auth widgets.
  ///
  /// See [AuthColorScheme] for the full list of customisable tokens.
  ///
  /// Example:
  /// ```dart
  /// AuthUIConfig(
  ///   colorScheme: AuthColorScheme(
  ///     primary: Colors.teal,
  ///     buttonColor: Colors.teal,
  ///     cardColor: Colors.white,
  ///   ),
  /// )
  /// ```
  final AuthColorScheme colorScheme;

  // ── Sign-in method toggles ──────────────────────────────────────────────

  /// Show the email / password sign-in method. Defaults to `true`.
  final bool enableEmailPassword;

  /// Show the Google sign-in method. Defaults to `false`.
  final bool enableGoogle;

  /// Show the phone OTP sign-in method. Defaults to `false`.
  final bool enableOtp;

  // ── Screen background ───────────────────────────────────────────────────

  /// Solid background colour for the whole screen.
  /// Ignored when [backgroundGradient], [backgroundImage], or
  /// [backgroundWidget] is set.
  final Color? backgroundColor;

  /// Gradient background for the whole screen.
  /// Ignored when [backgroundImage] or [backgroundWidget] is set.
  final Gradient? backgroundGradient;

  /// Background image for the whole screen (asset or network).
  /// Ignored when [backgroundWidget] is set.
  final DecorationImage? backgroundImage;

  /// Arbitrary widget placed as the bottommost layer of the [Stack].
  /// Overrides all other background options.
  final Widget? backgroundWidget;

  // ── Header customisation ────────────────────────────────────────────────

  /// [Decoration] applied to the header container.
  ///
  /// Set to `BoxDecoration(color: Colors.transparent)` to make the header
  /// blend into your custom background. Defaults to the built-in blue
  /// gradient when `null`.
  final Decoration? headerBackground;

  /// Widget drawn behind the header text content.
  /// When provided, [headerBackground] is ignored.
  final Widget? headerBackgroundWidget;

  /// Widget shown in place of the default lock icon.
  ///
  /// Example: `Image.asset('assets/logo.png', width: 52, height: 52)`
  final Widget? headerLogoWidget;

  /// Text style for the header title (e.g. "Welcome Back").
  final TextStyle? headerTitleStyle;

  /// Text style for the header subtitle.
  final TextStyle? headerSubtitleStyle;

  /// Whether to render the subtle decorative circles in the header.
  /// Defaults to `true`.
  final bool showHeaderDecorations;

  // ── Custom widget overrides ─────────────────────────────────────────────

  /// Custom widget to replace the default email input field.
  final Widget? emailField;

  /// Custom widget to replace the default password input field.
  final Widget? passwordField;

  /// Custom widget to replace the default name input field (signup only).
  final Widget? nameField;

  /// Custom widget to replace the default login button.
  final Widget? loginButton;

  /// Custom widget to replace the default signup button.
  final Widget? signupButton;

  /// Custom widget to replace the default Google sign-in button.
  final Widget? googleButton;

  /// Custom widget to replace the default phone number input field.
  final Widget? phoneField;

  /// Custom widget to replace the default OTP input field.
  final Widget? otpField;

  /// Custom widget to replace the default send OTP button.
  final Widget? sendOtpButton;

  /// Custom widget to replace the default verify OTP button.
  final Widget? verifyOtpButton;

  // ── Custom validators ───────────────────────────────────────────────────

  /// Custom validator for the email field.
  final String? Function(String?)? emailValidator;

  /// Custom validator for the password field.
  final String? Function(String?)? passwordValidator;

  /// Custom validator for the name field.
  final String? Function(String?)? nameValidator;

  const AuthUIConfig({
    // Color scheme
    this.colorScheme = const AuthColorScheme(),
    // Auth methods
    this.enableEmailPassword = true,
    this.enableGoogle = false,
    this.enableOtp = false,
    // Screen background
    this.backgroundColor,
    this.backgroundGradient,
    this.backgroundImage,
    this.backgroundWidget,
    // Header
    this.headerBackground,
    this.headerBackgroundWidget,
    this.headerLogoWidget,
    this.headerTitleStyle,
    this.headerSubtitleStyle,
    this.showHeaderDecorations = true,
    // Field / button overrides
    this.emailField,
    this.passwordField,
    this.nameField,
    this.loginButton,
    this.signupButton,
    this.googleButton,
    this.phoneField,
    this.otpField,
    this.sendOtpButton,
    this.verifyOtpButton,
    // Validators
    this.emailValidator,
    this.passwordValidator,
    this.nameValidator,
  });

  /// Returns the list of enabled method labels in display order.
  List<AuthMethod> get enabledMethods {
    return [
      if (enableEmailPassword) AuthMethod.emailPassword,
      if (enableOtp) AuthMethod.otp,
      if (enableGoogle) AuthMethod.google,
    ];
  }

  /// Resolves the screen [BoxDecoration] from the provided background options.
  /// Priority: [backgroundWidget] > [backgroundImage] > [backgroundGradient]
  /// > [backgroundColor] > white.
  BoxDecoration resolveScreenDecoration() {
    if (backgroundWidget != null) return const BoxDecoration();
    if (backgroundImage != null) {
      return BoxDecoration(
        image: backgroundImage,
        gradient: backgroundGradient,
        color: backgroundColor,
      );
    }
    if (backgroundGradient != null) {
      return BoxDecoration(gradient: backgroundGradient);
    }
    if (backgroundColor != null) {
      return BoxDecoration(color: backgroundColor);
    }
    // default — plain white
    return const BoxDecoration(color: Colors.white);
  }
}

/// Enum representing each supported sign-in method.
enum AuthMethod { emailPassword, otp, google }
