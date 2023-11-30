import 'package:flutter/material.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';

import '../../core/enum.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showCustomSnackBar({
  required BuildContext context,
  Widget? widget,
  String? text,
  Color? backgroundColor,
  NotificationType type = NotificationType.neutral,
  Duration duration = const Duration(milliseconds: 1500),
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: widget ??
          Text(text ?? "An event occured.", textAlign: TextAlign.center),
      duration: duration,
      backgroundColor: backgroundColor ?? getBgColor(type),
    ),
  );
}

Color getBgColor(NotificationType type) {
  if (type == NotificationType.error || type == NotificationType.warning) {
    return ColorManager.kError;
  } else if (type == NotificationType.success) {
    return ColorManager.kSuccess;
  }

  return ColorManager.kBlack;
}
