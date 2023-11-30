import 'package:flutter/material.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';

buildEllipse({EdgeInsetsGeometry? margin, Color? color,double? height,double? width}) {
  return Container(
    margin: margin,
    height: height??2,
    width: width??2,
    decoration: BoxDecoration(
      color: color ?? ColorManager.kEllipseBg,
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

Widget buildLoader() {
  return Center(
    child: CircularProgressIndicator(
      strokeWidth: 1.0,
      valueColor: AlwaysStoppedAnimation<Color>(ColorManager.kPrimaryBlack),
    ),
  );
}

Widget buildDivider({
  double? thickness,
  Color? color,
  double? height,
  EdgeInsetsGeometry? padding,
}) {
  return Padding(
    padding: padding ?? EdgeInsets.zero,
    child: Divider(
        height: height ?? 0,
        thickness: thickness ?? 0.7,
        color: color ?? ColorManager.kFormBg),
  );
}
