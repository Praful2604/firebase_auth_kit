import 'package:flutter/material.dart';
import '../theme/auth_theme.dart';


class AuthColorScheme {
  // ── Brand ──────────────────────────────────────────────────────────────

  /// Primary accent colour — used for focused borders, links, icons.
  final Color? primary;

  /// Secondary accent (gradient end, highlights).
  final Color? primaryLight;

  /// Gradient applied to the primary [AuthButton].
  /// Falls back to a gradient from [primary] → [primaryLight] when null.
  final LinearGradient? primaryGradient;

  // ── Button ─────────────────────────────────────────────────────────────

  /// Solid colour for the primary action button.
  /// Ignored when [primaryGradient] is set.
  final Color? buttonColor;

  /// Text colour on the primary button. Defaults to white.
  final Color? buttonTextColor;

  /// Shadow colour under the primary button.
  final Color? buttonShadowColor;

  // ── Card ───────────────────────────────────────────────────────────────

  /// Background colour of the form card. Defaults to white.
  final Color? cardColor;

  /// Shadow colour of the form card.
  final Color? cardShadowColor;

  // ── Input fields ───────────────────────────────────────────────────────

  /// Fill colour of text inputs. Defaults to a light lavender.
  final Color? inputFillColor;

  /// Border colour of unfocused inputs.
  final Color? inputBorderColor;

  /// Border colour of focused inputs.
  final Color? inputFocusBorderColor;

  /// Prefix icon + label colour when an input is focused.
  final Color? inputFocusIconColor;

  // ── Text ───────────────────────────────────────────────────────────────

  /// Primary text colour (input values, headings).
  final Color? textPrimaryColor;

  /// Secondary text colour (subtitles, captions).
  final Color? textSecondaryColor;

  /// Hint / placeholder text colour.
  final Color? textHintColor;

  /// Colour of tappable links ("Forgot password?", "Sign Up").
  final Color? linkColor;

  // ── Error ──────────────────────────────────────────────────────────────

  /// Error text and icon colour.
  final Color? errorColor;

  /// Background of the error banner.
  final Color? errorContainerColor;

  // ── OTP ────────────────────────────────────────────────────────────────

  /// Colour of the phone/OTP icon circle background.
  final Color? otpIconColor;

  const AuthColorScheme({
    this.primary,
    this.primaryLight,
    this.primaryGradient,
    this.buttonColor,
    this.buttonTextColor,
    this.buttonShadowColor,
    this.cardColor,
    this.cardShadowColor,
    this.inputFillColor,
    this.inputBorderColor,
    this.inputFocusBorderColor,
    this.inputFocusIconColor,
    this.textPrimaryColor,
    this.textSecondaryColor,
    this.textHintColor,
    this.linkColor,
    this.errorColor,
    this.errorContainerColor,
    this.otpIconColor,
  });

  // ── Resolved getters (fall back to AuthTheme defaults) ─────────────────

  Color get resolvedPrimary => primary ?? AuthTheme.primary;
  Color get resolvedPrimaryLight => primaryLight ?? AuthTheme.primaryLight;

  LinearGradient get resolvedButtonGradient =>
      primaryGradient ??
      (buttonColor != null
          ? LinearGradient(colors: [buttonColor!, buttonColor!])
          : LinearGradient(
              colors: [resolvedPrimary, resolvedPrimaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ));

  Color get resolvedButtonTextColor => buttonTextColor ?? Colors.white;

  List<BoxShadow> get resolvedButtonShadow => [
        BoxShadow(
          color: (buttonShadowColor ?? resolvedPrimary).withValues(alpha: 0.35),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  Color get resolvedCardColor => cardColor ?? AuthTheme.surface;

  List<BoxShadow> get resolvedCardShadow => [
        BoxShadow(
          color: (cardShadowColor ?? resolvedPrimary).withValues(alpha: 0.08),
          blurRadius: 32,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  Color get resolvedInputFill => inputFillColor ?? AuthTheme.inputFill;
  Color get resolvedInputBorder => inputBorderColor ?? AuthTheme.inputBorder;
  Color get resolvedInputFocusBorder =>
      inputFocusBorderColor ?? resolvedPrimary;
  Color get resolvedInputFocusIcon => inputFocusIconColor ?? resolvedPrimary;

  Color get resolvedTextPrimary => textPrimaryColor ?? AuthTheme.textPrimary;
  Color get resolvedTextSecondary =>
      textSecondaryColor ?? AuthTheme.textSecondary;
  Color get resolvedTextHint => textHintColor ?? AuthTheme.textHint;
  Color get resolvedLink => linkColor ?? resolvedPrimary;

  Color get resolvedError => errorColor ?? AuthTheme.error;
  Color get resolvedErrorContainer =>
      errorContainerColor ?? AuthTheme.errorContainer;

  Color get resolvedOtpIcon => otpIconColor ?? resolvedPrimary;
}
