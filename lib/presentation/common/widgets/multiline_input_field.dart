import 'package:asisten_buku_kebun/presentation/resources/app_colors.dart';
import 'package:asisten_buku_kebun/presentation/resources/text_styles_resources.dart';
import 'package:flutter/material.dart';


class MultilineInputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLines;
  final int? minLines;
  final bool isDisabled;
  final bool isGrayed;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const MultilineInputField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 6,
    this.minLines,
    this.isDisabled = false,
    this.isGrayed = false,
    this.validator,
    this.keyboardType = TextInputType.multiline,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    bool isTextEmpty = controller.text.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: semibold14.copyWith(color: AppColors.neutral900)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType ?? TextInputType.multiline,
          readOnly: isDisabled,
          validator: validator,
          onChanged: onChanged,
          minLines: minLines ?? 4,
          maxLines: maxLines,
          style: medium14.copyWith(
            color: isGrayed ? AppColors.neutral700 : AppColors.neutral900,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: medium14.copyWith(color: AppColors.neutral700),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
