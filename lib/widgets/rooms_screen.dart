import 'package:flutter/material.dart';
import 'package:project/widgets/room_Descrip.dart';
import 'package:project/widgets/rooms_card.dart';

import '../Models/dummy_room.dart';

class RoomsScreen extends StatelessWidget {
  final String category;

  const RoomsScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    // جلب الغرف التي تنتمي إلى النوع الذي اختاره المستخدم
    final categoryRooms = rooms
        .where((room) => room.category == category)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      // =====================================================
      // AppBar
      // =====================================================

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B2F55),
        foregroundColor: Colors.white,
        elevation: 0,

        title: Text(
          category,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),

      // =====================================================
      // المحتوى
      // =====================================================

      body: categoryRooms.isEmpty
          ? _buildEmptyState()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),

                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      5,
                      16,
                      25,
                    ),
                    itemCount: categoryRooms.length,
                    itemBuilder: (context, index) {
                      final room = categoryRooms[index];

                      return RoomsCard(
                        room: room,

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoomDescrip(
                                room: room,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  // ===========================================================
  // رأس الصفحة
  // ===========================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        15,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4D6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.hotel_outlined,
              color: Color(0xFFD99A00),
              size: 24,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172B4D),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'اختر الغرفة التي تناسب إقامتك',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // عدد الغرف
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Text(
              '${category.length} غرف',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B2F55),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // حالة عدم وجود غرف
  // ===========================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.hotel_outlined,
                size: 65,
                color: Colors.grey.shade400,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'لا توجد غرف متاحة',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172B4D),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'لا توجد غرف من نوع "$category" حاليًا',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 20),

            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.arrow_back),
              label: const Text('اختر نوعًا آخر'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0B2F55),
                side: const BorderSide(
                  color: Color(0xFF0B2F55),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}