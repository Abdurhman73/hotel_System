// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:project/Models/model_room.dart';
import 'package:project/screen/booking_screen.dart';

class RoomDescrip extends StatelessWidget {
  final ModelRoom room;

  const RoomDescrip({
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      // =====================================================
      // AppBar
      // =====================================================

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B2F55),
        foregroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'تفاصيل الغرفة',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),

      // =====================================================
      // المحتوى
      // =====================================================

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =================================================
            // صورة الغرفة
            // =================================================

            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 280,
                  child: Image.asset(
                    room.image,
                    fit: BoxFit.cover,
                  ),
                ),

                // تدرج أسفل الصورة
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: IgnorePointer(
                    child: Container(
                      height: 100,
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

                // التقييم
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
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
                          size: 20,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          room.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF172B4D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // =================================================
            // معلومات الغرفة
            // =================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                18,
                20,
                18,
                30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =================================================
                  // اسم الغرفة
                  // =================================================

                  Text(
                    room.titele,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF172B4D),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // عدد التقييمات
                  Row(
                    children: [
                      Icon(
                        Icons.rate_review_outlined,
                        size: 18,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${room.reviews} تقييم',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // =================================================
                  // الوصف
                  // =================================================

                  _sectionTitle(
                    icon: Icons.description_outlined,
                    title: 'عن الغرفة',
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      room.description.toString(),
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.7,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // =================================================
                  // المميزات
                  // =================================================

                  _sectionTitle(
                    icon: Icons.check_circle_outline,
                    title: 'مميزات الغرفة',
                  ),

                  const SizedBox(height: 10),

                  _buildFeatures(),

                  const SizedBox(height: 22),

                  // =================================================
                  // السعر
                  // =================================================

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E8),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFFFE5A3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.payments_outlined,
                            color: Color(0xFFD99A00),
                            size: 25,
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Expanded(
                          child: Text(
                            'السعر لليلة',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF665522),
                            ),
                          ),
                        ),

                        Text(
                          '${room.price.toStringAsFixed(0)} \$',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0B2F55),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =================================================
                  // زر الحجز
                  // =================================================

                  SizedBox(
                    width: double.infinity,
                    height: 52,
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
                      ),

                      label: const Text(
                        'احجز هذه الغرفة',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B2F55),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // عنوان القسم
  // ===========================================================

  Widget _sectionTitle({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFFD99A00),
          size: 23,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF172B4D),
          ),
        ),
      ],
    );
  }

  // ===========================================================
  // المميزات
  // ===========================================================

  Widget _buildFeatures() {
    final features = room.features;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: features.map<Widget>((feature) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade200,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Color(0xFF0B2F55),
                size: 17,
              ),
              const SizedBox(width: 6),
              Text(
                feature.toString(),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  
  }
}