import 'package:asisten_buku_kebun/presentation/resources/app_colors.dart';
import 'package:flutter/material.dart';

class CropSummarySection extends StatelessWidget {
  const CropSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: SummaryCard(
            title: "Total Tanaman",
            value: "12",
            icon: Icons.eco,
            color: AppColors.success900,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: SummaryCard(
            title: "Perlu Perhatian",
            value: "3",
            icon: Icons.warning,
            color: AppColors.warning700,
          ),
        ),
      ],
    );
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
