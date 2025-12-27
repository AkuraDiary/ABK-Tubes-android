import 'package:asisten_buku_kebun/data/model/crop_model.dart';
import 'package:asisten_buku_kebun/presentation/common/util/app_formatters.dart';
import 'package:asisten_buku_kebun/presentation/common/widgets/badge.dart';
import 'package:asisten_buku_kebun/presentation/resources/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../resources/text_styles_resources.dart';

class CropHeaderCard extends StatelessWidget {
  final CropModel? crop;

  const CropHeaderCard({super.key, required this.crop});

  @override
  Widget build(BuildContext context) {
    if (crop == null) return const SizedBox();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              crop!.cropName ?? "-",
              style: bold16,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                textBadge(
                  crop!.type ?? "-",
                  AppColors.white,
                ),
                const SizedBox(width: 8),
                statusTanamanBadge(crop!.cropStatus),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14),
                const SizedBox(width: 6),
                Text(
                  "Ditanam : ${formatDisplayDate(crop!.createdAt)}",
                  style: regular12,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
