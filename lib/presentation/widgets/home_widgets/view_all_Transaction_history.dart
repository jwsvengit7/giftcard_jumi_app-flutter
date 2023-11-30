import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/routes_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';

class ViewAllTransactionHistory extends StatelessWidget {
  const ViewAllTransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RoutesManager.allTxnHistoryView);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
            color: ColorManager.kGray11,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: ColorManager.kGray10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "View All Transaction History",
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
      ),
    );
  }
}
