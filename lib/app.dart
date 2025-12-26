import 'package:asisten_buku_kebun/presentation/routing/app_routes.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routing.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'presentation/screens/home_screen.dart';

class App extends StatelessWidget {

  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instruments',
      debugShowCheckedModeBanner: false,
      navigatorKey: AppRouting.navigatorKey,
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
      onGenerateRoute: (RouteSettings settings) {
        final builder = AppRoutes.routes[settings.name];
        if (builder == null) {
          throw Exception('Route ${settings.name} not found');
        }
        return PageRouteBuilder(
          pageBuilder: (context, __, ___) => builder(context),
          transitionDuration: const Duration(milliseconds: 1000),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          settings: settings, // Pass along arguments if needed
        );
      },
    );
  }
}
