import 'package:asisten_buku_kebun/presentation/screens/auth/login_screen.dart';
import 'package:asisten_buku_kebun/presentation/screens/auth/register_screen.dart';
import 'package:asisten_buku_kebun/presentation/screens/crop/add_edit_crop_screen.dart';
import 'package:asisten_buku_kebun/presentation/screens/crop/crop_log/create_log_screen.dart';
import 'package:asisten_buku_kebun/presentation/screens/crop/detail_crop_screen.dart';
import 'package:asisten_buku_kebun/presentation/screens/crop/my_crops_screen.dart';
import 'package:asisten_buku_kebun/presentation/screens/home/home_screen.dart';
import 'package:asisten_buku_kebun/presentation/screens/map/crop_map_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
// Define a global key for the navigator
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';

  static const String account = '/account';
  static const String cropMapScreen = '/crop-map-screen';

  static const String myCropsScreen = '/my-crops-screen';
  static const String detailCropScreen = '/detail-crop-screen';
  static const String addEditCropScreen = '/add-edit-crop-screen';

  static const String createLogScreen = '/create-log-screen';

  // route pages
  // routes string and pages
  static Map<String, WidgetBuilder> get routes {
    return {
      // Replace with actual widget
      AppRoutes.home: (context) =>  HomeScreen(),
      AppRoutes.login: (context) => LoginScreen(),
      AppRoutes.register: (context) =>  RegisterScreen(),
      AppRoutes.cropMapScreen: (context) =>  CropMapScreen(),
      AppRoutes.myCropsScreen: (context) =>  MyCropsScreen(),
      AppRoutes.detailCropScreen: (context) => DetailCropScreen(),
      AppRoutes.addEditCropScreen: (context) => AddEditCropScreen(),
      AppRoutes.createLogScreen: (context) => CreateLogScreen(),
    };
  }
}