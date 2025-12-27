import 'package:asisten_buku_kebun/presentation/resources/app_colors.dart';
import 'package:asisten_buku_kebun/presentation/resources/app_constant.dart';
import 'package:flutter/material.dart';
import '../../resources/text_styles_resources.dart';

Widget textBadge(String badgeText, Color badgeColor, {Color? textColor = AppColors.primary900}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: badgeColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(badgeText, style: bold12.copyWith(
      color: textColor,
    )),
  );
}

Color getColorForStatus(String? status) {
  switch (status?.toLowerCase()) {
    case AppConstant.CROP_MATI:
      return AppColors.danger700;
    case AppConstant.CROP_SAKIT:
      return AppColors.warning700;
    case AppConstant.CROP_DIPANEN:
      return AppColors.info700;
    case AppConstant.CROP_SEHAT:
      return AppColors.success900;
    default:
      return Colors.grey;
  }
}

Widget statusTanamanBadge(String? status) {
  Color color = getColorForStatus(status);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      status ?? "-",
      style: const TextStyle(color: Colors.white, fontSize: 12),
    ),
  );
}