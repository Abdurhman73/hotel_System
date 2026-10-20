import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/Models/dummy_room.dart';
import 'package:project/providers/booking_provider.dart';
import 'package:project/providers/favorites_provider.dart';
// import 'package:project/screen/myhome.dart';
import 'package:project/screen/splash.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // إنشاء مزود المفضلة
  final favoritesProvider = FavoritesProvider();

  // تحميل المفضلة المحفوظة محليًا
  await favoritesProvider.loadFavorites(rooms);

  // إنشاء مزود الحجوزات
  final bookingProvider = BookingProvider();

  // تحميل الحجوزات من Firestore
  await bookingProvider.loadBookings();

  runApp(
    MultiProvider(
      providers: [
        // المفضلة تبقى محفوظة محليًا
        ChangeNotifierProvider.value(
          value: favoritesProvider,
        ),

        // الحجوزات أصبحت مرتبطة بـ Firestore
        ChangeNotifierProvider.value(
          value: bookingProvider,
        ),
      ],
      child: const HotelApp(),
    ),
  );
}

class HotelApp extends StatelessWidget {
  const HotelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: splashScreen(), 
    );
  }
}