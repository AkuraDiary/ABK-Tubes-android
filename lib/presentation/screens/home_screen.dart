import 'package:asisten_buku_kebun/data/preferences/app_shared_preferences.dart';
import 'package:asisten_buku_kebun/presentation/resources/app_colors.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routes.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routing.dart';
import 'package:flutter/material.dart';
import 'package:asisten_buku_kebun/DI.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  String name = "";

  Future<void> _checkLogin() async {
    final hasLoggedIn = await AppSharedPreferences.containsKey(
      AppSharedPreferences.userModelKey,
    );
    if (!mounted) return;
    print("hasLoggedIn: $hasLoggedIn");
    if (hasLoggedIn) {
      setState(() {
        name = DI.authPresenter.loggedInUser?.name ?? "";
      });
    } else {
      AppRouting().pushReplacement(AppRoutes.login);
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary900,
        foregroundColor: AppColors.white,
        onPressed: () {
          // navigate to map screen
          AppRouting().navigateTo(AppRoutes.cropMapScreen);
        },
        child: Icon(Icons.map),
      ),
      body: Center(
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome to home page, $name"),
            // to crops
            ElevatedButton(
              onPressed: () {
                AppRouting().navigateTo(AppRoutes.myCropsScreen);
              },
              child: const Text("Go to My Crops"),
            ),
            ElevatedButton(
              onPressed: () async {
                await DI.authPresenter.logout();
                if (!mounted) return;
                AppRouting().pushReplacement(AppRoutes.login);
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
