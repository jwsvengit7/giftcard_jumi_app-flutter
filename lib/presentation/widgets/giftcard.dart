import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/core/model/giftcard_category.dart';
import 'package:jimmy_exchange/core/model/giftcard_product.dart';

import '../../core/utils/utils.dart';
import '../resources/color_manager.dart';
import '../resources/styles_manager.dart';

Widget buildGiftcardCategoryTile(
    {required GiftcardCategory current,
    required Function onTap,
    required bool selected}) {
  return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.only(top: 30.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: ColorManager.kCategoryOrange),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: loadNetworkImage(current.icon ?? "",
                  width: 60.w, height: 60.w),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  current.name ?? "",
                  textAlign: TextAlign.center,
                  style: get16TextStyle().copyWith(
                    color: ColorManager.kWhite,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
      // child: Row(
      //   children: [
      //     ClipRRect(
      //       borderRadius: BorderRadius.circular(50),
      //       child: loadNetworkImage(current.icon ?? "", width: 32, height: 32),
      //     ),
      //     const SizedBox(width: 16),
      //     Expanded(
      //       child: Text(
      //         current.name ?? "",
      //         style: get16TextStyle().copyWith(
      //           color: ColorManager.kGray1,
      //           fontWeight: FontWeight.w400,
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      );
}

Widget buildGiftcardProductTile(
    {required GiftcardProduct current,
    required Function onTap,
    bool? isFirst,
    required bool selected}) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () => onTap(),
    child: Container(
      decoration: BoxDecoration(
          color: ColorManager.kGray11,
          borderRadius: isFirst == null
              ? null
              : isFirst
                  ? BorderRadius.only(
                      topRight: Radius.circular(8.r),
                      topLeft: Radius.circular(8.r))
                  : BorderRadius.only(
                      bottomLeft: Radius.circular(8.r),
                      bottomRight: Radius.circular(8.r)),
          border: isFirst == null
              ? Border(
                  left: BorderSide(color: ColorManager.kBorder),
                  right: BorderSide(color: ColorManager.kBorder),
                  top: BorderSide(width: 0, color: ColorManager.kBorder),
                  bottom: BorderSide(width: 0, color: ColorManager.kBorder))
              : isFirst
                  ? Border(
                      left: BorderSide(color: ColorManager.kBorder),
                      right: BorderSide(color: ColorManager.kBorder),
                      top: BorderSide(color: ColorManager.kBorder),
                      bottom: BorderSide(width: 0, color: ColorManager.kBorder))
                  : Border(
                      left: BorderSide(color: ColorManager.kBorder),
                      right: BorderSide(color: ColorManager.kBorder),
                      top: BorderSide(width: 0, color: ColorManager.kBorder),
                      bottom: BorderSide(color: ColorManager.kBorder))),
      padding:
          EdgeInsets.only(left: 20.w, top: 20.h, right: 20.w, bottom: 20.h),
      child: Row(children: [
        loadNetworkImage("", width: 71.w, height: 71.w),
        SizedBox(
          width: 10.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                current.name ?? "",
                softWrap: true,
                style: get16TextStyle().copyWith(
                  color: ColorManager.kBlack,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                        color: ColorManager.kPrimaryBlue.withOpacity(0.15)),
                    color: ColorManager.kUpdateBackground),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        "Rate: ${formatCurrency(current.sell_rate, code: current.currency!["code"])}",
                        style: get14TextStyle().copyWith(
                            color: ColorManager.kPrimaryBlue,
                            fontWeight: FontWeight.w400)),
                    SizedBox(
                      height: 8.h,
                      child: VerticalDivider(),
                    ),
                    Text(
                      "Minimum: ${formatCurrency(current.sell_min_amount, code: current.currency!["code"])}",
                      style: get14TextStyle().copyWith(
                        color: ColorManager.kPrimaryBlue,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.arrow_forward_ios,
          size: 12.w,
        )
      ]),
    ),
  
  );
}

