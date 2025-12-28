import 'package:asisten_buku_kebun/DI.dart';
import 'package:asisten_buku_kebun/data/model/crop_log_model.dart';
import 'package:asisten_buku_kebun/presentation/common/util/app_formatters.dart';
import 'package:asisten_buku_kebun/presentation/common/util/app_toast.dart';
import 'package:asisten_buku_kebun/presenter/auth_presenter.dart';
import 'package:asisten_buku_kebun/presenter/crop_log_presenter.dart';
import 'package:flutter/material.dart';

class RecentLogsSection extends StatefulWidget {
  CropLogPresenter cropLogPresenter = DI.cropLogPresenter;
  AuthPresenter authPresenter = DI.authPresenter;

  RecentLogsSection({super.key});

  @override
  State<RecentLogsSection> createState() => _RecentLogsSectionState();
}

class _RecentLogsSectionState extends State<RecentLogsSection> {
  List<CropLogModel> _latestLogs = [];

  Future<void> _fetchLatestLogs() async {
    final userId = widget.authPresenter.loggedInUser?.id;
    if (userId != null) {
      try {
        final logs = await widget.cropLogPresenter.fetchLatestCropLogs(userId);
        // You can use the fetched logs as needed
        if (mounted) {
          setState(() {
            _latestLogs = logs;
          });
        }
      } catch (e) {
        // Handle error
        if (!mounted) return;
        showAppToast(
          context,
          'Terjadi Kesalahan : ${widget.cropLogPresenter.message}',
          title: 'Gagal ❌',
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchLatestLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Aktivitas Terakhir",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: _latestLogs.isEmpty
              ? Text(
                  "Belum ada catatan terbaru",
                  style: TextStyle(color: Colors.grey),
                )
              : SingleChildScrollView(
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: _latestLogs
                        .map(
                          (log) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(log.notes ?? ""),
                            subtitle: Text(formatDisplayDate(log.createdAt)),
                          ),
                        )
                        .toList(),
                  ),
                ),
        ),
      ],
    );
  }
}
