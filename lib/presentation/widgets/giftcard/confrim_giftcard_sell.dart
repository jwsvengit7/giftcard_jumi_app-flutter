import 'dart:io';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/core/helpers/transaction_helper.dart';
import 'package:jimmy_exchange/core/model/saved_bank.dart';
import 'package:jimmy_exchange/core/providers/txn_history_provider.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/route_arg/giftcard_arg.dart';
import 'package:jimmy_exchange/presentation/resources/routes_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_back_button.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';
import 'package:jimmy_exchange/presentation/widgets/popups/index.dart';
import 'package:jimmy_exchange/presentation/widgets/popups/success_failed_popup.dart';
import 'package:jimmy_exchange/presentation/widgets/saved_bank.dart';
import 'package:provider/provider.dart';

import '../../resources/color_manager.dart';

class ConfirmGiftCardSell extends StatefulWidget {
  final String name;
  final List<SellGiftCard2Arg> arg;


  const ConfirmGiftCardSell(
      {Key? key, required this.name, required this.arg, })
      : super(key: key);

  @override
  State<ConfirmGiftCardSell> createState() => _ConfirmGiftCardSellState();
}

class _ConfirmGiftCardSellState<T> extends State<ConfirmGiftCardSell> {
  late SavedBank savedBank;
  late SellGiftCard2Arg details;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    savedBank = widget.arg.first.selectedBank!;
    details = widget.arg.first;
  }

  String calTotalSum() {
    List<SellGiftCard2Arg> sellArgLst = widget.arg;

    num total = 0;

    for (final SellGiftCard2Arg el in sellArgLst) {
      total = total + (el.oneUnitPayable * el.quantity);
    }

    return formatCurrency(total);
  }

  int getGiftCardsLength() {
    List<SellGiftCard2Arg> sellArgLst = widget.arg;
    return sellArgLst.length;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 22, top: 70),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomBackButton(),
                SizedBox(width: 50.w),
                Text(
                  widget.name,
                  style: get24TextStyle()
                      .copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            GiftCardSpecifications(
              details: details,
            ),
            SizedBox(height: 20.h),
            _Cost(
              details: details,
            ),
            SizedBox(height: 20.h),
            _PayoutAccout(
              details: details,
            ),
            // Text(
            //   "Total Sum",
            //   style: get14TextStyle().copyWith(
            //     color: ColorManager.kFormHintText,
            //   ),
            // ),

            //
            // Text(
            //   calTotalSum(),
            //   style: get16TextStyle().copyWith(fontSize: 40),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 10),
            //   child: Text("${getGiftCardsLength()} Sale(s)"),
            // ),
            //
            // const Spacer(),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Flexible(
            //       child: buildItemList(
            //           "Account Number", "${savedBank.account_number}"),
            //     ),
            //     Flexible(
            //       child: buildItemList("Bank", "${savedBank.bank?.name}"),
            //     ),
            //     Flexible(
            //       child: buildItemList(
            //         "Account Name",
            //         "${savedBank.account_name}",
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(height: 32.h),
            CustomBtn(
                isActive: true,
                loading: false,
                text: "Sell Giftcard",
                onTap: () async {
                  String? transaction_pin = await Navigator.pushNamed<String>(
                      context, RoutesManager.transactionPin);
                  if (transaction_pin == null) {
                    throw "Error! Please enter a correct PIN";
                  }
                  setState(() => isLoading = true);

                  try {
                    // THIS IS A POOR IMPLEMENTATION BUT THAT'S WHAT THE CLIENT WANTS..
                    List<String> imgLinks = [];

                    for (File file in details.giftCardFiles) {
                      String _res = await uploadImageToCloudinary(file);
                      imgLinks.add(_res);

                      // setState(() {
                      //   totalUploadedImageCount =
                      //       totalUploadedImageCount + 1;
                      // });
                    }

                    // TransactionHelper.createGiftcardSale(
                    //   giftcard_product_id: details.giftcardProduct.id ?? "",
                    //   user_bank_account_id: details.selectedBank?.id ?? "",
                    //   card_type: details.card_type,
                    //   amount: details.amount.toString(),
                    //   quantity: details.quantity.toString(),
                    //   comment: details.comment,
                    //   imgs: imgLinks,
                    //   virtualCode: [],
                    //   virtualPin: [],
                    //   transaction_pin: transaction_pin,
                    //   upload_type: "media",
                    // ).then((value) {
                    //   print("I was sucessful");
                    //   showDialogPopup(
                    //     context,
                    //     SuccessFailedPopup(
                    //       isSuccess: true,
                    //       title: "Success",
                    //       desc:
                    //           "Your trade is being processed, and you will be credited once it has been approved by the admin.",
                    //       proceedText: "Done",
                    //       onProceed: () {
                    //         Navigator.pop(context);
                    //         Navigator.pop(context);
                    //         Navigator.pop(context);
                    //       },
                    //     ),
                    //   );
                    // });
                  } catch (err) {
                    throw "Error:: ${err.toString()}";
                  }

                  await Provider.of<TxnHistoryProvider>(context, listen: false)
                      .updateGiftcardTxnHistory();
                  await updateTxnHistory(context);
                  Navigator.pushNamed(context, RoutesManager.transactionStatus,
                      arguments: true);
                })
          ],
        ),
      ),
    );
  }

  Widget buildItemList(String title, String subTitle,
      {TextStyle? subTitleTextStyle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: get14TextStyle().copyWith(
            color: ColorManager.kFormHintText,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: subTitleTextStyle ??
              get16TextStyle().copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class GiftCardSpecifications extends StatelessWidget {
  const GiftCardSpecifications({required this.details});

  final SellGiftCard2Arg details;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
      decoration: BoxDecoration(
          color: ColorManager.kGray11,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: ColorManager.kBorder.withOpacity(0.30))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Giftcard Specifications",
          style: get16TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: ColorManager.kPrimaryBlack),
        ),
        SizedBox(height: 30.h),
        buildItem(item: "Category", value: details.giftCardCategory.name!),
        SizedBox(height: 30.h),
        buildItem(item: "Country", value: details.country.name!),
        SizedBox(height: 30.h),
        buildItem(item: "Product", value: details.giftCardProduct.name!),
        SizedBox(height: 30.h),
        buildItem(item: "Type", value: details.card_type),
      ]),
    );
  }

  Widget buildItem({required String item, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              item,
              style: get16TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: ColorManager.kFormHintText),
            ),
            const Spacer()
          ],
        ),
        SizedBox(height: 5.h),
        Text(
          value,
          style: get16TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: ColorManager.kBlack),
        ),
      ],
    );
  }
}

