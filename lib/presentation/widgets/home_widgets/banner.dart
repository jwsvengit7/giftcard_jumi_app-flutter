import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/core/utils/apputils.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_bottom_sheet.dart';
import 'package:jimmy_exchange/presentation/widgets/home_widgets/card_and_crpto_rates.dart';

class Banners extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, RoutesManager.bannerView);
        showCustomBottomSheet(
            context: context,
            enableDrag: true,
            isDismissible: true,
            showDragHandle: false,
            //  constraints: BoxConstraints(minHeight: 500,maxHeight: 700),
            screen: CardAndCryptoRates());
      },
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Banners",
              style: get16TextStyle(
                color: ColorManager.kGray8,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ).copyWith(decoration: TextDecoration.none),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF4385F5),
                    Color(0xFF4743F5), // Start color
                    // End color
                  ],
                  stops: [0.43, 1.0], // 43% from left to right
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(10.r)),
            child: Column(
              children: [
                Row(children: [
                  Image.asset(
                    ImageManager.kAnnouncement,
                    width: 62.w,
                    height: 82.h,
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Latest Card Rates Updates!",
                        style: get14TextStyle(
                          color: ColorManager.kWhite.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ).copyWith(decoration: TextDecoration.none),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Walmart Visa: 56,000",
                                style: get14TextStyle(
                                  color: ColorManager.kWhite.withOpacity(0.8),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ).copyWith(decoration: TextDecoration.none),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                "Sephora: 36,000",
                                style: get14TextStyle(
                                  color: ColorManager.kWhite.withOpacity(0.8),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ).copyWith(decoration: TextDecoration.none),
                              ),
                            ],
                          ),
                          SizedBox(width: 20.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Razor Gold: 42,000",
                                style: get14TextStyle(
                                  color: ColorManager.kWhite.withOpacity(0.8),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ).copyWith(decoration: TextDecoration.none),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                "Plus Jakarta Display",
                                style: get14TextStyle(
                                  color: ColorManager.kWhite.withOpacity(0.8),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ).copyWith(decoration: TextDecoration.none),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  )
                ]),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          AppUtils.divider(0.5, Color.fromARGB(221, 153, 151, 151), 1),
          SizedBox(
            height: 10,
          ),
          Text(
            "Tap  to view  Rates",
            style: get14TextStyle(
              color: ColorManager.kBlack2,
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
            ).copyWith(decoration: TextDecoration.none),
          ),
          SizedBox(
            height: 10,
          ),
          AppUtils.divider(0.5, Color.fromARGB(221, 153, 151, 151), 1),
        ],
      ),
    );
  }
}
