import 'package:asisten_buku_kebun/presentation/resources/app_colors.dart';
import 'package:flutter/material.dart';

import '../../resources/text_styles_resources.dart';

class DropdownField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final String hint;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final bool isDisabled;
  final String? Function(T?)? validator;

  const DropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.hint,
    required this.items,
    this.onChanged,
    this.isDisabled = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: semibold14.copyWith(color: AppColors.neutral900)),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: isDisabled ? null : onChanged,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: medium14.copyWith(color: AppColors.neutral700),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            // suffixIcon: const Icon(Icons.arrow_drop_down,
            //     color: AppColors.neutral700),
          ),
          style: medium14.copyWith(
            color: isDisabled ? AppColors.neutral300 : AppColors.neutral900,
          ),
          iconDisabledColor: AppColors.neutral300,
          iconEnabledColor: AppColors.neutral700,
          dropdownColor: Colors.white,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
