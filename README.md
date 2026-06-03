# firebase_auth_kit

Ready-to-use Firebase authentication UI for Flutter. Drop-in login and signup screens with email/password, Google Sign-In, and phone OTP — fully customisable via a single config object.

---

## Features

- ✅ Email / Password sign-in and sign-up
- ✅ Google Sign-In
- ✅ Phone OTP verification
- ✅ Auto tab-bar layout when multiple methods are enabled
- ✅ Fully customisable background — solid colour, gradient, image, or any widget
- ✅ Transparent header — blends into your own background
- ✅ Custom logo / icon in the header
- ✅ Custom colours for every UI element via `AuthColorScheme`
- ✅ Custom validators for every input field
- ✅ Replace any individual field or button with your own widget
- ✅ No named routes required — navigation is callback-based

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  firebase_auth_kit: ^0.1.0
```

Then run:

```sh
flutter pub get
```

---

## Firebase Setup

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable **Authentication** and the sign-in methods you need
3. Add your app using the [FlutterFire CLI](https://firebase.flutter.dev/docs/cli):

```sh
dart pub global activate flutterfire_cli
flutterfire configure
```

4. Initialise Firebase in `main()`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}
```

---

## Quick Start

```dart
import 'package:firebase_auth_kit/firebase_auth_kit.dart';

AuthLoginScreen(
  config: const AuthUIConfig(
    enableEmailPassword: true,
    enableGoogle: true,
    enableOtp: true,
  ),
  onSuccess: () => Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const HomeScreen()),
  ),
  onSignupTap: () => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (ctx) => AuthSignupScreen(
        config: const AuthUIConfig(enableEmailPassword: true),
        onSuccess: () => Navigator.pushAndRemoveUntil(
          ctx,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (_) => false,
        ),
        onLoginTap: () => Navigator.pop(ctx),
      ),
    ),
  ),
)
```

---

## Using as a Stack (Recommended)

Both screens are rendered as a `Stack` internally so you can place any background widget behind them.

```dart
Scaffold(
  body: Stack(
    fit: StackFit.expand,
    children: [
      // Layer 0 — your background
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),

      // Layer 1 — auth screen (transparent so background shows through)
      AuthLoginScreen(
        config: const AuthUIConfig(
          enableEmailPassword: true,
          backgroundColor: Colors.transparent,
          headerBackground: BoxDecoration(color: Colors.transparent),
        ),
        onSuccess: () { /* navigate to home */ },
      ),
    ],
  ),
)
```

---

## AuthUIConfig Reference

Pass `AuthUIConfig` to the `config` parameter of `AuthLoginScreen` or `AuthSignupScreen`.

### Auth Methods

| Field | Type | Default | Description |
|---|---|---|---|
| `enableEmailPassword` | `bool` | `true` | Show email/password sign-in |
| `enableGoogle` | `bool` | `false` | Show Google sign-in |
| `enableOtp` | `bool` | `false` | Show phone OTP sign-in |

### Screen Background

| Field | Type | Description |
|---|---|---|
| `backgroundColor` | `Color?` | Solid background colour |
| `backgroundGradient` | `Gradient?` | Gradient background |
| `backgroundImage` | `DecorationImage?` | Asset or network image background |
| `backgroundWidget` | `Widget?` | Any widget as background (highest priority) |

Priority order: `backgroundWidget` → `backgroundImage` → `backgroundGradient` → `backgroundColor` → white (default)

### Header

| Field | Type | Default | Description |
|---|---|---|---|
| `headerBackground` | `Decoration?` | Blue gradient | Header container decoration. Use `BoxDecoration(color: Colors.transparent)` to blend into your background |
| `headerBackgroundWidget` | `Widget?` | — | Widget drawn behind the header content |
| `headerLogoWidget` | `Widget?` | Lock icon | Replaces the default lock icon. Use `SizedBox.shrink()` to hide it |
| `headerTitleStyle` | `TextStyle?` | White bold | Text style for the title |
| `headerSubtitleStyle` | `TextStyle?` | White regular | Text style for the subtitle |
| `showHeaderDecorations` | `bool` | `true` | Set `false` to hide the decorative circle overlays |

### Color Scheme

