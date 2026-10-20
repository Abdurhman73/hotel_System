// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:project/widgets/rooms_screen.dart';

import 'room_card.dart';

class SelectTypeRoom extends StatelessWidget {
  const SelectTypeRoom({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> roomTypes = [
      {
        'name': 'غرفة فردية',
        'image': 'images/5.jpeg',
        'price': '50 - 150',
        'rating': 4.4,
      },
      {
        'name': 'غرفة مزدوجة',
        'image': 'images/3.jpeg',
        'price': '70 - 200',
        'rating': 3.0,
      },
      {
        'name': 'جناح فاخر',
        'image': 'images/2.jpeg',
        'price': '100 - 320',
        'rating': 5.0,
      },
      {
        'name': 'غرفة عائلية',
        'image': 'images/4.jpeg',
        'price': '100 - 250',
        'rating': 4.3,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'الأقسام',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172B4D),
            ),
          ),
        ),

        const SizedBox(height: 5),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'اختر نوع الغرفة التي تناسب إقامتك',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ),

        const SizedBox(height: 18),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),

          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 14,
            childAspectRatio: 0.70,
          ),

          itemCount: roomTypes.length,

          itemBuilder: (context, index) {
            final roomType = roomTypes[index];

            return RoomCard(
              name: roomType['name'] as String,
              image: roomType['image'] as String,
              price: roomType['price'] as String,
              rating: roomType['rating'] as double,

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoomsScreen(
                      category: roomType['name'] as String,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}