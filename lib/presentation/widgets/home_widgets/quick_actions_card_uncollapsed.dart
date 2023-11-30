import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';

import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';

class QuickActionCardUnCollapsed extends StatelessWidget {
  const QuickActionCardUnCollapsed(
      {required this.imagePath,
      this.width,
      this.height,
      required this.text,
      required this.onTap,
      super.key});
  final String imagePath;
  final double? width;
  final double? height;
  final String text;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 80.h,
          padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                  color: ColorManager.kPrimaryBlue.withOpacity(0.15)),
              color: ColorManager.kPrimaryBlueAccent.withOpacity(0.12)),
          child: Center(
            child: Column(children: [
              Image.asset(
                imagePath,
                height: 24.w,
                width: 24.w,
              ),
              SizedBox(height: 10.h),
              Text(
                text,
                style: get14TextStyle(
                  color: ColorManager.kPrimaryBlue,
                  fontSize: 12.sp,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class QuickActionCardCollapsed extends StatelessWidget {
  const QuickActionCardCollapsed(
      {required this.imagePath,
      this.width,
      this.height,
      required this.title,
      required this.onTap,
      super.key});
  final String imagePath;
  final double? width;
  final double? height;
  final String title;

  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 80.h,
          padding: EdgeInsets.only(
            left: 10.w,
            right: 10.w,
            top: 10.h,
          ),
          decoration: BoxDecoration(
            color: ColorManager.kPrimaryBlueAccent.withOpacity(0.12),
            border:
                Border.all(color: ColorManager.kPrimaryBlue.withOpacity(0.15)),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        imagePath,
                        height: 24.w,
                        width: 24.w,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        title,
                        style: get14TextStyle(
                          color: ColorManager.kPrimaryBlue,
                          fontSize: 11.sp,
                        ),
                      ),
                    ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
