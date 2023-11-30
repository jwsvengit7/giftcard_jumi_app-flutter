import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/routes_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';

import '../../../core/model/wallet_txn_history.dart';

class SuccessFailedPopup extends StatefulWidget {
  final bool isSuccess;
  final String? title;
  final String? desc;
  final Function? onCancel;
  final String? cancelText;
  final String? proceedText;
  final Function? onProceed;
  final WalletTxnHistory? walletTxnHistory;

  const SuccessFailedPopup({
    Key? key,
    this.title,
    this.desc,
    this.onCancel,
    this.onProceed,
    this.cancelText,
    this.proceedText,
    required this.isSuccess,
    this.walletTxnHistory,
  }) : super(key: key);

  @override
  _SuccessFailedPopupState createState() => _SuccessFailedPopupState();
}

class _SuccessFailedPopupState extends State<SuccessFailedPopup> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Material(
        child: Padding(
          padding: EdgeInsets.only(left: 16.w, top: 50.h, right: 16.w),
          child: Column(children: [
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(55),
                        color: ColorManager.kPrimaryBlue),
                    child: Text("Finish",
                        style: get16TextStyle(
                            color: ColorManager.kWhite,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400))),
              ),
            ),
            SizedBox(height: 50),
            widget.isSuccess
                ? Image.asset(
                    ImageManager.kChecked,
                    width: 58.w,
                    height: 58.w,
                  )
                : Image.asset(ImageManager.kCancel, width: 58.w, height: 58.w),
            SizedBox(height: 25.h),
            widget.isSuccess
                ? Text("Transaction Successful",
                    style: get16TextStyle(
                        color: ColorManager.kBlack,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700))
                : Text("Failure",
                    style: get16TextStyle(
                        color: ColorManager.kBlack,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700)),
            SizedBox(height: 15.h),
            widget.isSuccess
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                        "Your trade is being processed, and you will be credited once it has been approved. ",
                        textAlign: TextAlign.center,
                        style: get16TextStyle(
                            color: ColorManager.kTextColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400)),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                        "Your trade could not be process, kindly retry sometime later",
                        textAlign: TextAlign.center,
                        style: get16TextStyle(
                            color: ColorManager.kTextColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400)),
                  ),
            SizedBox(height: 40.h),
            GestureDetector(
              onTap: () {
                if (widget.isSuccess) {
                  Navigator.pushNamed(
                      context, RoutesManager.walletTxnHistoryDetails,
                      arguments: widget.walletTxnHistory);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.r),
                    border: Border.all(
                        color: ColorManager.kPrimaryBlue.withOpacity(0.15)),
                    color: ColorManager.kUpdateBackground),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.isSuccess)
                      Image.asset(
                        ImageManager.kReceipt,
                        width: 23.32.w,
                        height: 30.h,
                      ),
                    if (widget.isSuccess) SizedBox(width: 10.w),
                    Text("View Receipt",
                        textAlign: TextAlign.center,
                        style: get16TextStyle(
                            color: ColorManager.kPrimaryBlue,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
