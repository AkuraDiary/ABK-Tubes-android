import 'package:asisten_buku_kebun/DI.dart';
import 'package:asisten_buku_kebun/data/request_state.dart';
import 'package:asisten_buku_kebun/presentation/common/util/app_formatters.dart';
import 'package:asisten_buku_kebun/presentation/common/util/app_toast.dart';
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
    _getMyCrops();
  }

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
              if (widget.cropPresenter.requestState == RequestState.loading)
                const Center(child: CircularProgressIndicator()),
              if (widget.cropPresenter.requestState == RequestState.success)
                if (widget.cropPresenter.myCrops.isEmpty)
                  const Center(child: Text('No crops found.'))
                else
                  ...widget.cropPresenter.myCrops.map(
                    (crop) => InkWell(
                      onTap: () {
                        widget.cropPresenter.selectedCrop = crop;
                        AppRouting().navigateTo(AppRoutes.detailCropScreen);
                      },
                      child: ListTile(
                        title: Text(crop.cropName ?? ""),
                        leading: Badge(
                          label: Text(crop.cropStatus ?? ""),
                          backgroundColor: _getCropStatusColor(crop.cropStatus?.toLowerCase()),
                        ),
                        subtitle: Text(
                          'Planted on: ${formatDisplayDate(crop.createdAt)}',
                        ),
                      ),
                    ),
                  ),
            ],
          ),
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

  Color? _getCropStatusColor(String? cropStatus) {
    switch (cropStatus) {
      case AppConstant.CROP_SEHAT:
        return Colors.green;
      case AppConstant.CROP_SAKIT:
        return Colors.yellow;
      case AppConstant.CROP_MATI:
        return Colors.red;
      case AppConstant.CROP_DIPANEN:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
