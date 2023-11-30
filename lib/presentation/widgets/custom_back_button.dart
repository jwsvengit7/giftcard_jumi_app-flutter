import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';

class CustomBackButton extends StatelessWidget {
  final double? width;
  final double? height;
  const CustomBackButton({
    this.width,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 36.w,
      height: height ?? 36.w,
      padding: EdgeInsets.only(left: 8.w, right: 5.w, top: 5.h, bottom: 5.h),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: ColorManager.kFormBorder)),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back_ios,
            size: 16.r, color: ColorManager.kPrimaryBlack),
      ),
    );
  }
}
