import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';

class RateTypeHeader extends StatelessWidget {
  const RateTypeHeader({required this.image, required this.title, super.key});
  final String image;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 5.w, top: 5.h, right: 8.w, bottom: 6.h),
        decoration: BoxDecoration(
          color: ColorManager.kUpdateBackground,
          border:
              Border.all(color: ColorManager.kPrimaryBlue.withOpacity(0.15)),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: [
            Image.asset(
              image,
              width: 10.w,
              height: 10.2,
            ),
            SizedBox(
              width: 5.w,
            ),
            Text(
              title,
              style: get16TextStyle(
                color: ColorManager.kPrimaryBlue,
                fontWeight: FontWeight.w300,
                fontSize: 10.sp,
              ).copyWith(decoration: TextDecoration.none),
            ),
          ],
        ));
  }
}
