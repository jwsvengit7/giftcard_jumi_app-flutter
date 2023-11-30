import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jimmy_exchange/core/helpers/transaction_helper.dart';
import 'package:jimmy_exchange/core/model/asset.dart';
import 'package:jimmy_exchange/core/model/network.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_appbar.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_input_field.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_scaffold.dart';

import '../../../core/constants.dart';
import '../../../core/enum.dart';
import '../../../core/utils/validators.dart';
import '../../resources/route_arg/crypto_arg.dart';
import '../../widgets/crypto/confrim_crypto_buy.dart';
import '../../widgets/custom_bottom_sheet.dart';
import '../../widgets/custom_indicator.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/modals/select_asset.dart';
import '../../widgets/modals/select_network.dart';

class BuyCryptoView extends StatefulWidget {
  const BuyCryptoView({super.key});

  @override
  State<BuyCryptoView> createState() => _BuyCryptoViewState();
}

class _BuyCryptoViewState extends State<BuyCryptoView> {
  final TextEditingController amountController = TextEditingController();
  CurrencyTextInputFormatter _amountFormatter = CurrencyTextInputFormatter(
      enableNegative: false, symbol: "", decimalDigits: 2);

  final TextEditingController unitsController = TextEditingController();
  final TextEditingController walletController = TextEditingController();
  final TextEditingController confirmWalletController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  Network? network;
  Asset? asset;

  num? cRBSC;

