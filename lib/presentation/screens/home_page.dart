import 'package:asisten_buku_kebun/data/preferences/app_shared_preferences.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routes.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routing.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final _future = AppSharedPreferences.containsKey(AppSharedPreferences.userModelKey);//Supabase.instance.client.from('users').select();

  Future<void> _checkLogin() async {
    final hasToken = await AppSharedPreferences.containsKey(
      AppSharedPreferences.userModelKey,
    );
    if (!mounted) return;
    if (hasToken) {
      AppRouting().pushReplacement(AppRoutes.home);
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
    return Scaffold(body: Center(child: Text("Welcome to home")));
  }
}
