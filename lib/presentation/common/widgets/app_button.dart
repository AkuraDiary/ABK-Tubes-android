import 'package:asisten_buku_kebun/presentation/resources/app_colors.dart';
import 'package:flutter/material.dart';

enum AppButtonType {
  filled,
  outlined,
}

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final bool isLoading;
  final AppButtonType buttonType;
  final Color? outlineColor;

  const AppButton({
    super.key,
    this.onPressed,
    this.buttonText = "Simpan",
    this.backgroundColor,
    this.textStyle,
    this.textColor,
    this.padding = const EdgeInsets.symmetric(vertical: 14),
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.isLoading = false,
    this.buttonType = AppButtonType.filled,
    this.outlineColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? Theme.of(context).primaryColor;
    final effectiveTextColor = textColor ?? (buttonType == AppButtonType.outlined ? (outlineColor ?? Theme.of(context).primaryColor) : AppColors.white);
    final effectiveOutlineColor = outlineColor ?? Theme.of(context).primaryColor;

    return SizedBox(
      width: double.infinity,
      child: buttonType == AppButtonType.outlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                padding: padding,
                side: BorderSide(color: effectiveOutlineColor),
                shape: RoundedRectangleBorder(borderRadius: borderRadius!),
              ),
              child: isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(effectiveOutlineColor),
                        strokeWidth: 2.0,
                      ),
                    )
                  : Text(
                      buttonText,
                      style: textStyle ?? TextStyle(color: effectiveTextColor),
                      textAlign: TextAlign.center,
                    ),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: effectiveBackgroundColor,
                padding: padding,
                shape: RoundedRectangleBorder(borderRadius: borderRadius!),
              ),
              child: isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          buttonType == AppButtonType.filled
                              ? AppColors.white
                              : effectiveOutlineColor,
                        ),
                        strokeWidth: 2.0,
                      ),
                    )
                  : Text(
                      buttonText,
                      style: textStyle ?? TextStyle(color: effectiveTextColor),
                      textAlign: TextAlign.center,
                    ),
            ),
    );
  }
}