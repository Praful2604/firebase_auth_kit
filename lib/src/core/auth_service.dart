import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Low-level Firebase authentication service.
///
/// Handles all direct interactions with [FirebaseAuth], [FirebaseFirestore],
/// and [GoogleSignIn]. Prefer using [AuthController] in application code.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Creates a new user with [email] and [password], then stores their
  /// [name] and [email] in Firestore under the `users` collection.
  ///
  /// Throws a [FirebaseAuthException] on failure.
  Future<User?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _db.collection('users').doc(cred.user!.uid).set({
      'uid': cred.user!.uid,
      'name': name,
      'email': email,
    });

    return cred.user;
  }

  /// Signs in an existing user with [email] and [password].
  ///
  /// Throws a [FirebaseAuthException] on failure.
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  /// Signs in the user with their Google account.
  ///
  /// Returns `null` if the user cancels the Google sign-in flow.
  /// Throws a [FirebaseAuthException] on failure.
  Future<User?> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize();

    GoogleSignInAccount? googleUser;

    if (googleSignIn.supportsAuthenticate()) {
      try {
        googleUser = await googleSignIn.authenticate();
      } on GoogleSignInException catch (e) {
        if (e.code == GoogleSignInExceptionCode.canceled) return null;
        rethrow;
      }
    } else {
      // On platforms that don't support authenticate() (e.g. web),
      // wait for a sign-in event from the authentication stream.
      final event = await googleSignIn.authenticationEvents
          .firstWhere((e) => e is GoogleSignInAuthenticationEventSignIn);
      googleUser = (event as GoogleSignInAuthenticationEventSignIn).user;
    }

    // Authorize scopes to get the access token for Firebase.
    final authClient = googleUser.authorizationClient;
    GoogleSignInClientAuthorization? authorization;
    try {
      authorization = await authClient.authorizationForScopes(
            const ['email', 'profile'],
          ) ??
          await authClient.authorizeScopes(const ['email', 'profile']);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }

    final credential = GoogleAuthProvider.credential(
      accessToken: authorization.accessToken,
      idToken: googleUser.authentication.idToken,
    );

    final userCred = await _auth.signInWithCredential(credential);

    await _db.collection('users').doc(userCred.user!.uid).set({
      'uid': userCred.user!.uid,
      'email': userCred.user!.email,
      'name': userCred.user!.displayName,
    }, SetOptions(merge: true));

    return userCred.user;
  }

  /// Sends an OTP to the given [phone] number.
  ///
  /// Calls [onCodeSent] with the verification ID when the SMS is sent.
  /// Throws an [Exception] if verification fails.
  Future<void> sendOTP({
    required String phone,
    required void Function(String verificationId) onCodeSent,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        throw Exception(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  /// Verifies the [code] against the [verificationId] received from [sendOTP].
  ///
  /// Throws a [FirebaseAuthException] on failure.
  Future<User?> verifyOTP({
    required String verificationId,
    required String code,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: code,
    );
    final userCred = await _auth.signInWithCredential(credential);
    return userCred.user;
  }

  /// Signs out the currently authenticated user.
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Returns a stream that emits the current [User] whenever the auth state
  /// changes (sign-in, sign-out, token refresh).
  Stream<User?> authState() => _auth.authStateChanges();
}
