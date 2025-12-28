import 'package:asisten_buku_kebun/DI.dart';
import 'package:asisten_buku_kebun/data/model/crop_log_model.dart';
import 'package:asisten_buku_kebun/presentation/common/util/app_formatters.dart';
import 'package:asisten_buku_kebun/presentation/common/util/app_toast.dart';
import 'package:asisten_buku_kebun/presenter/auth_presenter.dart';
import 'package:asisten_buku_kebun/presenter/crop_log_presenter.dart';
import 'package:flutter/material.dart';

class RecentLogsSection extends StatelessWidget {
  List<CropLogModel> latestLogs;

  RecentLogsSection({super.key, required this.latestLogs});

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
          child: latestLogs.isEmpty
              ? Text(
                  "Belum ada catatan terbaru",
                  style: TextStyle(color: Colors.grey),
                )
              : ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: latestLogs
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
      ],
    );
  }
}
