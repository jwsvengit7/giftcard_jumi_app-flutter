import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/helpers/transaction_helper.dart';
import 'package:jimmy_exchange/core/model/asset_transaction.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/routes_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';

import '../../../core/enum.dart';
import '../../../core/utils/utils.dart';
import '../../resources/route_arg/crypto_arg.dart';
import '../../resources/route_arg/sell_crypto_details_arg.dart';
import '../custom_snackbar.dart';

class ConfirmCryptoSell extends StatefulWidget {
  final CryptoSaleArg param;

  const ConfirmCryptoSell({Key? key, required this.param}) : super(key: key);

  @override
  State<ConfirmCryptoSell> createState() => _ConfirmCryptoSellState();
}

class _ConfirmCryptoSellState<T> extends State<ConfirmCryptoSell> {
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
            "Confirm Sale",
            textAlign: TextAlign.center,
            style: get24TextStyle().copyWith(),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
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
                flex: 1,
                child: buildItemList("Network", widget.param.network.name ?? "",
                    subTitleTextStyle:
                        get16TextStyle().copyWith(fontWeight: FontWeight.w500)),
              ),
              Expanded(
                flex: 1,
                child: buildItemList(
                    "You Pay",
                    widget.param.usd_exchange_rate_to_ngn == null
                        ? "${widget.param.units} ${widget.param.asset.code}"
                        : "${formatCurrency(widget.param.breakDown.payable_amount / (widget.param.usd_exchange_rate_to_ngn ?? 1), code: "USD")}${widget.param.asset.code}",
                    subTitleTextStyle:
                        get16TextStyle().copyWith(fontWeight: FontWeight.w500)),
              ),
              Expanded(
                flex: 1,
                child: buildItemList("You Get",
                    formatCurrency(widget.param.breakDown.payable_amount),
                    subTitleTextStyle:
                        get16TextStyle().copyWith(fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: buildItemList(
                  "Payout to:",
                  widget.param.savedBank.account_name ?? "",
                ),
              ),
              Expanded(
                flex: 1,
                child: buildItemList(
                  "Bank",
                  widget.param.savedBank.bank?.name ?? "",
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: buildItemList(
                  "Account Number",
                  "${widget.param.savedBank.account_number}",
                ),
              ),
              Expanded(
                flex: 1,
                child: buildItemList(
                  "Rate",
                  formatCurrency(widget.param.rate),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

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
                            trade_type: "sell",
                            asset_id: widget.param.asset.id ?? "",
                            network_id: widget.param.network.id ?? "",
                            asset_amount: widget.param.units,
                            comment: widget.param.comment,
                            wallet_address: null,
                            wallet_address_confirmation: null,
                            user_bank_account_id: widget.param.savedBank.id,
                            transaction_pin: transaction_pin);
                    return atxn;
                  }

                  Navigator.popAndPushNamed(
                    context,
                    RoutesManager.sellCryptoDetailsView,
                    arguments: SellCryptoDetailsArg(
                      createTransaction: createTransaction,
                      cryptoSaleArg: widget.param,
                    ),
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
          style: get14TextStyle().copyWith(color: ColorManager.kFormHintText),
        ),
        const SizedBox(height: 7),
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
