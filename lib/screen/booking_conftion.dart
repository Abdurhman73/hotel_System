import 'package:flutter/material.dart';
import 'package:project/Models/bookingmodel.dart';
import 'package:project/Models/model_room.dart';
import 'package:project/providers/booking_provider.dart';
import 'package:project/screen/myhome.dart';
import 'package:provider/provider.dart';

class BookingConftion extends StatefulWidget {
  final Bookingmodel booking;
  final ModelRoom room;

  const BookingConftion({
    super.key,
    required this.booking,
    required this.room,
  });

  @override
  State<BookingConftion> createState() => _BookingConftionState();
}

class _BookingConftionState extends State<BookingConftion> {
  bool isConfirming = false;

  // =========================
  // تأكيد الحجز
  // =========================
  Future<void> _confirmBooking() async {
    if (isConfirming) {
      return;
    }

    setState(() {
      isConfirming = true;
    });

    final provider = context.read<BookingProvider>();

    final success = await provider.createBooking(
      widget.booking,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      isConfirming = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تأكيد الحجز بنجاح'),
          backgroundColor: Color.fromARGB(255, 76, 97, 175),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.push(context,
      MaterialPageRoute(builder: (c)=> const Myhome()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'الغرفة غير متاحة في الفترة المحددة',
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // =========================
  // تنسيق التاريخ
  // =========================
  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // =========================
  // عدد الليالي
  // =========================
  int get nights {
    return widget.booking.chackout
        .difference(widget.booking.chackIn)
        .inDays;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تأكيد الحجز',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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

            const SizedBox(height: 20),

            // =========================
            // صورة الغرفة
            // =========================
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                widget.room.image,
                width: double.infinity,
                height: 210,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 25),

            // =========================
            // عنوان ملخص الحجز
            // =========================
            const Text(
              'ملخص الحجز',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // =========================
            // معلومات الحجز
            // =========================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: Column(
                children: [

                  _infoRow(
                    'تاريخ الوصول',
                    formatDate(widget.booking.chackIn),
                    Icons.login,
                  ),

                  const Divider(),

                  _infoRow(
                    'تاريخ المغادرة',
                    formatDate(widget.booking.chackout),
                    Icons.logout,
                  ),

                  const Divider(),

                  _infoRow(
                    'عدد الأشخاص',
                    widget.booking.num_persons.toString(),
                    Icons.people_outline,
                  ),

                  const Divider(),

                  _infoRow(
                    'عدد الليالي',
                    '$nights ليلة',
                    Icons.nights_stay_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // الإجمالي
            // =========================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [

                  const Text(
                    'الإجمالي',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    '${widget.booking.totalPrice.toStringAsFixed(2)} \$',
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // =========================
            // زر تأكيد الحجز
            // =========================
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: isConfirming
                    ? null
                    : _confirmBooking,

                icon: isConfirming
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.check_circle_outline,
                      ),

                label: Text(
                  isConfirming
                      ? 'جاري تأكيد الحجز...'
                      : 'تأكيد الحجز',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 9, 111, 12),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      Colors.grey.shade400,
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
  // صف معلومات
  // =========================
  Widget _infoRow(
    String title,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        children: [

          Icon(
            icon,
            color: Colors.green,
            size: 23,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}