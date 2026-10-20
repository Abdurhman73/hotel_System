import 'package:flutter/material.dart';
import 'package:project/Models/model_room.dart';
import 'package:project/screen/booking_screen.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';

class RoomsCard extends StatelessWidget {
  final ModelRoom room;
  final VoidCallback onTap;

  const RoomsCard({
    super.key,
    required this.room,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isFavorite =
        context.watch<FavoritesProvider>().isFavorite(room.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =====================================================
          // صورة الغرفة
          // =====================================================

          Stack(
            children: [
              InkWell(
                onTap: onTap,
                child: SizedBox(
                  width: double.infinity,
                  height: 220,
                  child: Image.asset(
                    room.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // تدرج أسفل الصورة
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: IgnorePointer(
                  child: Container(
                    height: 70,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black54,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // =================================================
              // التقييم
              // =================================================

              Positioned(
                left: 12,
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFFFB800),
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        room.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Color(0xFF172B4D),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // =================================================
              // زر المفضلة
              // =================================================

              Positioned(
                top: 12,
                right: 12,
                child: Material(
                  color: Colors.white,
                  elevation: 3,
                  shape: const CircleBorder(),
                  child: InkWell(
                   onTap: () {
  final favoritesProvider =
      context.read<FavoritesProvider>();

  final wasFavorite =
      favoritesProvider.isFavorite(room.id);

  favoritesProvider.toggleFavorite(room);

  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        wasFavorite
            ? 'تم حذف الغرفة من المفضلة'
            : 'تمت إضافة الغرفة إلى المفضلة',
      ),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
},  
                    customBorder: const CircleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: isFavorite
                            ? Colors.red
                            : const Color(0xFF172B4D),
                        size: 23,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // =====================================================
          // معلومات الغرفة
          // =====================================================

          Padding(
            padding: const EdgeInsets.fromLTRB(
              15,
              14,
              15,
              15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // اسم الغرفة
                InkWell(
                  onTap: onTap,
                  child: Text(
                    room.titele,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF172B4D),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // التقييمات
                Row(
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      size: 17,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${room.reviews} تقييم',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // =================================================
                // السعر
                // =================================================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.payments_outlined,
                        color: Color(0xFFD99A00),
                        size: 21,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'السعر لليلة',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF665522),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${room.price.toStringAsFixed(0)} \$',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF172B4D),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 13),

                // =================================================
                // زر الحجز
                // =================================================

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BookingScreen(room: room),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.calendar_month_outlined,
                      size: 20,
                    ),
                    label: const Text(
                      'احجز الآن',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B2F55),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
}