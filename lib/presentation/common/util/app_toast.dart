import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showAppToast(
    BuildContext context,
    String message, {
      String? title,
      bool isError = true,
      ToastificationType? type,
      AlignmentGeometry alignment = Alignment.topCenter,
      Duration autoCloseDuration = const Duration(seconds: 4),
      ToastificationStyle style = ToastificationStyle.fillColored,
      bool showProgressBar = false,
    }) {
  toastification.show(
    context: context,
    title: Text(
        title ?? (isError ? 'Oops, Ada yang Salah! 👎' : 'Hore! Sukses! 👍')),
    description: Text(message),
    type: type ??
        (isError ? ToastificationType.error : ToastificationType.success),
    style: style,
    autoCloseDuration: autoCloseDuration,
    alignment: alignment,
    showProgressBar: showProgressBar,
  );
}
