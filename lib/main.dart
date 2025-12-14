import 'package:asisten_buku_kebun/app.dart';
import 'package:flutter/material.dart';


import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://lkifvalbauettmawyssq.supabase.co',
    anonKey: 'sb_publishable_cWek2qw_oKyGhBGzDXjBxw_Ovw8QVAo',
  );
  runApp(App());
}
