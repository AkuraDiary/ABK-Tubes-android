import 'package:asisten_buku_kebun/presentation/common/util/app_toast.dart';
import 'package:asisten_buku_kebun/presentation/common/widgets/app_button.dart';
import 'package:asisten_buku_kebun/presentation/common/widgets/input_field.dart';
import 'package:asisten_buku_kebun/presentation/resources/app_colors.dart';
import 'package:asisten_buku_kebun/presentation/resources/text_styles_resources.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routes.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routing.dart';
import 'package:asisten_buku_kebun/DI.dart';
import 'package:asisten_buku_kebun/presenter/auth_presenter.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {

   LoginScreen({super.key});
   AuthPresenter authPresenter = DI.authPresenter;

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
      bool success = await widget.authPresenter.login(
        _emailController.text,
        _passwordController.text,
      );
      if (!mounted) return;
      if (success) {
        showAppToast(
          context,
          'Login berhasil! Selamat datang kembali.',
          title: 'Sukses 🎉',
           isError: false,
        );
        AppRouting().pushReplacement(AppRoutes.home);
      } else {
        showAppToast(
          context,
          'Login gagal! Periksa email dan password Anda.',
          title: 'Gagal ❌',
        );
      }
    } catch (e) {
      showAppToast(
        context,
        'Terjadi kesalahan: $e. Silakan coba lagi',
        title: 'Error Tidak Terduga 😢',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          // Scroll jika keyboard naik
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                Text(
                  "Selamat Datang Kembali!",
                  style: semibold20.copyWith(color: AppColors.primary900),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
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
                            if (!RegExp(
                              r'^[^@]+@[^@]+\.[^@]+',
                            ).hasMatch(value)) {
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
                          textStyle: semibold16.copyWith(
                            color: AppColors.white,
                          ),
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
                                  AppRouting().pushReplacement(AppRoutes.register);
                                },
                                child: Text(
                                  'Daftar Sekarang',
                                  style: semibold16.copyWith(
                                    color: AppColors.primary900,
                                  ),
                                ),
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
      ),
    );
  }
}
