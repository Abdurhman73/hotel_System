// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screen/loginScreen.dart';

import '../services/auth_service.dart';
import '../services/user_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // =========================
  // Form
  // =========================

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  // =========================
  // Controllers
  // =========================

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  // =========================
  // Services
  // =========================

  final AuthService _authService = AuthService();

  final UserService _userService = UserService();

  // =========================
  // UI State
  // =========================

  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;
  bool isLoading = false;

  // =========================
  // Register
  // =========================

  Future<void> _register() async {
    // التحقق من صحة البيانات
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // إخفاء لوحة المفاتيح
    FocusScope.of(context).unfocus();

    // منع الضغط المتكرر
    setState(() {
      isLoading = true;
    });

    try {
      // إنشاء الحساب في Firebase Authentication
      final User? user = await _authService.register(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (user == null) {
        if (!mounted) return;

        _showMessage(
          'تعذر إنشاء الحساب، حاول مرة أخرى',
          isError: true,
        );

        return;
      }

      // حفظ بيانات المستخدم في Firestore
      await _userService.createUserProfile(
        uid: user.uid,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
      );

      if (!mounted) return;

      // رسالة نجاح
      _showMessage(
        'تم إنشاء الحساب بنجاح',
      );

      // الانتقال إلى الصفحة الرئيسية
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message =
          'حدث خطأ أثناء إنشاء الحساب';

      switch (e.code) {
        case 'email-already-in-use':
          message =
              'هذا البريد الإلكتروني مستخدم مسبقًا';
          break;

        case 'invalid-email':
          message =
              'البريد الإلكتروني غير صحيح';
          break;

        case 'weak-password':
          message =
              'كلمة المرور ضعيفة، استخدم كلمة مرور أقوى';
          break;

        case 'network-request-failed':
          message =
              'تعذر الاتصال بالإنترنت، تحقق من اتصالك';
          break;

        case 'too-many-requests':
          message =
              'عدد المحاولات كبير، حاول لاحقًا';
          break;

        case 'operation-not-allowed':
          message =
              'إنشاء الحسابات غير مفعّل في إعدادات Firebase';
          break;

        default:
          message =
              e.message ?? 'حدث خطأ أثناء إنشاء الحساب';
      }

      _showMessage(
        message,
        isError: true,
      );
    } catch (e) {
      debugPrint('خطأ أثناء إنشاء الحساب: $e');

      if (!mounted) return;

      _showMessage(
        'تم إنشاء الحساب أو بدء إنشائه، لكن تعذر حفظ بيانات الملف الشخصي. تحقق من الاتصال والصلاحيات ثم حاول مجددًا.',
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
  // SnackBar
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
          backgroundColor: isError
              ? Colors.red.shade700
              : Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // =========================
  // Dispose
  // =========================

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  // =========================
  // Build
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B2F55),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'إنشاء حساب',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            24,
            25,
            24,
            30,
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
                    width: 105,
                    height: 105,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
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

                const SizedBox(height: 25),

                // =========================
                // Title
                // =========================

                const Text(
                  'انضم إلينا!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172B4D),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'أنشئ حسابك واستمتع بتجربة حجز سهلة ومريحة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 30),

                // =========================
                // Name
                // =========================

                _fieldLabel('الاسم الكامل'),

                const SizedBox(height: 8),

                TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,

                  decoration: _inputDecoration(
                    hintText: 'أدخل اسمك الكامل',
                    icon: Icons.person_outline,
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'أدخل الاسم الكامل';
                    }

                    if (value.trim().length < 3) {
                      return 'الاسم قصير جدًا';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // =========================
                // Email
                // =========================

                _fieldLabel('البريد الإلكتروني'),

                const SizedBox(height: 8),

                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,

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

                const SizedBox(height: 18),

                // =========================
                // Phone
                // =========================

                _fieldLabel('رقم الهاتف'),

                const SizedBox(height: 8),

                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,

                  decoration: _inputDecoration(
                    hintText: 'أدخل رقم الهاتف',
                    icon: Icons.phone_outlined,
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'أدخل رقم الهاتف';
                    }

                    if (value.trim().length < 7) {
                      return 'رقم الهاتف قصير جدًا';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // =========================
                // Password
                // =========================

                _fieldLabel('كلمة المرور'),

                const SizedBox(height: 8),

                TextFormField(
                  controller: passwordController,
                  obscureText: isPasswordHidden,
                  textInputAction: TextInputAction.next,

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

                const SizedBox(height: 18),

                // =========================
                // Confirm Password
                // =========================

                _fieldLabel('تأكيد كلمة المرور'),

                const SizedBox(height: 8),

                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: isConfirmPasswordHidden,
                  textInputAction: TextInputAction.done,

                  onFieldSubmitted: (_) {
                    if (!isLoading) {
                      _register();
                    }
                  },

                  decoration: _inputDecoration(
                    hintText: 'أعد إدخال كلمة المرور',
                    icon: Icons.lock_reset_outlined,

                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordHidden =
                              !isConfirmPasswordHidden;
                        });
                      },

                      icon: Icon(
                        isConfirmPasswordHidden
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return 'أعد إدخال كلمة المرور';
                    }

                    if (value != passwordController.text) {
                      return 'كلمتا المرور غير متطابقتين';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 28),

                // =========================
                // Register Button
                // =========================

                SizedBox(
                  height: 55,

                  child: ElevatedButton(
                    onPressed:
                        isLoading ? null : _register,

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
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Text(
                            'إنشاء الحساب',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // =========================
                // Login Link
                // =========================

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'لديك حساب بالفعل؟',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),

                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              Navigator.pop(context);
                            },

                      style: TextButton.styleFrom(
                        foregroundColor:
                            const Color(0xFF0B2F55),
                      ),

                      child: const Text(
                        'تسجيل الدخول',
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
  // Field Label
  // =========================

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF172B4D),
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
        fontSize: 14,
        color: Colors.grey.shade400,
      ),

      prefixIcon: Icon(
        icon,
        color: const Color(0xFF0B2F55),
      ),

      suffixIcon: suffixIcon,

      filled: true,
      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 16,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide(
          color: Colors.grey.shade200,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide(
          color: Colors.grey.shade200,
        ),
      ),

      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(13),
        ),
        borderSide: BorderSide(
          color: Color(0xFF0B2F55),
          width: 1.5,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
    );
  }
}