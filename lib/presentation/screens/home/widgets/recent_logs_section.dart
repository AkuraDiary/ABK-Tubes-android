import 'package:flutter/material.dart';

class RecentLogsSection extends StatelessWidget {
  const RecentLogsSection({super.key});

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
          child: const Text(
            "Belum ada catatan terbaru",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
