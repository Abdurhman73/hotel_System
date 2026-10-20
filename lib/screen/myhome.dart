import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:project/providers/booking_provider.dart';
import 'package:project/providers/favorites_provider.dart';

import 'package:project/screen/favorite_screen.dart';
import 'package:project/widgets/drawer.dart';
import 'package:project/widgets/select_Type_room.dart';

class Myhome extends StatefulWidget {
  const Myhome({super.key});

  @override
  State<Myhome> createState() => _MyhomeState();
}

class _MyhomeState extends State<Myhome> {
  final TextEditingController _searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    await context.read<BookingProvider>().loadBookings();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),

      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B2F55),
        foregroundColor: Colors.white,
        elevation: 0,

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'فندقنا',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'مرحباً بك',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white70,
              ),
            ),
          ],
        ),

        actions: [
          _favoriteButton(),
          const SizedBox(width: 5),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(),

              _buildSearchBox(),

              const SizedBox(height: 28),

              _buildSectionTitle(
                title: 'اكتشف غرفنا',
                subtitle: 'اختر نوع الغرفة المناسب لك',
              ),

              const SizedBox(height: 8),

              const SelectTypeRoom(),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // قسم الترحيب
  // =========================================================

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 28),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 3, 53, 106),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.hotel,
                  color: Color(0xFFFFC857),
                  size: 28,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Text(
                  'استمتع بإقامة مميزة معنا',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            'اختر غرفتك واحجز إقامتك بكل سهولة وراحة.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withOpacity(0.12),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.verified_outlined,
                  color: Color(0xFFFFC857),
                  size: 21,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'غرف مريحة • حجز سهل • إقامة مميزة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // مربع البحث
  // =========================================================

  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 216, 213, 213),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'ابحث عن غرفة...',
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: Color(0xFF0B2F55),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                _searchController.clear();
              },
              icon: Icon(
                Icons.close,
                color: Colors.grey.shade500,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: const Color.fromARGB(255, 184, 178, 178),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // عنوان القسم
  // =========================================================

  Widget _buildSectionTitle({
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172B4D),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4D6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.hotel_outlined,
              color: Color(0xFFD99A00),
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // زر المفضلة + العداد
  // =========================================================

  Widget _favoriteButton() {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        final count = favoritesProvider.favoriteCount;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              tooltip: 'المفضلة',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoriteScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.favorite_border,
                size: 27,
              ),
            ),

            if (count > 0)
              Positioned(
                right: 4,
                top: 2,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}