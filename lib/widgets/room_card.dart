import 'package:flutter/material.dart';

class RoomCard extends StatelessWidget {
  final String name;
  final String image;
  final String price;
  final double rating;
  final VoidCallback onTap;

  const RoomCard({
    super.key,
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 3,
          shadowColor: Colors.black.withOpacity(0.12),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =====================================================
              // صورة نوع الغرفة
              // =====================================================

              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 145,
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // طبقة بسيطة أسفل الصورة
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 45,
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

                  // التقييم
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
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
                            size: 16,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF172B4D),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // اسم النوع فوق الصورة
                  Positioned(
                    left: 10,
                    bottom: 9,
                    child: Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // =====================================================
              // معلومات نوع الغرفة
              // =====================================================

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  11,
                  11,
                  11,
                  12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // السعر
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.payments_outlined,
                          size: 18,
                          color: Color(0xFFD99A00),
                        ),

                        const SizedBox(width: 5),

                        Expanded(
                          child: Text(
                            '\$$price',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF172B4D),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 3),

                    Padding(
                      padding: const EdgeInsets.only(left: 23),
                      child: Text(
                        'السعر لليلة',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // زر عرض الغرف
                    SizedBox(
                      width: double.infinity,
                      height: 36,
                      child: ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0B2F55),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'عرض الغرف',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }
}