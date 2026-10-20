// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:project/screen/loginScreen.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    super.initState();

    // الانتظار ثانية واحدة ثم الانتقال إلى شاشة تسجيل الدخول.
    Future.delayed(const Duration(seconds: 1), () {
      // التأكد أن شاشة البداية ما زالت موجودة.
      if (!mounted) return;

      // استبدال شاشة البداية بشاشة تسجيل الدخول.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF9FC6E8),
              Color(0xFF0D2029),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // شعار الفندق أو الصورة المستخدمة حاليًا.
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'images/iphone.jpg',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // إظهار أيقونة بديلة إذا تعذر تحميل الصورة.
                        return Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(
                            Icons.hotel_rounded,
                            size: 85,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 23),

                  const Text(
                    'Hotel One',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'WELCOME TO HOTEL ONE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      letterSpacing: 1.0,
                    ),
                  ),

                  const SizedBox(height: 28),

                  const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}