import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/helpers/transaction_helper.dart';
import 'package:jimmy_exchange/core/model/asset_transaction.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_bottom_sheet.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';


import '../../../core/enum.dart';
import '../../../core/utils/utils.dart';
import '../../resources/route_arg/crypto_arg.dart';
import '../custom_snackbar.dart';
import 'crypto_buy_payment_details.dart';

class ConfirmCryptoBuy extends StatefulWidget {
  final CryptoBuyArg param;

  const ConfirmCryptoBuy({Key? key, required this.param}) : super(key: key);

  @override
  State<ConfirmCryptoBuy> createState() => _ConfirmCryptoBuyState();
}

class _ConfirmCryptoBuyState<T> extends State<ConfirmCryptoBuy> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 19, top: 20),
      color: Colors.white,
      height: 465,
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
            "Confirm Purchase",
            textAlign: TextAlign.center,
            style: get24TextStyle().copyWith(),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 20),
            child: Text(
              "Confirm the details of your trade",
              textAlign: TextAlign.center,
              style: get16TextStyle().copyWith(
                  fontWeight: FontWeight.w400,
                  color: ColorManager.kFormHintText),
            ),
          ),
          //

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: buildItemList("Network", widget.param.network.name ?? "",
                    subTitleTextStyle:
                        get16TextStyle().copyWith(fontWeight: FontWeight.w500)),
              ),
              Expanded(
                flex: 2,
                child: buildItemList("You Pay",
                    formatCurrency(widget.param.breakDown.payable_amount),
                    subTitleTextStyle:
                        get16TextStyle().copyWith(fontWeight: FontWeight.w500)),
              ),
              Expanded(
                  flex: 1,
                  child: buildItemList("Asset", widget.param.asset.code ?? "",
                      subTitleTextStyle: get16TextStyle()
                          .copyWith(fontWeight: FontWeight.w500)))
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                flex: 4,
                child: buildItemList(
                    "Units",
                    formatNumber(num.tryParse(widget.param.units),
                        decimalDigits: 8)),
              ),
              Expanded(
                  flex: 1,
                  child:
                      buildItemList("Rate", formatCurrency(widget.param.rate))),
            ],
          ),

          const SizedBox(height: 12),

          widget.param.comment.isEmpty
              ? const SizedBox()
              : buildItemList("Comment", widget.param.comment),
          widget.param.comment.isEmpty
              ? const SizedBox()
              : const SizedBox(height: 12),

          buildItemList("Wallet Address", widget.param.wallet_address),

          const Spacer(),
          CustomBtn(
              isActive: true,
              loading: loading,
              text: "Proceed",
              onTap: () async {
                try {
                  setState(() => loading = true);

                  createTransaction(String transaction_pin) async {
                    AssetTransaction atxn =
                        await TransactionHelper.createCryptoTxn(
                            trade_type: "buy",
                            asset_id: widget.param.asset.id ?? "",
                            network_id: widget.param.network.id ?? "",
                            asset_amount: widget.param.units,
                            comment: widget.param.comment,
                            wallet_address: widget.param.wallet_address,
                            wallet_address_confirmation:
                                widget.param.wallet_address,
                            user_bank_account_id: null,
                            transaction_pin: transaction_pin);
                    return atxn;
                  }

                  Navigator.pop(context);
                  showCustomBottomSheet(
                    context: context,
                    screen: CryptoBuyPaymentDetails(
                        createTransaction: createTransaction,
                        cryptoBuyArg: widget.param),
                  );

                  setState(() => loading = false);
                } catch (e) {
                  setState(() => loading = false);
                  Navigator.pop(context);
                  showCustomSnackBar(
                    context: context,
                    type: NotificationType.error,
                    text: "$e",
                  );

                  //
                }
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
              get16TextStyle().copyWith(fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
