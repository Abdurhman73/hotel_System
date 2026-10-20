import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> createUserProfile({
    required String uid,
    required String name,
    required String email,
    required String phone,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'name': name.trim(),
      'email': email.trim(),
      'phone': phone.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfild(
    String uid,
  ) async {
    return await _firestore.collection('users').doc(uid).get();
  }
}
