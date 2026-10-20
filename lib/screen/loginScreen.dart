// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screen/Register_Screen.dart';
import 'package:project/screen/myhome.dart';

import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // =========================
  // Controllers
  // =========================

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  // =========================
  // Form Key
  // =========================

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  // =========================
  // Authentication
  // =========================

  final AuthService _authService = AuthService();

  // =========================
  // UI State
  // =========================

  bool isPasswordHidden = true;
  bool isLoading = false;

  // =========================
  // Login
  // =========================

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
    });

    try {
      final User? user = await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (!mounted) return;

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Myhome(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message =
          'حدث خطأ أثناء تسجيل الدخول';

      switch (e.code) {
        case 'invalid-email':
          message = 'البريد الإلكتروني غير صحيح';
          break;

        case 'user-not-found':
          message =
              'لا يوجد حساب بهذا البريد الإلكتروني';
          break;

        case 'wrong-password':
          message = 'كلمة المرور غير صحيحة';
          break;

        case 'invalid-credential':
          message =
              'البريد الإلكتروني أو كلمة المرور غير صحيحة';
          break;

        case 'user-disabled':
          message = 'تم تعطيل هذا الحساب';
          break;

        case 'too-many-requests':
          message =
              'تم إجراء محاولات كثيرة، حاول مرة أخرى لاحقًا';
          break;

        case 'network-request-failed':
          message =
              'تعذر الاتصال بالإنترنت، تحقق من اتصالك';
          break;

        default:
          message =
              e.message ?? 'حدث خطأ أثناء تسجيل الدخول';
      }

      _showMessage(
        message,
        isError: true,
      );
    } catch (e) {
      debugPrint('خطأ غير متوقع في تسجيل الدخول: $e');

      if (!mounted) return;

      _showMessage(
        'حدث خطأ غير متوقع، حاول مرة أخرى',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // =========================
  // Show Message
  // =========================

  void _showMessage(
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isError
                    ? Icons.error_outline
                    : Icons.check_circle_outline,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(message),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(15),
          duration: const Duration(seconds: 3),
          backgroundColor:
              isError ? Colors.red.shade700 : Colors.green.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            24,
            35,
            24,
            25,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [

                // =========================
                // Logo
                // =========================

                Center(
                  child: Container(
                    width: 125,
                    height: 125,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'images/1.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // =========================
                // Welcome
                // =========================

                const Text(
                  'مرحباً بعودتك 👋',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172B4D),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'سجل الدخول للمتابعة إلى حسابك',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 35),

                // =========================
                // Email
                // =========================

                const Text(
                  'البريد الإلكتروني',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172B4D),
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: emailController,
                  keyboardType:
                      TextInputType.emailAddress,
                  textInputAction:
                      TextInputAction.next,

                  decoration: _inputDecoration(
                    hintText: 'example@gmail.com',
                    icon: Icons.email_outlined,
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'أدخل البريد الإلكتروني';
                    }

                    final emailRegex = RegExp(
                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                    );

                    if (!emailRegex.hasMatch(
                      value.trim(),
                    )) {
                      return 'أدخل بريدًا إلكترونيًا صحيحًا';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // =========================
                // Password
                // =========================

                const Text(
                  'كلمة المرور',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172B4D),
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: passwordController,
                  obscureText: isPasswordHidden,
                  textInputAction:
                      TextInputAction.done,

                  onFieldSubmitted: (_) {
                    if (!isLoading) {
                      _login();
                    }
                  },

                  decoration: _inputDecoration(
                    hintText: 'أدخل كلمة المرور',
                    icon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordHidden =
                              !isPasswordHidden;
                        });
                      },
                      icon: Icon(
                        isPasswordHidden
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return 'أدخل كلمة المرور';
                    }

                    if (value.length < 6) {
                      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                    }

                    return null;
                  },
                ),

                // =========================
                // Forgot Password
                // =========================

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      _showMessage(
                        'ميزة استعادة كلمة المرور ستكون متاحة لاحقًا',
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor:
                          const Color(0xFF0B2F55),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                    ),
                    child: const Text(
                      'هل نسيت كلمة المرور؟',
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // =========================
                // Login Button
                // =========================

                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed:
                        isLoading ? null : _login,

                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF0B2F55),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          Colors.grey.shade400,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(13),
                      ),
                    ),

                    child: isLoading
                        ? const SizedBox(
                            width: 25,
                            height: 25,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 28),

                // =========================
                // Divider
                // =========================

                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: Text(
                        'أو',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // =========================
                // Register
                // =========================

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Text(
                      'ليس لديك حساب؟',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const RegisterScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor:
                            const Color(0xFF0B2F55),
                      ),
                      child: const Text(
                        'إنشاء حساب',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================
  // Input Decoration
  // =========================

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 14,
      ),

      prefixIcon: Icon(
        icon,
        color: const Color(0xFF0B2F55),
      ),

      suffixIcon: suffixIcon,

      filled: true,
      fillColor: Colors.white,

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 16,
      ),

      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(13),
        borderSide: BorderSide(
          color: Colors.grey.shade200,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(13),
        borderSide: BorderSide(
          color: Colors.grey.shade200,
        ),
      ),

      focusedBorder: const OutlineInputBorder(
        borderRadius:
            BorderRadius.all(
          Radius.circular(13),
        ),
        borderSide: BorderSide(
          color: Color(0xFF0B2F55),
          width: 1.5,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
    );
  }
}