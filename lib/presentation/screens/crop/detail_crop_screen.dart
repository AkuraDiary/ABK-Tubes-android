import 'package:asisten_buku_kebun/presentation/routing/app_routes.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routing.dart';
import 'package:flutter/material.dart';

class DetailCropScreen extends StatelessWidget {
  const DetailCropScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crop Details')),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              // navigate to add log
              AppRouting().navigateTo(AppRoutes.createLogScreen);
            },
            child: const Icon(
              Icons.add_circle,
              size: 48,
              color: Colors.green,
            ),
          )
        ],
      ),
    );
  }
}
