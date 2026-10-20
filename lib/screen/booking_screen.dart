import 'package:flutter/material.dart';
import 'package:project/Models/bookingmodel.dart';
import 'package:project/Models/model_room.dart';
import 'package:project/providers/booking_provider.dart';
import 'package:project/screen/booking_conftion.dart';
import 'package:project/services/auth_service.dart';
import 'package:provider/provider.dart';

class BookingScreen extends StatefulWidget {
  final ModelRoom room;

  const BookingScreen({
    super.key,
    required this.room,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? checkin;
  DateTime? checkout;

  // ignore: non_constant_identifier_names
  int num_person = 1;

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color.fromARGB(255, 173, 15, 3),
      ),
    );
  }

  // =========================
  // عدد الليالي
  // =========================
  int get nights {
    if (checkin == null || checkout == null) {
      return 0;
    }

    return checkout!.difference(checkin!).inDays;
  }

  // =========================
  // السعر الإجمالي
  // =========================
  double get totalprice {
    return nights * widget.room.price;
  }

  // =========================
  // اختيار تاريخ الوصول
  // =========================
  Future<void> selectCheckIn() async {
    final today = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      firstDate: today,
      lastDate: today.add(
        const Duration(days: 365),
      ),
      initialDate: checkin ?? today,
    );

    if (selectedDate == null) {
      return;
    }

    setState(() {
      checkin = selectedDate;

      // إذا أصبح تاريخ المغادرة غير صالح
      if (checkout != null &&
          !checkout!.isAfter(checkin!)) {
        checkout = null;
      }
    });
  }

  // =========================
  // اختيار تاريخ المغادرة
  // =========================
  Future<void> selectCheckOut() async {
    final today = DateTime.now();

    final firstDate = checkin != null
        ? checkin!.add(const Duration(days: 1))
        : today.add(const Duration(days: 1));

    final selectedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: today.add(
        const Duration(days: 365),
      ),
      initialDate: checkout ?? firstDate,
    );

    if (selectedDate == null) {
      return;
    }

    setState(() {
      checkout = selectedDate;
    });
  }

  // =========================
  // تنفيذ الحجز
  // =========================
  Future<void> submitBooking() async {
    // التحقق من تاريخ الوصول
    if (checkin == null) {
      showMessage('يرجى اختيار تاريخ الوصول');
      return;
    }

    // التحقق من تاريخ المغادرة
    if (checkout == null) {
      showMessage('يرجى اختيار تاريخ المغادرة');
      return;
    }

    // التأكد أن المغادرة بعد الوصول
    if (!checkout!.isAfter(checkin!)) {
      showMessage(
        'تاريخ المغادرة يجب أن يكون بعد تاريخ الوصول',
      );
      return;
    }

    // الحصول على BookingProvider
    final bookingProvider =
        context.read<BookingProvider>();

    // التحقق من توفر الغرفة
    final isAvailable =
        bookingProvider.isRoomAvailable(
      roomId: widget.room.id,
      chakIn: checkin!,
      chakout: checkout!,
    );

    if (!isAvailable) {
      showMessage(
        'هذه الغرفة غير متوفرة ومحجوزة في الفترة المحددة',
      );
      return;
    }

    // الحصول على المستخدم الحالي
    final currentUser = AuthService().currentUser;

    if (currentUser == null) {
      showMessage('يرجى تسجيل الدخول أولاً');
      return;
    }

    // إنشاء الحجز
    final booking = Bookingmodel(
      bookingId: DateTime.now().millisecondsSinceEpoch,
      roomId: widget.room.id,
      chackIn: checkin!,
      chackout: checkout!,
      num_persons: num_person,
      totalPrice: totalprice,
      user: currentUser.uid,
    );

    // الانتقال إلى صفحة تأكيد الحجز
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingConftion(
          booking: booking,
          room: widget.room,
        ),
      ),
    );
  }

  // =========================
  // تنسيق التاريخ
  // =========================
  String formatDate(DateTime? date) {
    if (date == null) {
      return 'اختر التاريخ';
    }

    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'حجز الغرفة',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      backgroundColor: const Color(0xFF0B2F55),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // =========================
            // اسم الغرفة
            // =========================
            Center(
              child: Text(
                widget.room.titele,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // السعر
            Center(
              child: Text(
                '${widget.room.price.toStringAsFixed(0)} \$ / الليلة',
                style: const TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 31, 47, 84),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // =========================
            // تاريخ الوصول
            // =========================
            const Text(
              'تاريخ الوصول',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            _dateCard(
              icon: Icons.login,
              title: 'تاريخ الوصول',
              date: checkin,
              onTap: selectCheckIn,
            ),

            const SizedBox(height: 18),

            // =========================
            // تاريخ المغادرة
            // =========================
            const Text(
              'تاريخ المغادرة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            _dateCard(
              icon: Icons.logout,
              title: 'تاريخ المغادرة',
              date: checkout,
              onTap: selectCheckOut,
            ),

            const SizedBox(height: 25),

            // =========================
            // عدد الأشخاص
            // =========================
            const Text(
              'عدد الأشخاص',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [

                  IconButton(
                    onPressed: num_person > 1
                        ? () {
                            setState(() {
                              num_person--;
                            });
                          }
                        : null,
                    icon: const Icon(
                      Icons.remove_circle_outline,
                    ),
                  ),

                  const SizedBox(width: 15),

                  Text(
                    '$num_person',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(width: 15),

                  IconButton(
                    onPressed: num_person < 4
                        ? () {
                            setState(() {
                              num_person++;
                            });
                          }
                        : null,
                    icon: const Icon(
                      Icons.add_circle_outline,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // =========================
            // ملخص الحجز
            // =========================
            const Text(
              'ملخص الحجز',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [

                  _summaryRow(
                    'عدد الليالي',
                    '$nights ليلة',
                  ),

                  const Divider(),

                  _summaryRow(
                    'عدد الأشخاص',
                    '$num_person',
                  ),

                  const Divider(),

                  _summaryRow(
                    'سعر الليلة',
                    '${widget.room.price.toStringAsFixed(0)} \$',
                  ),

                  const Divider(),

                  _summaryRow(
                    'الإجمالي',
                    '${totalprice.toStringAsFixed(2)} \$',
                    isTotal: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // =========================
            // زر متابعة الحجز
            // =========================
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: submitBooking,
                icon: const Icon(
                  Icons.arrow_forward,
                ),
                label: const Text(
                  'متابعة الحجز',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                    const  Color.fromARGB(255, 9, 57, 111),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // بطاقة التاريخ
  // =========================
  Widget _dateCard({
    required IconData icon,
    required String title,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [

            Icon(
              icon,
              color:const Color.fromARGB(255, 32, 59, 150),
              size: 28,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    formatDate(date),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.calendar_month,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // صف ملخص الحجز
  // =========================
  Widget _summaryRow(
    String title,
    String value, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [

        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 18 : 15,
            fontWeight:
                isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),

        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 19 : 15,
            fontWeight: FontWeight.bold,
            color: isTotal ?const Color.fromARGB(255, 18, 40, 110) : null,
          ),
        ),
      ],
    );
  }
}