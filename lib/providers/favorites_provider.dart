import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/model_room.dart';

class FavoritesProvider extends ChangeNotifier {
  // المفتاح الذي سيتم تخزين IDs المفضلة تحته
  static const String _favoritesKey = 'favorite_room_ids';

  // قائمة الغرف المفضلة
  final List<ModelRoom> _favorites = [];

  // إتاحة القائمة للواجهة بدون السماح بتعديلها مباشرة
  List<ModelRoom> get favorites {
    return List.unmodifiable(_favorites);
  }
  
  // عدد الغرف الموجودة في المفضلة
  int get favoriteCount {
    return _favorites.length;
  }

  // التحقق هل الغرفة موجودة في المفضلة
  bool isFavorite(int roomId) {
    return _favorites.any(
      (room) => room.id == roomId,
    );
  }

  // إضافة أو إزالة الغرفة
  Future<void> toggleFavorite(
    ModelRoom room,
  ) async {
    if (isFavorite(room.id)) {
      // إذا كانت موجودة نحذفها
      _favorites.removeWhere(
        (item) => item.id == room.id,
      );
    } else {
      // إذا لم تكن موجودة نضيفها
      _favorites.add(room);
      
    
    }

    // حفظ التغيير على الجهاز
    await _saveFavorites();

    // تحديث الواجهات التي تستمع إلى Provider
    notifyListeners();
  }

  // حفظ IDs الغرف المفضلة
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final ids = _favorites
        .map(
          (room) => room.id.toString(),
        )
        .toList();

    await prefs.setStringList(
      _favoritesKey,
      ids,
    );
  }

  // تحميل المفضلة عند تشغيل التطبيق
  Future<void> loadFavorites(
    List<ModelRoom> allRooms,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final savedIds = prefs.getStringList(_favoritesKey) ?? [];
    Text('IDs المحفوظة: $savedIds');

    Text(
      'IDs الغرف الحالية: '
      '${allRooms.map((room) => room.id).toList()}',
    );
    _favorites.clear();

    for (final idString in savedIds) {
      final id = int.tryParse(idString);

      if (id == null) {
        continue;
      }

      try {
        final room = allRooms.firstWhere(
          (room) => room.id == id,
        );

        _favorites.add(room);
        
      } catch (_) {
        // إذا لم تعد الغرفة موجودة في قائمة الغرف
        // نتجاهل الـ ID
      }
    }

    // تحديث الواجهة بعد انتهاء التحميل
    notifyListeners();
  }

  // حذف جميع المفضلة
  Future<void> clearFavorites() async {
    _favorites.clear();

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_favoritesKey);

    notifyListeners();
  }
}
