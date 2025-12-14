import 'package:asisten_buku_kebun/presentation/common/widgets/app_button.dart';
import 'package:asisten_buku_kebun/presentation/common/widgets/input_field.dart';
import 'package:asisten_buku_kebun/presentation/resources/app_colors.dart';
import 'package:asisten_buku_kebun/presentation/resources/text_styles_resources.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routes.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routing.dart';
import 'package:asisten_buku_kebun/presentation/common/util/app_toast.dart';
import 'package:asisten_buku_kebun/DI.dart';
import 'package:asisten_buku_kebun/presenter/auth_presenter.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  final AuthPresenter authPresenter = DI.authPresenter;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      var isSuccess = await widget.authPresenter.register(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (isSuccess) {
        await widget.authPresenter.authenticate();
        if (!mounted) return;
        if (await widget.authPresenter.checkLogin()) {
          // Navigate to dashboard
          AppRouting().pushReplacement(AppRoutes.home);
        } else {
          // Show error message
          showAppToast(
            context,
            'Login gagal. Silakan coba lagi',
            title: 'Login Gagal',
          );
        }
      } else {
        // Show error message
        showAppToast(
          context,
          'Terjadi kesalahan Silakan coba lagi',
          title: 'Username & Password Salah',
        );
      }
    } catch (e) {
      // Handle errors here
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
          child: Column(
            children: [
              const SizedBox(height: 24),
              Text(
                "Selamat Datang",
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
                        key: const Key('nameInput'),
                        label: "Masukkan Nama",
                        hint: "Contoh: Amanda Faiza",
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 10),
                      InputField(
                        key: const Key('confirmPasswordInput'),
                        label: "Konfirmasi Password",
                        hint: "Contoh: password",
                        controller: _confirmPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !_isConfirmPasswordVisible,
                        suffixIcon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onSuffixIconTap: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password cannot be empty';
                          }

                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      AppButton(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        onPressed: _register,
                        buttonText: 'Daftar',
                        backgroundColor: AppColors.primary900,
                        textStyle: semibold16.copyWith(color: AppColors.white),
                        key: const Key('loginButton'),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Sudah Punya Akun?"),
                            TextButton(
                              onPressed: () {
                                AppRouting().pushReplacement(AppRoutes.login);
                              },
                              child: Text(
                                'Masuk Sekarang',
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
    );
  }
}