  num? usd_exchange_rate_to_ngn;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getCRBSCPercentage();
    });
    super.initState();
  }

  Future<void> getCRBSCPercentage() async {
    try {
      var res = await TransactionHelper.getSystemData("CRBSC");
      if (mounted) setState(() => cRBSC = num.tryParse(res["content"]));
    } catch (e) {
      showCustomSnackBar(
        context: context,
        text: "An error occured while fetching CRBSC value",
        type: NotificationType.warning,
      );
    }
  }

  void calculateUnitsForAssetTradeType() {
    if (asset == null || cRBSC == null) return;
    num buy_rate = asset?.buy_rate ?? 1;
    num amount = _amountFormatter.getUnformattedValue();
    num percent = (cRBSC! / 100);
    num amount_without_fee = amount / (1 + percent);
    unitsController.text = (amount_without_fee / buy_rate).toString();
  }

  void calculateUnitsForUsdTradeType() {
    if (asset == null || cRBSC == null || usd_exchange_rate_to_ngn == null) {
      return;
    }
    num buy_rate = asset?.buy_rate ?? 1;
    num amount = _amountFormatter.getUnformattedValue();
    amount = amount * (usd_exchange_rate_to_ngn ?? 1);
    num percent = (cRBSC! / 100);
    num amount_without_fee = amount / (1 + percent);
    unitsController.text = (amount_without_fee / buy_rate).toString();
  }

  void calculateAmountForAssetTradeType() {
    if (asset == null || cRBSC == null) return;
    num buy_rate = asset?.buy_rate ?? 1;
    num unit = num.tryParse(unitsController.text) ?? 0;
    num total = (unit * buy_rate);
    num percent = (cRBSC! / 100);
    num payable = total + (total * percent);

    amountController.text = formatNumber(payable);
  }

  void calculateAmountForUsdTradeType() {
    if (asset == null || cRBSC == null || usd_exchange_rate_to_ngn == null) {
      return;
    }

    num buy_rate = asset?.buy_rate ?? 1;
    num unit = num.tryParse(unitsController.text) ?? 0;
    num total = (unit * buy_rate);
    num percent = (cRBSC! / 100);
    num payable = total + (total * percent);

    payable = (payable / usd_exchange_rate_to_ngn!);

    amountController.text = formatNumber(payable);
  }

  bool termsAgreed = false;
  bool providedRightDetails = false;
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  CryptoTradeType cryptoTradeType = CryptoTradeType.usd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CustomScaffold(
        backgroundColor: ColorManager.kWhite,
        appBar: CustomAppBar(
          title: Text("Buy Crypto", style: get20TextStyle()),
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 47),
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => getAsset(),
                child: IgnorePointer(
                  child: CustomInputField(
                    textEditingController:
                        TextEditingController(text: asset?.code),
                    formHolderName: "Select Asset",
                    hintText: "Select Asset",
                    suffixIcon: buildDropDownSuffixIcon(),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              asset != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Min: ${formatCurrency(asset?.buy_min_amount, code: Constants.kUSDCode)}",
                          style: get14TextStyle().copyWith(
                            color: ColorManager.kFormHintText,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "Max: ${formatCurrency(asset?.buy_max_amount, code: Constants.kUSDCode)}",
                          style: get14TextStyle().copyWith(
                            color: ColorManager.kFormHintText,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),

              //
              buildSpacer(),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  if (asset == null) {
                    showCustomSnackBar(
                        context: context,
                        type: NotificationType.error,
                        text: "You need to an asset");

                    return;
                  }
                  Network? res = await showCustomBottomSheet(
                      context: context,
                      screen: SelectNetwork(current: network, asset: asset!));
                  if (res != null) setState(() => network = res);

                  if (cryptoTradeType == CryptoTradeType.asset) {
                    calculateUnitsForAssetTradeType();
                  } else {
                    calculateUnitsForUsdTradeType();
                  }
                },
                child: IgnorePointer(
                  child: CustomInputField(
                    textEditingController:
                        TextEditingController(text: network?.name),
                    formHolderName: "Select Network",
                    hintText: "Select Network",
                    suffixIcon: buildDropDownSuffixIcon(),
                  ),
                ),
              ),

              //
              cRBSC == null ? const SizedBox() : buildSpacer(),
              cRBSC == null
                  ? const SizedBox()
                  : CustomInputField(
                      textEditingController: amountController,
                      formHolderName: "You Pay",
                      hintText: cryptoTradeType == CryptoTradeType.asset
                          ? "Amount"
                          : "Amount in USD",
                      textInputType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [_amountFormatter],
                      onChanged: (_) => cryptoTradeType == CryptoTradeType.asset
                          ? calculateUnitsForAssetTradeType()
                          : calculateUnitsForUsdTradeType(),
                      enabled: asset != null,
                      prefixIcon: getPrefixDropDown(
                        child: Center(
                          child: Text("USD", style: getPrefixTextStyle()),

                          // DropdownButton<CryptoTradeType>(
                          //     alignment: Alignment.center,
                          //     elevation: 0,
                          //     underline: const SizedBox(),
                          //     items: <CryptoTradeType>[
                          //       CryptoTradeType.asset,
                          //       CryptoTradeType.usd
                          //     ].map((CryptoTradeType value) {
                          //       return DropdownMenuItem<CryptoTradeType>(
                          //         value: value,
                          //         child: Row(
                          //           mainAxisAlignment:
                          //               MainAxisAlignment.center,
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.center,
                          //           children: value == CryptoTradeType.asset
                          //               ? [
                          //                   Text("NGN",
                          //                       style: getPrefixTextStyle())
                          //                 ]
                          //               : [
                          //                   Text("USD",
                          //                       style: getPrefixTextStyle())
                          //                 ],
                          //         ),
                          //       );
                          //     }).toList(),
                          //     value: cryptoTradeType,
                          //     onChanged: (val) {
                          //       if (val != null) {
                          //         amountController.text = "";
                          //         unitsController.text = "";

                          //         //
                          //         setState(() {
                          //           cryptoTradeType = val;
                          //         });
                          //       }
                          //     },
                          //   ),
                        ),
                        onTap: () {},
                      ),
                    ),
              cryptoTradeType == CryptoTradeType.asset
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        asset == null
                            ? "---"
                            : cryptoTradeType == CryptoTradeType.usd
                                ? "1USD = ${formatCurrency(usd_exchange_rate_to_ngn)}"
                                : "",
                        style: get14TextStyle().copyWith(
                          color: ColorManager.kFormHintText,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

              //
              buildSpacer(),
              CustomInputField(
                textEditingController: unitsController,
                formHolderName: "You Get",
                hintText: "Units",
                enabled: asset != null,
                onChanged: (_) => cryptoTradeType == CryptoTradeType.asset
                    ? calculateAmountForAssetTradeType()
                    : calculateAmountForUsdTradeType(),
                textInputType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    try {
                      final text = newValue.text;
                      if (text.isNotEmpty) double.parse(text);
                      return newValue;
                    } catch (e) {
                      return oldValue;
                    }
                  }),
                ],
                prefixIcon: getPrefixDropDown(
                  child: asset == null
                      ? Center(child: Text("---", style: getPrefixTextStyle()))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            loadNetworkImage(asset?.icon ?? "", width: 16),
                            const SizedBox(width: 4),
                            Text(
                              truncateWithEllipsis(5, asset?.code ?? ""),
                              style: getPrefixTextStyle(),
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                  onTap: () {},
                ),
              ),
              // const SizedBox(height: 12),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       asset == null
              //           ? "---"
              //           : "1${asset?.code} = ${formatCurrency(asset?.buy_rate)}",
              //       style: get14TextStyle().copyWith(
              //         color: ColorManager.kFormHintText,
              //         fontWeight: FontWeight.w400,
              //       ),
              //     ),
              //     // Removed Fee
              //     // Text(
              //     //   cRBSC == null ? " ---" : "Fee $cRBSC%",
              //     //   style: get14TextStyle().copyWith(
              //     //     color: ColorManager.kFormHintText,
              //     //     fontWeight: FontWeight.w400,
              //     //   ),
              //     // ),
              //   ],
              // ),

              //
              buildSpacer(),
              CustomInputField(
                formHolderName: "Enter Wallet Address",
                textEditingController: walletController,
                hintText: "Enter Wallet Address",
                validator: (val) => Validator.validateField(
                    fieldName: "Wallet Address", input: val),
              ),

              //
              buildSpacer(),
              CustomInputField(
                textEditingController: confirmWalletController,
                formHolderName: "Confirm Wallet Address",
                hintText: "Confirm Wallet Address",
                validator: (v) => Validator.doesPasswordMatch(
                  password: walletController.text,
                  confirmPassword: v,
                  fieldName: "Wallet Address",
                ),
              ),

              //
              buildSpacer(),
              CustomInputField(
                textEditingController: commentController,
                formHolderName: "Comment",
                hintText: "Add Comment",
              ),

              //
              const SizedBox(height: 24),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => setState(() => termsAgreed = !termsAgreed),
                child: Row(
                  children: [
                    Image.asset(
                        termsAgreed
                            ? ImageManager.kSmallChecked
                            : ImageManager.kSmallUncheck,
                        height: 24),
                    const SizedBox(width: 16),
                    RichText(
                      text: TextSpan(
                        style: get16TextStyle().copyWith(
                          fontWeight: FontWeight.w400,
                          color: ColorManager.kBlack2,
                        ),
                        children: <TextSpan>[
                          const TextSpan(text: 'I agree to the '),
                          TextSpan(
                            text: 'Terms and Conditions',
                            style: const TextStyle(
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                debugPrint('Terms of Service"');
                              },
                          ),
                        ],
                      ),
                    ),
                    //
                  ],
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() => providedRightDetails = !providedRightDetails);
                },
                child: Row(
                  children: [
                    Image.asset(
                        providedRightDetails
                            ? ImageManager.kSmallChecked
                            : ImageManager.kSmallUncheck,
                        width: 24),
                    const SizedBox(width: 16),
                    Text(
                      "I provided the right details",
                      style: get16TextStyle().copyWith(
                        fontWeight: FontWeight.w400,
                        color: ColorManager.kBlack2,
                      ),
                    )
                    //
                  ],
                ),
              ),

              //
              Padding(
                padding: const EdgeInsets.only(top: 26, bottom: 47),
                child: CustomBtn(
                  isActive: true,
                  loading: loading,
                  text: "Buy ${asset?.name ?? "--"}",
                  onTap: () async {
                    try {
                      num amount = num.tryParse(
                              amountController.text.replaceAll(",", "")) ??
                          0;

                      if (!(_formKey.currentState?.validate() ?? false) ||
                          asset == null ||
                          network == null) {
                        throw "Please ensure that all input are filled correctly.";
                      } else if (providedRightDetails == false ||
                          termsAgreed == false) {
                        throw "Please check the two boxes.";
                      } else if (amount > (asset?.buy_max_amount ?? 0) ||
                          amount < (asset?.buy_min_amount ?? 0)) {
                        throw "Amount should be between the min and max.";
                      } else {
                        setState(() => loading = true);

                        CryptoBreakDown breakDown =
                            await TransactionHelper.getCryptoBreakdown(
                          trade_type: "buy",
                          asset_id: asset?.id ?? "",
                          asset_amount: unitsController.text,
                        );

                        String amount = "";
                        if (cryptoTradeType == CryptoTradeType.asset) {
                          amount = amountController.text.replaceAll(",", "");
                        } else {
                          String fl = amountController.text.replaceAll(",", "");
                          num fl2 = num.tryParse(fl) ?? 0;
                          num fl3 = fl2 * usd_exchange_rate_to_ngn!;
                          amount = fl3.toString().replaceAll(",", "");
                        }

                        await showCustomBottomSheet(
                          context: context,
                          screen: ConfirmCryptoBuy(
                            param: CryptoBuyArg(
                              asset: asset!,
                              breakDown: breakDown,
                              comment: commentController.text,
                              network: network!,
                              units: unitsController.text,
                              wallet_address: walletController.text,
                              amount: amount,
                              rate: asset?.buy_rate,
                            ),
                          ),
                        );
                        setState(() => loading = false);
                      }
                    } catch (err) {
                      setState(() => loading = false);
                      showCustomSnackBar(
                        context: context,
                        type: NotificationType.error,
                        text: "$err",
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSpacer() => const SizedBox(height: 20);

  Future<void> getAsset() async {
    Asset? res = await showCustomBottomSheet(
        context: context, screen: SelectAsset(current: asset));
    if (res != null) setState(() => asset = res);

    if (res == null) return;
    setState(() {
      asset = res;
      network = null;
      amountController.text = "";
      unitsController.text = "";
      usd_exchange_rate_to_ngn = asset?.buy_rate;
    });
  }
}
