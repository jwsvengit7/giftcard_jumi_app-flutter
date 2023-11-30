import 'package:flutter/material.dart';
import '../../resources/color_manager.dart';

Widget navigatorTab({
  String? imgUrl,
  required String name,
  required Function onTap,
  Widget? rightWidget,
  Color? borderColor,
  double? paddingTop,
  double? paddingBottom,
  double? height,
}) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () => onTap(),
    child: Container(
      height: height ?? 70,
      padding:
          EdgeInsets.only(bottom: paddingBottom ?? 20, top: paddingTop ?? 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: borderColor ?? ColorManager.kTxnTileBorderColor,
          ),
        ),
      ),
      child: Row(
        children: [
          (imgUrl == null)
              ? const SizedBox()
              : Image.asset(imgUrl, width: 20, height: 20),
          const SizedBox(width: 8),
          Text(
            name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const Spacer(),
          rightWidget ?? const Icon(Icons.arrow_forward_ios, size: 15)
        ],
      ),
    ),
  );
}
