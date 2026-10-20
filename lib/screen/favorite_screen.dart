import 'package:flutter/material.dart';
import 'package:project/providers/favorites_provider.dart';
import 'package:project/widgets/rooms_card.dart';
import 'package:provider/provider.dart';

import '../widgets/room_Descrip.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites =
        context.watch<FavoritesProvider>().favorites;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B2F55),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'المفضلة',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: favorites.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                16,
                20,
                16,
                25,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final room = favorites[index];

                return RoomsCard(
                  room: room,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RoomDescrip(room: room),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border,
                size: 70,
                color: Colors.red.shade300,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'لا توجد غرف في المفضلة',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172B4D),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'عند إضافة غرفة إلى المفضلة ستظهر هنا',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}