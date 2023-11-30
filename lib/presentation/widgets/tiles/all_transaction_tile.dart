import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/core/constants.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';

import '../../../core/model/all_txn_history.dart';
import '../../resources/image_manager.dart';
import '../ellipse.dart';

class AllTransactionTile extends StatelessWidget {
  final AllTxnHistory param;
  final Function onTap;

  const AllTransactionTile(
      {super.key, required this.param, required this.onTap});

  @override
  Widget build(BuildContext context) {
    num _payable_amount = param.payable_amount ?? 0;
    num _previous_payable = calPreviousPartialAmountForAllTxn(param) ?? 0;

    if (param.review_amount != null) {
      _payable_amount = param.review_amount ?? 0;
      _previous_payable = param.payable_amount ?? 0;
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.only(top: 5, bottom: 9),
        decoration: BoxDecoration(
                  color: ColorManager.kGray3.withOpacity(0.30),
                ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 5,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: SizedBox(
                      width: 71,
                      height: 71,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: loadNetworkImage(param.category_icon ?? "",
                            errorDefaultImage: ImageManager.kBtc),
                      ),
                    ),
                  ),
                  SizedBox(width: isSmallScreen(context) ? 8 : 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(formatCurrency(_payable_amount),
                            style: get16TextStyle().copyWith(
                              fontWeight: FontWeight.w700,
                              color: ColorManager.kSecBlue,
                            )),
                        const SizedBox(height: 5),
                        Text(
                          (param.category_name ?? "--").toUpperCase(),
                          style: get14TextStyle().copyWith(
                              color: ColorManager.kGray9.withOpacity(0.9),
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: param.type == Constants.kGiftCardTransaction
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        param.type ==
                                                Constants.kGiftCardTransaction
                                            ? "1 Unit(s)"
                                            : "${formatNumberAlt(param.amount)} Unit(s)",
                                        overflow: TextOverflow.ellipsis,
                                        style: get14TextStyle().copyWith(
                                            color: ColorManager.kGray9,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: buildEllipse(
                                          color: ColorManager.kEllipseBg,
                                          width: 1.w,
                                          height: 10.h),
                                    ),
                                    Flexible(
                                      child: Text(
                                        formatCurrency(param.amount,
                                            code: param.currency ?? "NGN"),
                                        overflow: TextOverflow.ellipsis,
                                        style: get12TextStyle().copyWith(
                                            color: ColorManager.kGray9,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      param.type ==
                                              Constants.kGiftCardTransaction
                                          ? "1 Unit(s)"
                                          : "${formatNumberAlt(param.amount)} Unit(s)",
                                      overflow: TextOverflow.ellipsis,
                                      style: get12TextStyle().copyWith(
                                          color: ColorManager.kGray9,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: buildEllipse(
                                          color: ColorManager.kEllipseBg,
                                          width: 1.w,
                                          height: 10.h),
                                    ),
                                    Text(
                                      formatCurrency(param.amount,
                                          code: param.currency ?? "NGN"),
                                      overflow: TextOverflow.ellipsis,
                                      style: get12TextStyle().copyWith(
                                          color: ColorManager.kGray9,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ),

                                    // SizedBox(
                                    //   width: 8.w,
                                    // ),
                                    BuildTradeType(
                                      transactionType: param.trade_type,
                                    )

                                    ///
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            //
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.w),
                    child: BuildTransactionStatus(
                        transactionStatus: param.status ?? ''),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                    child: Text(formatTimeTwelveHours(param.created_at),
                        style: get12TextStyle().copyWith(
                            fontSize: 12.sp,
                            color: ColorManager.kGreyscale500)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BuildTradeType extends StatelessWidget {
  const BuildTradeType({super.key, required this.transactionType});

  final String? transactionType;

  @override
  Widget build(BuildContext context) {
    if (transactionType?.toTitleCase() == 'buy')
      return Image.asset(ImageManager.kBuy);
    else if (transactionType?.toLowerCase() == 'sell')
      return Image.asset(ImageManager.kSold);
    else
      return Text('...');
  }
}

class BuildTransactionStatus extends StatelessWidget {
  const BuildTransactionStatus({super.key, required this.transactionStatus});

  final String? transactionStatus;

  @override
  Widget build(BuildContext context) {
    if (transactionStatus?.toLowerCase() == Constants.kPartiallyApprovedStatus)
      return Image.asset(
        ImageManager.kTimePending,
        width: 24.w,
        height: 24.h,
      );
    else if (transactionStatus?.toLowerCase() == Constants.kDeclinedStatus)
      return Image.asset(
        ImageManager.kCancelTiny,
        width: 20.w,
        height: 20.h,
      );
    else
      return Image.asset(
        ImageManager.kSuccessIcon,
        width: 24.w,
        height: 24.h,
      );
  }
}
