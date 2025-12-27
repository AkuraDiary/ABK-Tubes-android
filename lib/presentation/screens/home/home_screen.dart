import 'package:asisten_buku_kebun/DI.dart';
import 'package:asisten_buku_kebun/data/preferences/app_shared_preferences.dart';
import 'package:asisten_buku_kebun/presentation/resources/app_colors.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routes.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routing.dart';
import 'package:asisten_buku_kebun/presentation/screens/home/widgets/crop_summary_section.dart';
import 'package:asisten_buku_kebun/presentation/screens/home/widgets/greeting_section.dart';
import 'package:asisten_buku_kebun/presentation/screens/home/widgets/primary_action_section.dart';
import 'package:asisten_buku_kebun/presentation/screens/home/widgets/recent_logs_section.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  String name = "";

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final hasLoggedIn = await AppSharedPreferences.containsKey(
      AppSharedPreferences.userModelKey,
    );
    if (!mounted) return;

    if (hasLoggedIn) {
      setState(() {
        name = DI.authPresenter.loggedInUser?.name ?? "";
      });
    } else {
      AppRouting().pushReplacement(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Beranda"),
        actions: [
          IconButton(
            color: Colors.red,
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await DI.authPresenter.logout();
              if (!mounted) return;
              AppRouting().pushReplacement(AppRoutes.login);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary900,
        foregroundColor: AppColors.white,
        onPressed: () {
          AppRouting().navigateTo(AppRoutes.cropMapScreen);
        },
        child: const Icon(Icons.map),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GreetingSection(name: name),
            const SizedBox(height: 20),
            const CropSummarySection(),
            const SizedBox(height: 20),
            const PrimaryActionsSection(),
            const SizedBox(height: 24),
            const RecentLogsSection(),
          ],
        ),
      ),
    );
  }
}
