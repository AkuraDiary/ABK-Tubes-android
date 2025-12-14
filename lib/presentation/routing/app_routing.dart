import 'package:asisten_buku_kebun/presentation/routing/app_routes.dart';
import 'package:flutter/material.dart';

class AppRouting {
  // manage navigation with predefined routes in app_routes
  // use singleton pattern to ensure only one instance of AppRouting exists
  // use constructor to initialize the routing and navigator key

  AppRouting._privateConstructor();

  static final AppRouting _instance = AppRouting._privateConstructor();

  factory AppRouting() {
    return _instance;
  }

  // Define a global key for the navigator
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // Define a method to navigate to a named route
  void navigateTo(String routeName, {Object? arguments}) {
    // Use Navigator to push the named route
    // Ensure that the route exists in your app's routing table
    if (arguments != null) {
      Navigator.pushNamed(
        navigatorKey.currentContext!,
        routeName,
        arguments: arguments,
      );
    } else {
      Navigator.pushNamed(navigatorKey.currentContext!, routeName);
    }
  }

  void pop() {
    // Use Navigator to pop the current route
    Navigator.pop(navigatorKey.currentContext!);
  }

  void popUntil(String routeName) {
    // Use Navigator to pop until the specified route
    Navigator.popUntil(
      navigatorKey.currentContext!,
      ModalRoute.withName(routeName),
    );
  }

  void pushReplacement(String routeName, {Object? arguments}) {
    // Use Navigator to push a replacement route
    if (arguments != null) {
      Navigator.pushReplacementNamed(
        navigatorKey.currentContext!,
        routeName,
        arguments: arguments,
      );
    } else {
      Navigator.pushReplacementNamed(navigatorKey.currentContext!, routeName);
    }
  }

  WidgetBuilder? getPage(String route) {
    // Use the routes defined in AppRoutes to get the corresponding widget
    return AppRoutes.routes[route];
  }

  // how to use this routing in the app
  // In your main app widget, you can use the navigatorKey to set up the MaterialApp
  // and use the navigateTo method to navigate between routes.
  // Example:
  // MaterialApp(
  //   navigatorKey: AppRouting.navigatorKey,
  //   initialRoute: AppRoutes.home,
  //   routes: AppRoutes.routes,
  // );
}
