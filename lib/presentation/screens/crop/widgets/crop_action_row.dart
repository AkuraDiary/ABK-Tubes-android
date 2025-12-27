import 'package:asisten_buku_kebun/DI.dart';
import 'package:asisten_buku_kebun/presentation/resources/app_colors.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routes.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routing.dart';
import 'package:flutter/material.dart';

import '../../../resources/text_styles_resources.dart';

class CropActionRow extends StatelessWidget {
  const CropActionRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.add,
            label: "Tambah Log",

            onTap: () {
              AppRouting().navigateTo(AppRoutes.createLogScreen);
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
            icon: Icons.edit,
            label: "Edit Data",
            onTap: () {
              AppRouting().navigateTo(AppRoutes.addEditCropScreen);
            },
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.primary900,
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.white),
            const SizedBox(height: 6),
            Text(label, style: bold12.copyWith(color: AppColors.white)),
          ],
        ),
      ),
    );
  }
}