| Field | Type | Description |
|---|---|---|
| `colorScheme` | `AuthColorScheme` | Override any widget colour — see [AuthColorScheme Reference](#authcolorscheme-reference) |

### Widget Overrides

Replace any individual UI element with your own widget:

| Field | Replaces |
|---|---|
| `emailField` | Email input |
| `passwordField` | Password input |
| `nameField` | Name input (signup only) |
| `loginButton` | Sign In button |
| `signupButton` | Create Account button |
| `googleButton` | Google sign-in button |
| `phoneField` | Phone number input |
| `otpField` | OTP input boxes |
| `sendOtpButton` | Send OTP button |
| `verifyOtpButton` | Verify OTP button |

### Custom Validators

| Field | Validates |
|---|---|
| `emailValidator` | `String? Function(String?)` |
| `passwordValidator` | `String? Function(String?)` |
| `nameValidator` | `String? Function(String?)` |

---

## AuthColorScheme Reference

Pass to `AuthUIConfig(colorScheme: AuthColorScheme(...))`. Every field is optional — unset fields fall back to the default indigo/violet palette.

### Brand

| Field | Type | Description |
|---|---|---|
| `primary` | `Color?` | Primary accent — focus borders, icons, links |
| `primaryLight` | `Color?` | Secondary accent — gradient end, highlights |
| `primaryGradient` | `LinearGradient?` | Full custom gradient for the action button |

### Button

| Field | Type | Description |
|---|---|---|
| `buttonColor` | `Color?` | Solid button colour (used when no gradient set) |
| `buttonTextColor` | `Color?` | Button label and spinner colour |
| `buttonShadowColor` | `Color?` | Glow shadow under the button |

### Card

| Field | Type | Description |
|---|---|---|
| `cardColor` | `Color?` | Form card background colour |
| `cardShadowColor` | `Color?` | Card shadow tint |

### Input Fields

| Field | Type | Description |
|---|---|---|
| `inputFillColor` | `Color?` | Input background fill |
| `inputBorderColor` | `Color?` | Unfocused input border |
| `inputFocusBorderColor` | `Color?` | Focused input border |
| `inputFocusIconColor` | `Color?` | Focused prefix icon and label colour |

### Text

| Field | Type | Description |
|---|---|---|
| `textPrimaryColor` | `Color?` | Input values, headings |
| `textSecondaryColor` | `Color?` | Subtitles, captions |
| `textHintColor` | `Color?` | Placeholder and hint text |
| `linkColor` | `Color?` | Tappable links ("Forgot password?", "Sign Up") |

### Error

| Field | Type | Description |
|---|---|---|
| `errorColor` | `Color?` | Error text and icon |
| `errorContainerColor` | `Color?` | Error banner background |

### OTP

| Field | Type | Description |
|---|---|---|
| `otpIconColor` | `Color?` | Phone/OTP icon circle colour |

---

## Examples

### Solid colour background

```dart
AuthLoginScreen(
  config: const AuthUIConfig(
    enableEmailPassword: true,
    backgroundColor: Color(0xFF0F172A),
    headerBackground: BoxDecoration(color: Colors.transparent),
    headerTitleStyle: TextStyle(color: Colors.white, fontSize: 28,
        fontWeight: FontWeight.w800),
    headerSubtitleStyle: TextStyle(color: Colors.white60),
    headerLogoWidget: SizedBox.shrink(),
  ),
  onSuccess: () { /* navigate */ },
)
```

### Image background

```dart
AuthLoginScreen(
  config: const AuthUIConfig(
    enableEmailPassword: true,
    backgroundImage: DecorationImage(
      image: AssetImage('assets/bg.jpg'),
      fit: BoxFit.cover,
    ),
    headerBackground: BoxDecoration(color: Colors.transparent),
    headerLogoWidget: SizedBox.shrink(),
  ),
  onSuccess: () { /* navigate */ },
)
```

### Custom colour scheme

```dart
AuthLoginScreen(
  config: const AuthUIConfig(
    enableEmailPassword: true,
    colorScheme: AuthColorScheme(
      primary: Color(0xFF0D9488),
      buttonColor: Color(0xFF0D9488),
      buttonShadowColor: Color(0xFF0D9488),
      inputFillColor: Color(0xFFF0FDFA),
      inputBorderColor: Color(0xFF99F6E4),
      inputFocusBorderColor: Color(0xFF0D9488),
      linkColor: Color(0xFF0D9488),
      cardColor: Colors.white,
      textPrimaryColor: Color(0xFF134E4A),
    ),
  ),
  onSuccess: () { /* navigate */ },
)
```

### Custom logo and button gradient

```dart
AuthLoginScreen(
  config: AuthUIConfig(
    enableEmailPassword: true,
    headerLogoWidget: Image.asset('assets/logo.png', width: 52, height: 52),
    colorScheme: const AuthColorScheme(
      primaryGradient: LinearGradient(
        colors: [Color(0xFFEC4899), Color(0xFFF97316)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ),
  onSuccess: () { /* navigate */ },
)
```

### Replace a field with your own widget

```dart
AuthLoginScreen(
  config: AuthUIConfig(
    enableEmailPassword: true,
    emailField: MyCustomEmailInput(),
    loginButton: MyStyledButton(label: 'Log In', onTap: () {}),
  ),
  onSuccess: () { /* navigate */ },
)
```

---

## Callbacks

### AuthLoginScreen

| Callback | Type | Description |
|---|---|---|
| `onSuccess` | `VoidCallback?` | Called after successful login |
| `onSignupTap` | `VoidCallback?` | Called when "Don't have an account?" is tapped. If `null`, the footer link is hidden |

### AuthSignupScreen

| Callback | Type | Description |
|---|---|---|
| `onSuccess` | `VoidCallback?` | Called after successful signup |
| `onLoginTap` | `VoidCallback?` | Called when "Already have an account?" is tapped. If `null`, the footer link is hidden |

---

## AuthController

Use `AuthController` directly if you need to build your own UI:

```dart
final auth = AuthController();

// Email/password
await auth.login(email: 'user@example.com', password: 'pass');
await auth.signUp(name: 'John', email: 'user@example.com', password: 'pass');

// Google
await auth.loginWithGoogle();

// OTP
await auth.sendOTP(phone: '+1234567890', onCodeSent: (id) { });
await auth.verifyOTP(verificationId: id, code: '123456');

// Sign out
await auth.logout();

// Auth state stream
auth.authState.listen((user) { });
```

---

## License

MIT
