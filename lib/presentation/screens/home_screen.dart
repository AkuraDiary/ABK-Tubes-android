import 'package:asisten_buku_kebun/data/preferences/app_shared_preferences.dart';
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
  // final _future = AppSharedPreferences.containsKey(AppSharedPreferences.userModelKey);//Supabase.instance.client.from('users').select();

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
      // AppRouting().pushReplacement(AppRoutes.home);
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
    return Scaffold(body: Center(child: Text("Welcome to home page, $name")));
  }
}
