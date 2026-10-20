import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/user_service.dart';
import '../screen/myhome.dart';
import '../screen/favorite_screen.dart';
import '../screen/booked_screen.dart';
import '../screen/loginScreen.dart';
import '../screen/ProfileScreen.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final UserService _userService = UserService();

  String name = '';
  String email = '';
  String phone = '';

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // =========================================================
  // تحميل بيانات المستخدم من Firestore
  // =========================================================

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
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
        });

        return;
      }

      final data = snapshot.data();

      if (data == null) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        return;
      }

      if (!mounted) return;

      setState(() {
        name = data['name'] ?? '';
        email = data['email'] ?? '';
        phone = data['phone'] ?? '';
        isLoading = false;
      });
    } catch (e) {
      debugPrint(
        'خطأ في تحميل بيانات المستخدم: $e',
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  // =========================================================
  // تسجيل الخروج
  // =========================================================

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [

          // ===================================================
          // رأس Drawer
          // ===================================================

          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 9, 50, 111),
            ),

            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 40,
                color: Color.fromARGB(255, 76, 119, 175),
              ),
            ),

            accountName: isLoading
                ? const Text(
                    'جاري تحميل البيانات...',
                  )
                : Text(
                    name.isEmpty
                        ? 'مستخدم الفندق'
                        : name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

            accountEmail: isLoading
                ? const Text('...')
                : Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Text(
                        email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      if (phone.isNotEmpty)
                        Text(
                          phone,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
          ),

          // ===================================================
          // الرئيسية
          // ===================================================

          ListTile(
            leading: const Icon(
              Icons.home_outlined,
            ),
            title: const Text('الرئيسية'),
            onTap: () {
              Navigator.pop(context);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const Myhome(),
                ),
              );
            },
          ),

          // ===================================================
          // المفضلة
          // ===================================================

          ListTile(
            leading: const Icon(
              Icons.favorite_border,
            ),
            title: const Text('المفضلة'),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                    const   FavoriteScreen(),
                ),
              );
            },
          ),

          // ===================================================
          // حجوزاتي
          // ===================================================

          ListTile(
            leading: const Icon(
              Icons.hotel_outlined,
            ),
            title: const Text('حجوزاتي'),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const BookedRoomsScreen(),
                ),
              );
            },
          ),

          // ===================================================
          // الملف الشخصي
          // ===================================================

          ListTile(
            leading: const Icon(
              Icons.person_outline,
            ),
            title: const Text('الملف الشخصي'),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ProfileScreen(),
                ),
              );
            },
          ),

          const Spacer(),

          const Divider(),

          // ===================================================
          // تسجيل الخروج
          // ===================================================

          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Text(
              'تسجيل الخروج',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: _logout,
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}