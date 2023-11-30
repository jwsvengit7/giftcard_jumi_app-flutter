import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/transaction_details_components.dart';
import '../../../core/model/wallet_txn_history.dart';
import '../../resources/image_manager.dart';

class WalletTransactionTile extends StatelessWidget {
  final WalletTxnHistory param;
  final Function onTap;

  const WalletTransactionTile(
      {super.key, required this.param, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap(),
      child: Container(
        // alignment: Alignment.center,
        height: 110.h,
        padding:
            EdgeInsets.only(top: 19.h, bottom: 19.h, left: 10.w, right: 10.w),
        decoration: BoxDecoration(
          color: ColorManager.kGray11,
          border: Border(
            bottom: BorderSide(
              width: 0.1,
              color: ColorManager.kTxnTileBorderColor,
            ),
            top: BorderSide(
              width: 0.1,
              color: ColorManager.kTxnTileBorderColor,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 5,
              child: Row(
                children: [
                  SizedBox(
                    width: 71.w,
                    height: 71.h,
                    child: loadNetworkImage(
                        ImageManager.kWalletTransactionTileIcon,
                        errorDefaultImage: ImageManager.kBtc),
                  ),
                  SizedBox(width: isSmallScreen(context) ? 8.w : 16.w),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(formatCurrency(param.amount),
                              style:
                                  get16TextStyle(color: ColorManager.kSecBlue)),
                          Text(
                            param.summary ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: get16TextStyle().copyWith(
                              color: ColorManager.kGray1,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${formatDateSlash(param.createdAt.toString() ?? "")}",
                    overflow: TextOverflow.ellipsis,
                    style: get12TextStyle().copyWith(
                        fontWeight: FontWeight.w300,
                        color: ColorManager.kGray13,
                        fontSize: 12.sp),
                  ),
                  SizedBox(height: 10.h),
                  StatusBadgeIconSelector(status: param.status),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
