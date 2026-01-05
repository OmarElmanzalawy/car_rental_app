import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';

class DialogueService {
  static Future<void> showAdaptiveAlertDialog(
    BuildContext context, {
    required String title,
    required String content,
    required List<AlertAction> actions,
    dynamic? icon,
    Color? iconColor,
    double? iconSize,
  }) async {
    await AdaptiveAlertDialog.show(
      context: context,
      title: title,
      message: content,
      actions: actions,
      icon: icon,
      iconColor: iconColor,
      iconSize: iconSize,
    );
  }

  static void showAdaptiveSnackBar(
    BuildContext context, {
    required String message,
    AdaptiveSnackBarType type = AdaptiveSnackBarType.info,
    String? actionLabel,
    VoidCallback? onActionPressed,
  })  {
    AdaptiveSnackBar.show(
      context,
      message: message,
      type: type,
      action: actionLabel,
      onActionPressed: actionLabel != null ? onActionPressed : null,
    );
  }
}
