import 'package:asisten_buku_kebun/DI.dart';
import 'package:asisten_buku_kebun/data/request_state.dart';
import 'package:asisten_buku_kebun/presentation/common/util/app_toast.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routes.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routing.dart';
import 'package:asisten_buku_kebun/presentation/screens/crop/widgets/crop_action_row.dart';
import 'package:asisten_buku_kebun/presentation/screens/crop/widgets/crop_header_card.dart';
import 'package:asisten_buku_kebun/presentation/screens/crop/widgets/crop_log_section.dart';
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
    final crop = widget.cropPresenter.selectedCrop;
    return Scaffold(
      appBar: AppBar(
        title: Text('${crop?.cropName ?? "-"} Detail'),
      ),
      body: RefreshIndicator(
        onRefresh: _getCropLogs,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CropHeaderCard(crop: crop),
            const SizedBox(height: 16),
            CropActionRow(),
            const SizedBox(height: 24),
            CropLogSection(
              presenter: widget.cropLogPresenter,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getCropLogs() async {
    final cropId = widget.cropPresenter.selectedCrop?.cropId;
    if (cropId != null) {
      setState(() {
        widget.cropLogPresenter.requestState = RequestState.loading;
      });
      try {
        await widget.cropLogPresenter.fetchCropLogs(cropId);
        if (!mounted) return;
        if (widget.cropLogPresenter.requestState == RequestState.success) {
          // Successfully fetched crop logs, you can update the UI accordingly
          setState(() {
            print(
              "Fetched ${widget.cropLogPresenter.cropLogs.length} logs for crop $cropId",
            );
          });
        } else {
          showAppToast(
            context,
            'Terjadi Kesalahan : ${widget.cropLogPresenter.message}',
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
}
