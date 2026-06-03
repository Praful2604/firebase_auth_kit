import 'package:flutter/material.dart';

/// Design tokens for the auth kit UI.
///
/// All colors, radii, and spacing constants live here so every widget
/// stays visually consistent without hard-coding values.
class AuthTheme {
  // ── Brand palette ──────────────────────────────────────────────────────
  /// Deep indigo — primary actions, header gradient start.
  static const Color primary = Color(0xFF4F46E5);

  /// Violet — header gradient end, accents.
  static const Color primaryLight = Color(0xFF7C3AED);

  /// Soft lavender — tab indicator, subtle highlights.
  static const Color accent = Color(0xFFA78BFA);

  /// Pure white — text on dark surfaces.
  static const Color onPrimary = Color(0xFFFFFFFF);

  // ── Surface palette ────────────────────────────────────────────────────
  /// Off-white page background.
  static const Color background = Color(0xFFF8F7FF);

  /// Card / form surface.
  static const Color surface = Color(0xFFFFFFFF);

  /// Input fill — very light lavender tint.
  static const Color inputFill = Color(0xFFF3F2FF);

  /// Subtle border on inputs.
  static const Color inputBorder = Color(0xFFE0DEFF);

  /// Focused input border.
  static const Color inputBorderFocused = Color(0xFF4F46E5);

  // ── Text palette ───────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);

  // ── Semantic ───────────────────────────────────────────────────────────
  static const Color error = Color(0xFFEF4444);
  static const Color errorContainer = Color(0xFFFEF2F2);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF10B981);

  // ── Geometry ───────────────────────────────────────────────────────────
  static const double radiusXS = 8.0;
  static const double radiusSM = 12.0;
  static const double radiusMD = 16.0;
  static const double radiusLG = 24.0;
  static const double radiusXL = 32.0;

  // ── Elevation / shadow ─────────────────────────────────────────────────
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0xFF4F46E5).withValues(alpha: 0.08),
          blurRadius: 32,
          spreadRadius: 0,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get buttonShadow => [
        BoxShadow(
          color: const Color(0xFF4F46E5).withValues(alpha: 0.35),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  // ── Header gradient ────────────────────────────────────────────────────
  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Subtle diagonal gradient for the page background.
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFF8F7FF), Color(0xFFEDE9FE)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ── Typography ─────────────────────────────────────────────────────────
  static const TextStyle displayLarge = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    color: onPrimary,
    letterSpacing: -0.8,
    height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.4,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: onPrimary,
    height: 1.5,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.6,
  );

  static const TextStyle label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: textSecondary,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );

  // ── Legacy API (kept for backward compat) ──────────────────────────────
  final Color primaryColor;
  final Color backgroundColor;

  const AuthTheme({
    this.primaryColor = primary,
    this.backgroundColor = background,
  });
}
