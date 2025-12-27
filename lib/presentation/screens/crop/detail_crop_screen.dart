import 'package:asisten_buku_kebun/DI.dart';
import 'package:asisten_buku_kebun/data/request_state.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routes.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routing.dart';
import 'package:asisten_buku_kebun/presenter/crop_log_presenter.dart';
import 'package:asisten_buku_kebun/presenter/crop_presenter.dart';
import 'package:flutter/material.dart';

class DetailCropScreen extends StatefulWidget {
  CropPresenter cropPresenter = DI.cropPresenter;
  CropLogPresenter cropLogPresenter = DI.cropLogPresenter;

  DetailCropScreen({super.key});

  @override
  State<DetailCropScreen> createState() => _DetailCropScreenState();
}

class _DetailCropScreenState extends State<DetailCropScreen> {
  @override
  void initState() {
    super.initState();
    _getCropLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.cropPresenter.selectedCrop?.cropName} Detail'),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              // navigate to add log
              AppRouting().navigateTo(AppRoutes.createLogScreen);
            },
            child: const Icon(Icons.add_circle, size: 48, color: Colors.green),
          ),
        ],
      ),
    );
  }

  Future<void> _getCropLogs() async {
    final cropId = widget.cropPresenter.selectedCrop?.cropId;
    if (cropId != null) {
      setState(() {
        widget.cropLogPresenter.requestState = RequestState.loading;
      });
      await widget.cropLogPresenter.fetchCropLogs(cropId);
      setState(() {});
    }
  }
}
