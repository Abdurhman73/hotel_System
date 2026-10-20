import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/bookingmodel.dart';

class BookingProvider extends ChangeNotifier {
  // =========================================================
  // قائمة الحجوزات
  // =========================================================

  final List<Bookingmodel> _bookings = [];

  // الاتصال بقاعدة Firestore
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // =========================================================
  // حالات التحميل والخطأ
  // =========================================================

  bool _isLoading = false;

  String? _error;

  // قراءة حالة التحميل
  bool get isLoading => _isLoading;

  // قراءة رسالة الخطأ
  String? get error => _error;

  // =========================================================
  // قراءة الحجوزات
  // =========================================================

  List<Bookingmodel> get bookings {
    return List.unmodifiable(_bookings);
  }

  // =========================================================
  // تحميل الحجوزات من Firestore
  // =========================================================

  Future<void> loadBookings() async {
    // بداية التحميل
    _isLoading = true;

    // إزالة الخطأ السابق
    _error = null;

    // تحديث الواجهة
    notifyListeners();

    try {
      final snapshot =
          await _firestore
              .collection('bookings')
              .get();

      _bookings.clear();

      final now = DateTime.now();

      for (final doc in snapshot.docs) {
        final data = doc.data();

        // قراءة تاريخ المغادرة
        final checkout =
            (data['chackout'] as Timestamp).toDate();

        // =====================================================
        // حذف الحجز المنتهي
        // =====================================================

       if (!checkout.isAfter(now)) {
  // الحجز منتهي، نتجاهله فقط
  continue;
}

        // =====================================================
        // إنشاء كائن Bookingmodel
        // =====================================================

        final booking = Bookingmodel(
          bookingId:
              (data['bookingId'] as num).toInt(),

          roomId:
              (data['roomId'] as num).toInt(),

          user:
              data['user'] as String,

          chackIn:
              (data['chackIn'] as Timestamp).toDate(),

          chackout:
              checkout,

          totalPrice:
              (data['totalPrice'] as num).toDouble(),

          num_persons:
              (data['num_persons'] as num).toInt(),
        );

        // إضافة الحجز للقائمة
        _bookings.add(booking);
      }

      // التحميل انتهى بنجاح
      _isLoading = false;

      // لا يوجد خطأ
      _error = null;

      // تحديث الواجهة
      notifyListeners();

    } catch (e) {
  _isLoading = false;

  _error = 'حدث خطأ أثناء تحميل الحجوزات';

  debugPrint('خطأ في تحميل الحجوزات: $e');
  debugPrint('نوع الخطأ: ${e.runtimeType}');

  notifyListeners();
}
  }

  // =========================================================
  // حجوزات المستخدم الحالي
  // =========================================================

  List<Bookingmodel> getMyBookings(
    String userId,
  ) {
    return _bookings
        .where(
          (booking) =>
              booking.user == userId,
        )
        .toList();
  }

  // =========================================================
  // التحقق من توفر الغرفة
  // =========================================================

  bool isRoomAvailable({
    required int roomId,
    required DateTime chakIn,
    required DateTime chakout,
  }) {
    for (final booking in _bookings) {

      // إذا كانت الغرفة مختلفة نتجاهل الحجز
      if (booking.roomId != roomId) {
        continue;
      }

      // التحقق من وجود تداخل في التواريخ
      final hasconflit =
          chakIn.isBefore(
                booking.chackout,
              ) &&
          chakout.isAfter(
                booking.chackIn,
              );

      // يوجد تعارض
      if (hasconflit) {
        return false;
      }
    }

    // لا يوجد تعارض
    return true;
  }

  // =========================================================
  // إنشاء حجز جديد
  // =========================================================

  Future<bool> createBooking(
    Bookingmodel booking,
  ) async {

    // التحقق من توفر الغرفة
    final available =
        isRoomAvailable(
      roomId: booking.roomId,
      chakIn: booking.chackIn,
      chakout: booking.chackout,
    );

    // الغرفة محجوزة
    if (!available) {
      return false;
    }

    try {

      // حفظ الحجز في Firestore
      await _firestore
          .collection('bookings')
          .doc(
            booking.bookingId.toString(),
          )
          .set({
        'bookingId':
            booking.bookingId,

        'roomId':
            booking.roomId,

        'user':
            booking.user,

        // DateTime → Timestamp
        'chackIn':
            Timestamp.fromDate(
          booking.chackIn,
        ),

        'chackout':
            Timestamp.fromDate(
          booking.chackout,
        ),

        'totalPrice':
            booking.totalPrice,

        'num_persons':
            booking.num_persons,
      });

      // إضافة الحجز للقائمة المحلية
      _bookings.add(booking);

      // تحديث الواجهات
      notifyListeners();

      return true;

    } catch (e) {

      debugPrint(
        'خطأ في إنشاء الحجز: $e',
      );

      return false;
    }
  }
}