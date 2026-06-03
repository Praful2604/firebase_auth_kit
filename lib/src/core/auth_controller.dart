import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

/// High-level controller for Firebase authentication operations.
///
/// Use this class in your UI or business logic layer. It delegates to
/// [AuthService] for all Firebase interactions.
///
/// Example:
/// ```dart
/// final auth = AuthController();
/// await auth.login(email: 'user@example.com', password: 'password');
/// ```
class AuthController {
  final AuthService _service = AuthService();

  /// Creates a new user account with the given [name], [email], and [password].
  ///
  /// The user's profile is stored in Firestore under the `users` collection.
  /// Throws a [FirebaseAuthException] on failure.
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await _service.signUp(name: name, email: email, password: password);
  }

  /// Signs in an existing user with [email] and [password].
  ///
  /// Throws a [FirebaseAuthException] on failure.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _service.login(email: email, password: password);
  }

  /// Signs in the user with their Google account.
  ///
  /// Returns `null` if the user cancels the sign-in flow.
  Future<void> loginWithGoogle() async {
    await _service.signInWithGoogle();
  }

  /// Sends an OTP SMS to the given [phone] number.
  ///
  /// [onCodeSent] is called with the verification ID once the SMS is sent.
  /// Store the verification ID and pass it to [verifyOTP].
  Future<void> sendOTP({
    required String phone,
    required void Function(String verificationId) onCodeSent,
  }) async {
    await _service.sendOTP(phone: phone, onCodeSent: onCodeSent);
  }

  /// Verifies the OTP [code] using the [verificationId] from [sendOTP].
  ///
  /// Throws a [FirebaseAuthException] on failure.
  Future<void> verifyOTP({
    required String verificationId,
    required String code,
  }) async {
    await _service.verifyOTP(verificationId: verificationId, code: code);
  }

  /// Signs out the currently authenticated user.
  Future<void> logout() async {
    await _service.logout();
  }

  /// A stream of [User?] that emits whenever the authentication state changes.
  ///
  /// Emits a [User] when signed in, and `null` when signed out.
  Stream<User?> get authState => _service.authState();
}
