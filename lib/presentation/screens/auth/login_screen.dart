import 'package:asisten_buku_kebun/presentation/common/util/app_toast.dart';
import 'package:asisten_buku_kebun/presentation/common/widgets/app_button.dart';
import 'package:asisten_buku_kebun/presentation/common/widgets/input_field.dart';
import 'package:asisten_buku_kebun/presentation/resources/app_colors.dart';
import 'package:asisten_buku_kebun/presentation/resources/text_styles_resources.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routes.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routing.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {

      // if () {
      //
      // } else {
      //   // Show error message
      //   showAppToast(context, 'Terjadi kesalahan Silakan coba lagi',
      //       title: 'Username & Password Salah');
      // }
    } catch (e) {
      showAppToast(context, 'Terjadi kesalahan: $e. Silakan coba lagi',
          title: 'Error Tidak Terduga 😢');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          // Scroll jika keyboard naik
          child: Column(
            children: [
              Text("Selamat Datang Kembali!", style: semibold20),
              const SizedBox(height: 24),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      InputField(
                        key: const Key('emailInput'),
                        label: "Masukkan Email",
                        hint: "Contoh: example@mail.com",
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email cannot be empty';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      InputField(
                        key: const Key('passwordInput'),
                        label: "Masukkan Password",
                        hint: "Contoh: password",
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !_isPasswordVisible,
                        suffixIcon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onSuffixIconTap: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      AppButton(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        onPressed: _login,
                        buttonText: 'Masuk',
                        backgroundColor: AppColors.primary900,
                        textStyle:
                        semibold16.copyWith(color: AppColors.white),
                        key: const Key('loginButton'),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Belum Punya Akun?"),
                            TextButton(
                              onPressed: () {
                                AppRouting().navigateTo(AppRoutes.register);
                              },
                              child: Text('Daftar Sekarang', style: semibold16),
                            ),
                          ],
                        ),
                      ),

                      // const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
