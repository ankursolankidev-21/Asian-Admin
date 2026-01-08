import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Login with email & password
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (result.user == null) {
        throw Exception('Login failed');
      }

      return result.user!;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Authentication error');
    }
  }

  /// Logout
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  /// Check current logged-in user
  User? get currentUser => _firebaseAuth.currentUser;
}
