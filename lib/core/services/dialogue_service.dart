import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';

class DialogueService {
  static Future<void> showAdaptiveAlertDialog(BuildContext context,{ required String title, required String content, required List<AlertAction> actions})async{
    await AdaptiveAlertDialog.show(
      context: context,
      title: title,
      actions: actions
    );
  }
}