import 'package:asisten_buku_kebun/DI.dart';
import 'package:asisten_buku_kebun/data/model/crop_model.dart';
import 'package:asisten_buku_kebun/data/request_state.dart';
import 'package:asisten_buku_kebun/presentation/common/util/app_formatters.dart';
import 'package:asisten_buku_kebun/presentation/common/util/app_toast.dart';
import 'package:asisten_buku_kebun/presentation/common/widgets/badge.dart';
import 'package:asisten_buku_kebun/presentation/resources/app_colors.dart';
import 'package:asisten_buku_kebun/presentation/resources/app_constant.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routes.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routing.dart';
import 'package:asisten_buku_kebun/presenter/auth_presenter.dart';
import 'package:asisten_buku_kebun/presenter/crop_presenter.dart';
import 'package:flutter/material.dart';

class MyCropsScreen extends StatefulWidget {
  AuthPresenter authPresenter = DI.authPresenter;
  CropPresenter cropPresenter = DI.cropPresenter;

  MyCropsScreen({super.key});

  @override
  State<MyCropsScreen> createState() => _MyCropsScreenState();
}

class _MyCropsScreenState extends State<MyCropsScreen> {
  @override
  void initState() {
    super.initState();
    widget.cropPresenter.selectedCrop = null;
    _getMyCrops();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Crops')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary900,
        foregroundColor: AppColors.white,
        onPressed: () {
          // Navigate to add crop screen
          widget.cropPresenter.selectedCrop = null;
          AppRouting().navigateTo(AppRoutes.addEditCropScreen);
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: ListView(
          shrinkWrap: true,
          children: [
            if (widget.cropPresenter.requestState == RequestState.loading)
              const Center(child: CircularProgressIndicator()),
            if (widget.cropPresenter.requestState == RequestState.success)
              if (widget.cropPresenter.myCrops.isEmpty)
                const Center(child: Text('No crops found.'))
              else
                ...widget.cropPresenter.myCrops.map(
                  (crop) => _buildCropItem(crop),
                ),
          ],
        ),
      ),
    );
  }

  Future<void> _getMyCrops() async {
    final userId = widget.authPresenter.loggedInUser?.id;
    setState(() {
      widget.cropPresenter.requestState = RequestState.loading;
    });
    if (userId != null) {
      try {
        await widget.cropPresenter.fetchMyCrops(userId);
        if (!mounted) return;
        if (widget.cropPresenter.requestState == RequestState.success) {
          // Successfully fetched crops, you can update the UI accordingly
          setState(() {
            print(
              "Fetched ${widget.cropPresenter.myCrops.length} crops for user $userId",
            );
          });
        } else {
          showAppToast(
            context,
            'Terjadi Kesalahan : ${widget.cropPresenter.message}',
            title: 'Gagal ❌',
          );
        }
      } catch (e) {
        showAppToast(
          context,
          'Terjadi kesalahan: $e. Silakan coba lagi',
          title: 'Error Tidak Terduga 😢',
        );
      }
    }
  }

  Widget _buildCropItem(CropModel crop) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.primary900,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          crop.cropName ?? "",
          style: TextStyle(color: AppColors.white),
        ),
        onTap: () {
          widget.cropPresenter.selectedCrop = crop;
          AppRouting().navigateTo(AppRoutes.detailCropScreen);
        },
        leading: statusTanamanBadge(
          crop.cropStatus,
        ),
        subtitle: Text(
          'Planted on: ${formatDisplayDate(crop.createdAt)}',
          style: TextStyle(color: AppColors.white),
        ),
      ),
    );
  }
}
