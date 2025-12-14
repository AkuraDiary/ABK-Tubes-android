import 'dart:ui';

import 'package:asisten_buku_kebun/presentation/resources/app_colors.dart';
import 'package:asisten_buku_kebun/presentation/resources/text_styles_resources.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class UploadBox extends StatelessWidget {
  final VoidCallback? onTap;

  const UploadBox({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        options: const RoundedRectDottedBorderOptions(radius: Radius.circular(10)),
        // options: DottedBorderOptions(
        //   borderType: ,
        //   color: AppColors.primary500,
        //   dashPattern: const [8, 4],
        //   strokeWidth: 1.5,  
        // ),
        //
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.upload, size: 32, color: AppColors.primary500),
              const SizedBox(height: 8),
              Text(
                "Upload",
                style: semibold16.copyWith(color: AppColors.primary900),
              ),
              const SizedBox(height: 4),
              Text(
                "Drag a file here or click in this area to browse\nin your folder explorer",
                textAlign: TextAlign.center,
                style: regular12.copyWith(color: AppColors.neutral300),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
