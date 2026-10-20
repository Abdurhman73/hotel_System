// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();

  String name = '';
  String email = '';
  String phone = '';

  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        isError = true;
      });

      return;
    }

    try {
      final snapshot =
          await _userService.getUserProfild(user.uid);

      if (!snapshot.exists) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
          isError = true;
        });

        return;
      }

      final data = snapshot.data();

      if (data == null) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
          isError = true;
        });

        return;
      }

      if (!mounted) return;

      setState(() {
        name = data['name'] ?? '';
        email = data['email'] ?? '';
        phone = data['phone'] ?? '';

        isLoading = false;
        isError = false;
      });
    } catch (e) {
      debugPrint('خطأ في تحميل الملف الشخصي: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: const Color(0xFF0B2F55),
        foregroundColor: Colors.white,
        title: const Text(
          'الملف الشخصي',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 15),
            Text(
              'جاري تحميل بياناتك...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    if (isError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_off_outlined,
                size: 80,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 15),
              const Text(
                'تعذر تحميل بيانات الملف الشخصي',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _loadProfile,
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 10),

          // صورة المستخدم
          const CircleAvatar(
            radius: 55,
            backgroundColor: Color.fromARGB(255, 9, 50, 111),
            child: Icon(
              Icons.person,
              size: 65,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 15),

          // اسم المستخدم
          Text(
            name.isEmpty ? 'مستخدم الفندق' : name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 30),

          _profileItem(
            icon: Icons.person_outline,
            title: 'الاسم',
            value: name.isEmpty ? 'غير محدد' : name,
          ),

          const SizedBox(height: 15),

          _profileItem(
            icon: Icons.email_outlined,
            title: 'البريد الإلكتروني',
            value: email.isEmpty ? 'غير محدد' : email,
          ),

          const SizedBox(height: 15),

          _profileItem(
            icon: Icons.phone_outlined,
            title: 'رقم الهاتف',
            value: phone.isEmpty ? 'غير محدد' : phone,
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'تعديل الملف الشخصي سيكون متاحًا لاحقًا',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text(
                'تعديل الملف الشخصي',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color.fromARGB(255, 9, 50, 111),
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}