import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/core/constants.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';

///Build each row of item on each section of the screen
class TxnRowBuilder extends StatelessWidget {
  const TxnRowBuilder({super.key, required this.name, required this.value});

  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: get14TextStyle().copyWith(
              fontWeight: FontWeight.w400, color: ColorManager.kFormHintText),
        ),
        if (value == Constants.kSellType)
          SizedBox(
            child: Image.asset(ImageManager.kSold),
          )
        else if (value == Constants.kBuyType)
          SizedBox(
            child: Image.asset(ImageManager.kBuy),
          )
        else
          Text(
            value == 'NA' ? value.toUpperCase() : value.toTitleCase(),
            style: get14TextStyle().copyWith(
                fontWeight: FontWeight.w400, color: ColorManager.kBlack),
          )
      ],
    );
  }
}

class TradeType extends StatelessWidget {
  final String? tradeType;
  final String pageReference;

  const TradeType({super.key, this.tradeType, required this.pageReference});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${pageReference.toTitleCase()} ${getTradeType().toTitleCase()}',
      style: get16TextStyle().copyWith(fontWeight: FontWeight.w400),
    );
  }

  String getTradeType() {
    if (tradeType?.toLowerCase() == 'buy') {
      return 'Purchase';
    }
    return tradeType ?? '';
  }
}

///this success badge uses image as icons
class TransactionBadgeImageIcon extends StatelessWidget {
  const TransactionBadgeImageIcon({
    super.key,
    required this.status,
    required this.pageReference,
  });

  final String status;
  final String pageReference;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 64.h,
        width: 90.w,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 6),
              width: 82.w,
              height: 56.1.h,
              decoration: BoxDecoration(
                image: decorationImage(transaction: pageReference),
                color: ColorManager.kWhite,
                borderRadius: BorderRadius.circular(5.61),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 50,
                    offset: Offset(0.0, 2.570),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: StatusBadgeIconSelector(status: status),
            )
          ],
        ));
  }

  DecorationImage decorationImage({required String transaction}) {
    final DecorationImage decoration;
    transaction == 'crypto'
        ? decoration =
            DecorationImage(image: AssetImage(ImageManager.kCryptoReceipt))
        : decoration =
            DecorationImage(image: AssetImage(ImageManager.kWithdrawal));
    return decoration;
  }
}

//This success badge uses custom icons for the body. this was done as
//the original image could not be used it had too much white space around it
class SuccessBadgeCustomIcon extends StatelessWidget {
  const SuccessBadgeCustomIcon({
    super.key,
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 64.h,
        width: 90.w,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 6),
              width: 82.w,
              height: 56.1.h,
              child: Column(children: [
                Expanded(
                    flex: 2,
                    child: Container(
                      color: ColorManager.kWhite,
                    )),
                Expanded(
                    flex: 2,
                    child: Container(
                      color: ColorManager.kBlack.withOpacity(0.2),
                    )),
                Expanded(
                    flex: 6,
                    child: Container(
                      padding: EdgeInsets.only(left: 10.w),
                      color: ColorManager.kWhite,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 12,
                            width: 7,
                            color: ColorManager.kBlack.withOpacity(0.2),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Container(
                            height: 12,
                            width: 7,
                            color: ColorManager.kBlack.withOpacity(0.2),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Container(
                            height: 8.h,
                            width: 7,
                            color: ColorManager.kBlack.withOpacity(0.2),
                          ),
                        ],
                      ),
                    ))
              ]),
              decoration: BoxDecoration(
                color: ColorManager.kWhite,
                borderRadius: BorderRadius.circular(5.61),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 50,
                    offset: Offset(0.0, 2.570),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: StatusBadgeIconSelector(status: status),
            )
          ],
        ));
  }

  DecorationImage decorationImage({required String transaction}) {
    final DecorationImage decoration;
    transaction == 'crypto'
        ? decoration =
            DecorationImage(image: AssetImage(ImageManager.kCryptoReceipt))
        : decoration =
            DecorationImage(image: AssetImage(ImageManager.kWithdrawal));
    return decoration;
  }
}

class SellersBankInfoCapsule extends StatelessWidget {
  final sellersBankName;
  final sellerAccountNumber;
  final double? height;
  final Color? color;
  final Border? border;
  final Color? separatorColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? fontColor;
  final double? dividerPadding;

  const SellersBankInfoCapsule({
    super.key,
    required this.sellersBankName,
    required this.sellerAccountNumber,
    this.height,
    this.color,
    this.border,
    this.separatorColor,
    this.fontSize,
    this.fontWeight,
    this.fontColor,
    this.dividerPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        height: height ?? 26.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.r),
          border: border,
          color: color ?? ColorManager.kPrimaryBlue.withOpacity(0.15),
        ),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                sellersBankName ?? 'NA',
                style: get12TextStyle().copyWith(
                    fontWeight: fontWeight ?? FontWeight.w400,
                    color: fontColor ?? ColorManager.kPrimaryBlue,
                    fontSize: fontSize ?? 12),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: dividerPadding ?? 4.w),
                child: Container(
                  height: 10.h,
                  width: 1.w,
                  color: separatorColor ?? ColorManager.kEllipseBg,
                ),
              ),
              Text(
                sellerAccountNumber ?? 'NA',
                style: get12TextStyle().copyWith(
                    fontWeight: fontWeight ?? FontWeight.w400,
                    color: fontColor ?? ColorManager.kPrimaryBlue,
                    fontSize: fontSize ?? 12),
              ),
            ]),
      ),
    );
  }
}

class StatusBadgeIconSelector extends StatelessWidget {
  // txnDetails?.status?.toLowerCase())
  final String? status;

  const StatusBadgeIconSelector({super.key, this.status});

  @override
  Widget build(BuildContext context) {
    if (status!.toLowerCase() == Constants.kSuccessStatus ||
        status!.toLowerCase() == Constants.kTransferred ||
        status!.toLowerCase() == Constants.kCompletedStatus) {
      return Image.asset(ImageManager.kSuccessIcon);
    } else if (status!.toLowerCase() == Constants.kPending ||
        status!.toLowerCase() == Constants.kPartiallyApprovedStatus) {
      return Image.asset(ImageManager.kTimePending);
    } else if (status!.toLowerCase() == Constants.kDeclinedStatus) {
      return Image.asset(ImageManager.kCancelTiny);
    } else {
      return Icon(Icons.circle);
    }
  }
}

//build the transaction's accojnt name, account number and bank name
class PaymentIfo extends StatelessWidget {
  const PaymentIfo({
    super.key,
    required this.accountNumber,
    required this.accountName,
    required this.bankName,
  });

  final String accountNumber;
  final String accountName;
  final String bankName;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          accountName.toTitleCase() ?? 'NA',
          style: get16TextStyle().copyWith(
              fontWeight: FontWeight.w400, color: ColorManager.kBlack),
        ),
        SellersBankInfoCapsule(
            sellerAccountNumber: accountNumber, sellersBankName: bankName),
      ],
    );
  }
}
