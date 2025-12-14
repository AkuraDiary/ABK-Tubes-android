import 'package:asisten_buku_kebun/presentation/resources/app_colors.dart';
import 'package:asisten_buku_kebun/presentation/resources/text_styles_resources.dart';
import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String role;
  final DateTime timestamp;
  final String actionText;
  final String badgeText;
  final VoidCallback? onTap;

  const ActivityCard({
    super.key,
    required this.avatarUrl,
    required this.name,
    required this.role,
    required this.timestamp,
    required this.actionText,
    required this.badgeText,
    this.onTap,
  });

  String get _formattedTime {

    // Format as "25 Juli 08.08 WIB"
    // You can plug in intl package for real formatting
    return '${timestamp.day} ${_monthName(timestamp.month)} '
        '${timestamp.hour.toString().padLeft(2, '0')}.'
        '${timestamp.minute.toString().padLeft(2, '0')} WIB';
  }

  String _monthName(int m) => [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des'
      ][m - 1];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                avatarUrl,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formattedTime,
                  style: regular12,
                ),
                const SizedBox(height: 4),
                Text(name, style: extraBold16),
                Text(role, style: bold12.copyWith(color: AppColors.primary900)),
              ],
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: 2,
              color: AppColors.neutral900,
              child: const SizedBox(
                height: 70,
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(actionText,
                    overflow: TextOverflow.ellipsis, style: extraBold12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warning200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(badgeText, style: bold12),
                ),
              ],
            ),

            const SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                // Makes the button circular
                padding: const EdgeInsets.all(4),
                // Adjust padding to control size
                backgroundColor: AppColors.primary900,
                // Background color of the circle
                foregroundColor: AppColors.white, // Color of the icon/text
              ),
              child: const Icon(
                Icons.arrow_forward,
                size: 40,
              ),
              onPressed: () {},
            ),
            // Icon(Icons.arrow_forward, color: AppColors.white),
          ],
        ),
      ),
    );
  }
}
