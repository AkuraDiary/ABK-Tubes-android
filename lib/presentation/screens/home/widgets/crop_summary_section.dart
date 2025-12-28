import 'package:asisten_buku_kebun/DI.dart';
import 'package:asisten_buku_kebun/presentation/common/util/app_toast.dart';
import 'package:asisten_buku_kebun/presentation/resources/app_colors.dart';
import 'package:asisten_buku_kebun/presentation/resources/app_constant.dart';
import 'package:asisten_buku_kebun/presenter/auth_presenter.dart';
import 'package:asisten_buku_kebun/presenter/crop_presenter.dart';
import 'package:flutter/material.dart';

class CropSummarySection extends StatefulWidget {
  CropPresenter cropPresenter = DI.cropPresenter;
  AuthPresenter authPresenter = DI.authPresenter;

  CropSummarySection({super.key});

  @override
  State<CropSummarySection> createState() => _CropSummarySectionState();
}

class _CropSummarySectionState extends State<CropSummarySection> {

  int totalCrops = 0;
  int sickCrops = 0;
  @override
  void initState() {
    super.initState();
    _calculateCropSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children:  [
        Expanded(
          child: SummaryCard(
            title: "Total Tanaman",
            value: totalCrops.toString(),
            icon: Icons.eco,
            color: AppColors.success900,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: SummaryCard(
            title: "Tanaman Sakit",
            value: sickCrops.toString(),
            icon: Icons.warning,
            color: AppColors.warning700,
          ),
        ),
      ],
    );
  }

  Future<void> _calculateCropSummary()  async {
    try{
      final userId = widget.authPresenter.loggedInUser?.id;
      if (userId != null) {
        await widget.cropPresenter.fetchMyCrops(userId);
        if(!mounted) return;
        setState(() {
          totalCrops = widget.cropPresenter.myCrops.length;
          sickCrops = widget.cropPresenter.myCrops.where((crop) => crop.cropStatus == AppConstant.CROP_SAKIT).length;
        });
      }
    }catch(e){
      if(!mounted) return;
      showAppToast(
        context,
        'Terjadi Kesalahan : ${widget.cropPresenter.message}',
        title: 'Gagal ❌',
      );
    }
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: color)),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
