import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';

import 'package:jimmy_exchange/presentation/widgets/home_widgets/rate_item.dart';

class GiftCardAndCryptoRates extends StatelessWidget {
  ///This widget represent the show card and crypto rate for sale and purchase of giftcards and crpto
  ///
  const GiftCardAndCryptoRates({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 600 / MediaQuery.of(context).size.height.h,
        // minChildSize: 0.3, // Minimum child size when fully collapsed
        // maxChildSize: 0.7, // Maximum child size when fully expanded
        maxChildSize: 0.8,
        minChildSize: 0.1,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            padding: EdgeInsets.only(top: 10.h),
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: 5.h,
                  width: 78.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: ColorManager.kBorder),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Card Rates",
                  style: get18TextStyle(
                    color: ColorManager.kGray9.withOpacity(0.9),
                    fontSize: 18.sp,
                  ).copyWith(decoration: TextDecoration.none),
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: 30,
                    itemBuilder: (BuildContext context, int index) {
                      return RateItem();
                    },
                    separatorBuilder: ((context, index) => Divider(
                          height: 0,
                        )),
                  ),
                ))
              ],
            ),
          );
        });
  }
}
