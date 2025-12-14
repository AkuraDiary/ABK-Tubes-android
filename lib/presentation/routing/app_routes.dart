import 'package:asisten_buku_kebun/presentation/screens/auth/login_screen.dart';
import 'package:asisten_buku_kebun/presentation/screens/auth/register_screen.dart';
import 'package:asisten_buku_kebun/presentation/screens/home_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
// Define a global key for the navigator
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';

  static const String account = '/account';
  static const String tanaman = '/tanaman';
  static const String laporan = '/laporan';

  static const String addTanamanScreen = '/addTanamanScreen';
  static const String plantReportingFormScreen = '/plantReportingFormScreen';
  static const String viewPlantReportingScreen = '/viewPlantReportingScreen';

  // route pages
  // routes string and pages
  static Map<String, WidgetBuilder> get routes {
    return {
      // Replace with actual widget
      AppRoutes.home: (context) =>  HomePage(),
      AppRoutes.login: (context) => LoginScreen(),
      AppRoutes.register: (context) =>  RegisterScreen(),
      //
      // AppRoutes.account: (context) =>  ProfileScreen(),
      // AppRoutes.tanaman: (context) => const TanamanScreen(),
      // AppRoutes.laporan: (context) => const ActivitiesReportScreen(),
      //
      // AppRoutes.addTanamanScreen : (context) => AddTanamanScreen(),
      //
      // AppRoutes.plantReportingFormScreen: (context) => const PlantReportingFormScreen(),
      // AppRoutes.viewPlantReportingScreen: (context) => const ViewPlantReportingScreen(),

    };
  }
}