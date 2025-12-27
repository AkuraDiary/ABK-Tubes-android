import 'package:asisten_buku_kebun/presentation/common/widgets/app_button.dart';
import 'package:asisten_buku_kebun/presentation/resources/app_colors.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routes.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routing.dart';
import 'package:flutter/material.dart';

class PrimaryActionsSection extends StatelessWidget {
  const PrimaryActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Aksi Cepat",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AppButton(
                buttonText: "Tanamanku",
                backgroundColor: AppColors.primary900,
                textColor: AppColors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                onPressed: () {
                  AppRouting().navigateTo(AppRoutes.myCropsScreen);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                buttonText: "Tambah Tanaman",
                outlineColor: AppColors.primary900,
                buttonType: AppButtonType.outlined,
                onPressed: () {
                  AppRouting().navigateTo(AppRoutes.addEditCropScreen);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
