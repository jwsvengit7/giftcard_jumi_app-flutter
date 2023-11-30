import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_appbar.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_scaffold.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/enum.dart';
import '../../resources/route_arg/sell_crypto_details_arg.dart';
import '../../resources/routes_manager.dart';
import '../../widgets/custom_snackbar.dart';

class SellCryptoDetailsView extends StatefulWidget {
  final SellCryptoDetailsArg param;
  const SellCryptoDetailsView({super.key, required this.param});

  @override
  State<SellCryptoDetailsView> createState() => _SellCryptoDetailsViewState();
}

class _SellCryptoDetailsViewState extends State<SellCryptoDetailsView> {
  bool loading = false;

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CustomScaffold(
        backgroundColor: ColorManager.kWhite,
        appBar: CustomAppBar(
          title: Text("Sell Crypto", style: get20TextStyle()),
        ),
        body: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.only(left: 16, right: 16, top: 35),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Text(
                    "Payment Details",
                    textAlign: TextAlign.center,
                    style: get24TextStyle(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 12),
                    child: Text(
                      "To complete your purchase",
                      textAlign: TextAlign.center,
                      style: get16TextStyle().copyWith(
                        fontWeight: FontWeight.w400,
                        color: ColorManager.kFormHintText,
                      ),
                    ),
                  ),
                  Text("TRANSFER",
                      textAlign: TextAlign.center,
                      style: get14TextStyle(color: ColorManager.kFormHintText)),
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 4),
                    child: Text(
                      "${widget.param.cryptoSaleArg.units} ${widget.param.cryptoSaleArg.asset.code}",
                      textAlign: TextAlign.center,
                      style: get32TextStyle()
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text("TO",
                      textAlign: TextAlign.center,
                      style: get14TextStyle(color: ColorManager.kFormHintText)),
                  const SizedBox(height: 4),
                  Text(
                    "${widget.param.cryptoSaleArg.network.wallet}",
                    textAlign: TextAlign.center,
                    style: get16TextStyle().copyWith(
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Clipboard.setData(ClipboardData(
                              text:
                                  "${widget.param.cryptoSaleArg.network.wallet}"))
                          .then((_) {
                        showCustomSnackBar(
                            context: context,
                            text: "Text copied to clipboard",
                            type: NotificationType.success);
                      });
                    },
                    child: Text(
                      "Copy wallet address",
                      textAlign: TextAlign.center,
                      style: get16TextStyle().copyWith(
                        decoration: TextDecoration.underline,
                        height: 1.3,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32, bottom: 25),
                    child: Text(
                      "Or scan the code below",
                      textAlign: TextAlign.center,
                      style: get16TextStyle().copyWith(
                        color: ColorManager.kFormHintText,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  QrImageView(
                    data: "${widget.param.cryptoSaleArg.network.wallet}",
                    version: QrVersions.auto,
                    size: 200,
                  )
                ],
              ),
            ),

            //

            //// /////
            Padding(
              padding: EdgeInsets.only(
                  top: isSmallScreen(context) ? 20 : 78, bottom: 47),
              child: CustomBtn(
                isActive: true,
                loading: loading,
                text: "Proceed",
                onTap: () async {
                  Navigator.popAndPushNamed(
                    context,
                    RoutesManager.confirmCryptoTxn,
                    arguments: ConfirmCryptoTxnArg(
                      createTransaction: widget.param.createTransaction,
                      trade_type: "sell",
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildSpacer() => const SizedBox(height: 20);
}
