import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/bookingmodel.dart';
import '../Models/dummy_room.dart';
import '../providers/booking_provider.dart';

class BookedRoomsScreen extends StatefulWidget {
  const BookedRoomsScreen({super.key});

  @override
  State<BookedRoomsScreen> createState() => _BookedRoomsScreenState();
}

class _BookedRoomsScreenState extends State<BookedRoomsScreen> {
  static const Color primaryColor = Color(0xFF0B2F55);
  static const Color backgroundColor = Color(0xFFF7F8FA);

  @override
  void initState() {
    super.initState();

    // تأجيل التحميل حتى يكتمل بناء الشاشة.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        context.read<BookingProvider>().loadBookings();
      }
    });
  }

  Future<void> _reloadBookings() async {
    if (FirebaseAuth.instance.currentUser == null) return;
    await context.read<BookingProvider>().loadBookings();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'حجوزاتي',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0B2F55),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        
      ),
      body: user == null
          ? const _MessageState(
              icon: Icons.person_outline,
              title: 'يرجى تسجيل الدخول أولاً',
              subtitle: 'سجّل الدخول للاطلاع على حجوزاتك.',
            )
          : Consumer<BookingProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: primaryColor),
                        SizedBox(height: 14),
                        Text('جاري تحميل الحجوزات...'),
                      ],
                    ),
                  );
                }

                if (provider.error != null) {
                  return _ErrorState(
                    message: provider.error!,
                    onRetry: _reloadBookings,
                  );
                }

                final bookings = provider.getMyBookings(user.uid);

                if (bookings.isEmpty) {
                  return const _MessageState(
                    icon: Icons.hotel_outlined,
                    title: 'لا توجد حجوزات حتى الآن',
                    subtitle: 'عند حجز غرفة ستظهر تفاصيلها هنا.',
                  );
                }

                return RefreshIndicator(
                  color: primaryColor,
                  onRefresh: _reloadBookings,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      return _BookingCard(booking: bookings[index]);
                    },
                  ),
                );
              },
            ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Bookingmodel booking;

  const _BookingCard({required this.booking});

  static const Color primaryColor = Color(0xFF0B2F55);

  @override
  Widget build(BuildContext context) {
    final room = _findRoom(booking.roomId);
    final roomName = room == null
        ? 'الغرفة رقم ${booking.roomId}'
        : _readRoomName(room, booking.roomId);

    final checkIn = booking.chackIn;
    final checkOut = booking.chackout;
    final nights = checkOut.difference(checkIn).inDays;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
         const  BoxShadow(
            color: Colors.black12,
            blurRadius: 14,
            offset:  Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(106, 60, 122, 215),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.hotel_rounded,
                    color: Color.fromARGB(255, 252, 184, 27),
                    size: 27,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        roomName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'رقم الحجز: ${booking.bookingId}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Color.fromARGB(255, 33, 66, 132),
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'محفوظ',
                        style: TextStyle(
                          color: Color.fromARGB(255, 33, 79, 132),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _InfoRow(
                  icon: Icons.login_rounded,
                  title: 'تاريخ الوصول',
                  value: _formatDate(checkIn),
                ),
                const SizedBox(height: 15),
                _InfoRow(
                  icon: Icons.logout_rounded,
                  title: 'تاريخ المغادرة',
                  value: _formatDate(checkOut),
                ),
                const SizedBox(height: 15),
                _InfoRow(
                  icon: Icons.people_outline_rounded,
                  title: 'عدد الأشخاص',
                  value: '${booking.num_persons} أشخاص',
                ),
                const SizedBox(height: 15),
                _InfoRow(
                  icon: Icons.nights_stay_outlined,
                  title: 'عدد الليالي',
                  value: '$nights ليلة',
                ),
                const Divider(height: 30),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'السعر الإجمالي',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      booking.totalPrice.toStringAsFixed(2),
                      style: const TextStyle(
                        color: primaryColor,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'ريال',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // البحث عن الغرفة من قائمة الغرف الموجودة في المشروع.
  dynamic _findRoom(int roomId) {
    for (final room in rooms) {
      if (room.id == roomId) return room;
    }
    return null;
  }

  // قراءة اسم الغرفة دون افتراض نوع نموذج الغرفة.
  String _readRoomName(dynamic room, int roomId) {
    try {
      final name = room.name;
      if (name != null && name.toString().trim().isNotEmpty) {
        return name.toString();
      }
    } catch (_) {
      // إذا لم يتضمن نموذج الغرفة حقل name نعرض رقمها.
    }
    return 'الغرفة رقم $roomId';
  }

  static String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  static const Color primaryColor = Color(0xFF0B2F55);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 21, color: primaryColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: primaryColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _MessageState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _MessageState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  static const Color primaryColor = Color(0xFF0B2F55);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration:const BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 65, color: primaryColor),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  static const Color primaryColor = Color(0xFF0B2F55);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 65,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 16),
            const Text(
              'تعذر تحميل الحجوزات',
              style: TextStyle(
                color: primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
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
