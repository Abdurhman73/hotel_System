import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // الاتصال بخدمة Firebase Authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // =========================
  // تسجيل الدخول
  // =========================
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    final UserCredential credential =
        await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    return credential.user;
  }

  // =========================
  // إنشاء حساب
  // =========================
  Future<User?> register({
    required String email,
    required String password,
  }) async {
    final UserCredential credential =
        await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    return credential.user;
  }

  // =========================
  // تسجيل الخروج
  // =========================
  Future<void> logout() async {
    await _auth.signOut();
  }

  // =========================
  // المستخدم الحالي
  // =========================
  User? get currentUser {
    return _auth.currentUser;
  }
}