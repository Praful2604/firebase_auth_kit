import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_kit/firebase_auth_kit.dart';

void main() {
  group('AuthValidators.email', () {
    test('returns error for null', () {
      expect(AuthValidators.email(null), isNotNull);
    });

    test('returns error for empty string', () {
      expect(AuthValidators.email(''), isNotNull);
    });

    test('returns error for missing @', () {
      expect(AuthValidators.email('notanemail'), isNotNull);
    });

    test('returns error for missing domain', () {
      expect(AuthValidators.email('user@'), isNotNull);
    });

    test('returns null for valid email', () {
      expect(AuthValidators.email('user@example.com'), isNull);
    });
  });

  group('AuthValidators.password', () {
    test('returns error for null', () {
      expect(AuthValidators.password(null), isNotNull);
    });

    test('returns error for empty string', () {
      expect(AuthValidators.password(''), isNotNull);
    });

    test('returns error for less than 6 characters', () {
      expect(AuthValidators.password('abc'), isNotNull);
    });

    test('returns null for 6+ character password', () {
      expect(AuthValidators.password('secret'), isNull);
    });
  });

  group('AuthValidators.name', () {
    test('returns error for null', () {
      expect(AuthValidators.name(null), isNotNull);
    });

    test('returns error for empty string', () {
      expect(AuthValidators.name(''), isNotNull);
    });

    test('returns null for valid name', () {
      expect(AuthValidators.name('Alice'), isNull);
    });
  });

  group('AuthValidators.confirmPassword', () {
    test('returns error when passwords do not match', () {
      expect(AuthValidators.confirmPassword('abc123', 'xyz789'), isNotNull);
    });

    test('returns error for empty value', () {
      expect(AuthValidators.confirmPassword('', 'secret'), isNotNull);
    });

    test('returns null when passwords match', () {
      expect(AuthValidators.confirmPassword('secret', 'secret'), isNull);
    });
  });
}
