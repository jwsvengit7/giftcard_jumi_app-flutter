import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';

class ReferYourFriend extends StatelessWidget {
  const ReferYourFriend({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Refer Your Friends!",
          style: get16TextStyle(
            color: ColorManager.kGray8,
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
          ).copyWith(decoration: TextDecoration.none),
        ),
        SizedBox(
          height: 15.h,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          decoration: BoxDecoration(
              color: ColorManager.kGray11,
              border: Border.all(color: ColorManager.kBorder.withOpacity(0.30)),
              borderRadius: BorderRadius.circular(5.r)),
          child: Column(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Referral Code",
                style: get14TextStyle(
                  color: ColorManager.kGray1.withOpacity(0.67),
                  fontWeight: FontWeight.w300,
                  fontSize: 14.sp,
                ).copyWith(decoration: TextDecoration.none),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                  border:
                      Border.all(color: ColorManager.kGray3.withOpacity(0.39))),
              child: Row(children: [
                Text(
                  "JMMYXCHANG-1234455",
                  style: get14TextStyle(
                    color: ColorManager.kGray1,
                    fontWeight: FontWeight.w300,
                    fontSize: 14.sp,
                  ).copyWith(decoration: TextDecoration.none),
                ),
                const Spacer(),
                SizedBox(
                  height: 25.h,
                  child: VerticalDivider(color: ColorManager.kPrimaryBlue),
                ),
                SizedBox(
                  width: 20.w,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: Image.asset(
                      ImageManager.kCopy,
                      width: 32.w,
                      height: 32.w,
                    ),
                  ),
                )
              ]),
            ),
            SizedBox(
              height: 10,
            ),
            CustomBtn(
              text: "Share Referral Link",
              isActive: true,
              textStyle: get16TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: ColorManager.kWhite)
                  .copyWith(decoration: TextDecoration.none),
              onTap: () {},
              loading: false,
              boxDecoration: BoxDecoration(
                  color: ColorManager.kPrimaryBlue,
                  borderRadius: BorderRadius.circular(5.r)),
            ),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "View Referral Details",
                  style: get14TextStyle(
                    color: ColorManager.kPrimaryBlue,
                    fontSize: 14.sp,
                  ).copyWith(decoration: TextDecoration.none),
                ),
                SizedBox(width: 7.w),
                Icon(
                  Icons.play_arrow,
                  size: 18.w,
                  color: ColorManager.kPrimaryBlue,
                )
              ],
            ),
          ]),
        ),
      ],
    );
  }
}
