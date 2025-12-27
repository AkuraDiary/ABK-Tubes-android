import 'package:asisten_buku_kebun/data/model/crop_log_model.dart';
import 'package:asisten_buku_kebun/presentation/common/util/app_formatters.dart';
import 'package:asisten_buku_kebun/presentation/common/widgets/badge.dart';
import 'package:asisten_buku_kebun/presentation/resources/app_colors.dart';
import 'package:asisten_buku_kebun/presentation/resources/text_styles_resources.dart';
import 'package:flutter/material.dart';

class CropLogCard extends StatelessWidget {
  final CropLogModel log;

  const CropLogCard({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formatDisplayDate(log.createdAt),
              style: bold12,
            ),
            const SizedBox(height: 8),
            if (log.logTag != null)
              textBadge(
                log.logTag!,
                AppColors.warning100,
              ),
            if (log.notes != null && log.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(log.notes!, style: regular12),
            ],
            if (log.imageUrl != null) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  log.imageUrl!,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
