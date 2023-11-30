import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/model/asset_transaction.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/route_arg/sell_crypto_details_arg.dart';
import 'package:jimmy_exchange/presentation/resources/routes_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';

import '../../../core/utils/utils.dart';
import '../../resources/route_arg/crypto_arg.dart';

class CryptoBuyPaymentDetails extends StatefulWidget {
  final CryptoBuyArg cryptoBuyArg;
  final Future<AssetTransaction> Function(String transaction_pin)
      createTransaction;
  const CryptoBuyPaymentDetails(
      {Key? key, required this.createTransaction, required this.cryptoBuyArg})
      : super(key: key);

  @override
  State<CryptoBuyPaymentDetails> createState() =>
      _CryptoBuyPaymentDetailsState();
}

class _CryptoBuyPaymentDetailsState<T> extends State<CryptoBuyPaymentDetails> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 19, top: 20),
      color: Colors.white,
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Image.asset(ImageManager.kStar, width: 24),
              ),
            ),
          ),

          Text(
            "Payment Details",
            textAlign: TextAlign.center,
            style: get24TextStyle().copyWith(),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 10),
            child: Text(
              "To complete your purchase",
              textAlign: TextAlign.center,
              style: get16TextStyle().copyWith(
                  fontWeight: FontWeight.w300,
                  color: ColorManager.kFormHintText),
            ),
          ),
          Text(
            "PAY",
            textAlign: TextAlign.center,
            style: get14TextStyle().copyWith(
                fontWeight: FontWeight.w300, color: ColorManager.kFormHintText),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: Text(
              formatCurrency(widget.cryptoBuyArg.breakDown.payable_amount),
              textAlign: TextAlign.center,
              style: get32TextStyle().copyWith(fontWeight: FontWeight.w500),
            ),
          ),

          Text(
            "TO",
            textAlign: TextAlign.center,
            style: get14TextStyle().copyWith(
                fontWeight: FontWeight.w300, color: ColorManager.kFormHintText),
          ),
          const SizedBox(height: 4),
          Text(
            "0586780032",
            textAlign: TextAlign.center,
            style: get16TextStyle().copyWith(fontWeight: FontWeight.w500),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              "KSBDATATECH LTD",
              textAlign: TextAlign.center,
              style: get16TextStyle().copyWith(fontWeight: FontWeight.w400),
            ),
          ),
          Text(
            "GTBank",
            textAlign: TextAlign.center,
            style: get16TextStyle().copyWith(fontWeight: FontWeight.w500),
          ),
          //

          const Spacer(),
          CustomBtn(
              isActive: true,
              loading: loading,
              text: "I have transferred funds",
              onTap: () async {
                Navigator.popAndPushNamed(
                  context,
                  RoutesManager.confirmCryptoTxn,
                  arguments: ConfirmCryptoTxnArg(
                      createTransaction: widget.createTransaction,
                      trade_type: "buy"),
                );
              })
        ],
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
          style: get14TextStyle().copyWith(color: ColorManager.kFormHintText),
        ),
        const SizedBox(height: 4),
        Text(
          subTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: subTitleTextStyle ??
              get16TextStyle().copyWith(fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
