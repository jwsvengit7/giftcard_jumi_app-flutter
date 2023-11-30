import 'package:flutter/material.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';

Future<dynamic> showCustomBottomSheet(
    {required BuildContext context,
    required Widget screen,
    bool? isDismissible,
    bool? showDragHandle,
    bool? enableDrag,
    BoxConstraints? constraints,
    }) async {
  return showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.elliptical(15, 15),
        topRight: Radius.elliptical(15, 15),
      ),
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    barrierColor: ColorManager.kBlack.withOpacity(.2),
    context: context,
    constraints: constraints,
    isScrollControlled: true,
    showDragHandle: showDragHandle,
    isDismissible: isDismissible ?? false,
    builder: (builder) => screen,
    enableDrag: enableDrag ?? false,
  );
}
