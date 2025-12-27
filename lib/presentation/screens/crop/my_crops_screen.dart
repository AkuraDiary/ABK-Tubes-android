import 'package:asisten_buku_kebun/DI.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routes.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routing.dart';
import 'package:asisten_buku_kebun/presenter/auth_presenter.dart';
import 'package:flutter/material.dart';

class MyCropsScreen extends StatefulWidget {
  AuthPresenter authPresenter = DI.authPresenter;

  MyCropsScreen({super.key});

  @override
  State<MyCropsScreen> createState() => _MyCropsScreenState();
}

class _MyCropsScreenState extends State<MyCropsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Crops')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add crop screen
          AppRouting().navigateTo(AppRoutes.addEditCropScreen);
        },
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ListView(
            shrinkWrap: true,
            children: [
              InkWell(
                onTap: () {
                  // Navigate to detail crop screen
                  AppRouting().navigateTo(AppRoutes.detailCropScreen);
                },
                child: const Icon(
                  Icons.add_circle,
                  size: 48,
                  color: Colors.green,
                ),
              ),

              // Here you would typically build a list of crops
            ],
          ),
        ),
      ),
    );
  }
}
