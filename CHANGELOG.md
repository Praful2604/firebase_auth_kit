# Changelog

## 0.1.2

* Added explicit `platforms` declaration (Android, iOS, Web, macOS) to fix pub.dev platform support score.
* Migrated `google_sign_in` usage to v7 API (`GoogleSignIn.instance`, `authenticate()`, `authorizationClient`).

## 0.1.1

* Updated dependencies to latest versions:
  * `firebase_core` → `^4.10.0`
  * `firebase_auth` → `^6.5.2`
  * `cloud_firestore` → `^6.5.0`
  * `google_sign_in` → `^7.2.0`

## 0.1.0

* **Breaking:** Bumped version to `0.1.0` — first public release on pub.dev.
* Redesigned UI with modern gradient header, glassmorphism accents, and 8px grid system.
* Added animated `AuthCard` (fade + slide on mount).
* Added animated `AuthButton` with press-scale feedback and gradient fill.
* Added `AuthErrorBanner` with entrance animation.
* Added `AuthDivider` helper widget.
* Improved `AuthTextField` with focus-glow shadow and animated label color.
* Added 6-box OTP input (`_OtpBoxes`) with auto-advance between digits.
* Added password strength indicator in the signup form.
* Added resend countdown timer in the OTP form.
* Added step-transition animation when switching phone → OTP entry.
* Introduced `AuthTheme` design-token class (colors, radii, shadows, gradients, typography).
* Tab bar redesigned as a pill-style container — no more overflow on small screens.
* `AuthHeader` now animates in with fade + slide.

## 0.0.1

* Initial release.
* Email/password login and signup screens with form validation.
* Google Sign-In support.
* Phone number OTP authentication.
* Fully customizable UI via `AuthUIConfig`.
* `AuthController` for programmatic access to all auth operations.
* `AuthValidators` utility class for reusable form validators.
