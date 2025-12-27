import 'package:flutter/material.dart';

class GreetingSection extends StatelessWidget {
  final String name;

  const GreetingSection({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Halo, $name 👋",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          "Pantau kondisi tanamanmu hari ini",
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }
}