class _Cost extends StatelessWidget {
  const _Cost({required this.details, super.key});

  final SellGiftCard2Arg details;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
      decoration: BoxDecoration(
          color: ColorManager.kGray11,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: ColorManager.kBorder.withOpacity(0.30))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Cost",
          style: get16TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: ColorManager.kPrimaryBlack),
        ),
        SizedBox(
          height: 30.h,
        ),
        buildItems(title: "Amount", value: "\$" + details.amount.toString()),
        SizedBox(
          height: 15.h,
        ),
        DottedLine(
          dashLength: 8.w,
          dashGapLength: 8.w,
          dashColor: ColorManager.kBorder,
        ),
        SizedBox(
          height: 15.h,
        ),
        buildItems(title: "Units", value: details.quantity.toString()),
        SizedBox(
          height: 15.h,
        ),
        DottedLine(
          dashLength: 8.w,
          dashGapLength: 8.w,
          dashColor: ColorManager.kBorder,
        ),
        SizedBox(
          height: 15.h,
        ),
        buildItems(
            title: "Rate",
            value: "N" + details.giftCardProduct.sell_rate.toString()),
      ]),
    );
  }

  Widget buildItems({required String title, required String value}) {
    return Row(
      children: [
        Text(
          title,
          style: get16TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: ColorManager.kFormHintText),
        ),
        const Spacer(),
        Text(
          value,
          style: get16TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: ColorManager.kBlack),
        ),
      ],
    );
  }
}

class _PayoutAccout extends StatelessWidget {
  const _PayoutAccout({required this.details, super.key});

  final SellGiftCard2Arg details;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
      decoration: BoxDecoration(
          color: ColorManager.kGray11,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: ColorManager.kBorder.withOpacity(0.30))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Payout Account",
          style: get16TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: ColorManager.kPrimaryBlack),
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  details.selectedBank!.account_name!,
                  style: get16TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: ColorManager.kBlack),
                ),
                SizedBox(
                  height: 10.h,
                ),
                BankNameNumberCapsule(
                  current: details.selectedBank!,
                )
              ],
            ),
            const Spacer(),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image.asset(ImageManager.kEdit))
          ],
        )
      ]),
    );
  }
}
