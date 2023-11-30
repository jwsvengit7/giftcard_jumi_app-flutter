import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jimmy_exchange/core/constants.dart';
import 'package:jimmy_exchange/core/helpers/transaction_helper.dart';
import 'package:jimmy_exchange/core/model/asset.dart';
import 'package:jimmy_exchange/core/model/network.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/crypto/confrim_crypto_sell.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_appbar.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_input_field.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_scaffold.dart';

import '../../../core/enum.dart';
import '../../../core/model/saved_bank.dart';
import '../../../core/utils/validators.dart';
import '../../resources/route_arg/crypto_arg.dart';
import '../../widgets/custom_bottom_sheet.dart';
import '../../widgets/custom_indicator.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/modals/select_asset.dart';
import '../../widgets/modals/select_network.dart';
import '../../widgets/modals/select_saved_bank.dart';
import '../../widgets/saved_bank.dart';

class SellCryptoView extends StatefulWidget {
  const SellCryptoView({super.key});

  @override
  State<SellCryptoView> createState() => _SellCryptoViewState();
}

class _SellCryptoViewState extends State<SellCryptoView> {
  final TextEditingController amountController = TextEditingController();
  CurrencyTextInputFormatter _amountFormatter = CurrencyTextInputFormatter(
      enableNegative: false, symbol: "", decimalDigits: 2);
  final TextEditingController unitsController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  Network? network;
  Asset? asset;

  bool termsAgreed = false;
  bool providedRightDetails = false;

  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  SavedBank? selectedBank;
  num? rate;
  bool fetchingRate = false;

  num? cRSSC;
  num? usd_exchange_rate_to_ngn;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getCRSSCPercentage();
    });
    super.initState();
  }

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
          title: Text("Sell Crypto", style: get20TextStyle()),
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 47),
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => getAssetAndRate(),
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
                          "Min: ${formatCurrency(asset?.sell_min_amount, code: Constants.kUSDCode)}",
                          style: get14TextStyle().copyWith(
                            color: ColorManager.kFormHintText,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "Max: ${formatCurrency(asset?.sell_max_amount, code: Constants.kUSDCode)}",
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
                onTap: () => getNetwork(),
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
              buildSpacer(),
              CustomInputField(
                textEditingController: unitsController,
                formHolderName: "You Pay",
                hintText: cryptoTradeType == CryptoTradeType.asset
                    ? "Units"
                    : "Amount in USD",
                enabled: rate != null,
                onChanged: (_) => cryptoTradeType == CryptoTradeType.asset
                    ? calculateAmountForAssetTradeType()
                    : calculateAmountForUsdTradeType(),
                textInputType:
                    const TextInputType.numberWithOptions(decimal: true),
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
                  child: Center(
                    child: Text("USD", style: getPrefixTextStyle()),
                  ),
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    asset == null
                        ? " ---"
                        : cryptoTradeType == CryptoTradeType.asset
                            ? "1${asset?.code} = ${formatCurrency(rate)}"
                            : "1USD = ${formatCurrency(usd_exchange_rate_to_ngn)}",
                    style: get14TextStyle().copyWith(
                      color: ColorManager.kFormHintText,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  // Removed Fee
                  // Text(
                  //   cRSSC == null ? " ---" : "Fee $cRSSC%",
                  //   style: get14TextStyle().copyWith(
                  //     color: ColorManager.kFormHintText,
                  //     fontWeight: FontWeight.w400,
                  //   ),
                  // ),
                ],
              ),

              //
              cRSSC == null ? const SizedBox() : buildSpacer(),
              cRSSC == null
                  ? const SizedBox()
                  : CustomInputField(
                      textEditingController: amountController,
                      formHolderName: "You Get",
                      hintText: "Amount",
                      enabled: asset != null,
                      textInputType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (_) => cryptoTradeType == CryptoTradeType.asset
                          ? calculateUnitsForAssetTradeType()
                          : calculateUnitsForUsdTradeType(),
                      inputFormatters: [_amountFormatter],
                      validator: (val) => Validator.validateField(
                        fieldName: "Amount",
                        input: val,
                      ),
                      prefixIcon: getPrefixDropDown(
                        child: Center(
                            child: Text("NGN", style: getPrefixTextStyle())),
                        onTap: () {},
                      ),
                    ),

              //
              buildSpacer(),

              Text(
                "Bank Details for Payout",
                style: get16TextStyle().copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),

              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async => selectBank(),
                child: selectedBank != null
                    ? buildBankCard(selectedBank!, () async => selectBank())
                    : IgnorePointer(
                        child: CustomInputField(
                          formHolderName: "Select Existing Bank Account",
                          hintText: "Click to select bank account to use",
                          textEditingController: TextEditingController(
                            text: selectedBank?.account_number,
                          ),
                        ),
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
                          TextSpan(text: 'I agree to the '),
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
                  ],
                ),
              ),

              //
              Padding(
                padding: const EdgeInsets.only(top: 26, bottom: 47),
                child: CustomBtn(
                  isActive: true,
                  loading: loading,
                  text: "Sell ${asset?.name ?? "--"}",
                  onTap: () async {
                    try {
                      num usdAmount = num.tryParse(
                              unitsController.text.replaceAll(",", "")) ??
                          0;

                      if (!(_formKey.currentState?.validate() ?? false) ||
                          asset == null ||
                          network == null ||
                          selectedBank == null) {
                        throw "Please ensure that all input are filled correctly.";
                      } else if (providedRightDetails == false ||
                          termsAgreed == false) {
                        throw "Please check the two boxes.";
                      } else if (usdAmount > (asset?.sell_max_amount ?? 0) ||
                          usdAmount < (asset?.sell_min_amount ?? 0)) {
                        throw "Amount should be between the min and max.";
                      } else {
                        String asset_amount = calculateUnitFromFinalAmount();

                        setState(() => loading = true);

                        CryptoBreakDown breakDown =
                            await TransactionHelper.getCryptoBreakdown(
                          trade_type: "sell",
                          asset_id: asset?.id ?? "",
                          asset_amount: asset_amount,
                        );

                        await showCustomBottomSheet(
                          context: context,
                          screen: ConfirmCryptoSell(
                            param: CryptoSaleArg(
                              asset: asset!,
                              breakDown: breakDown,
                              comment: commentController.text,
                              network: network!,
                              units: asset_amount,
                              amount: amountController.text.replaceAll(",", ""),
                              savedBank: selectedBank!,
                              rate: rate,
                              usd_exchange_rate_to_ngn:
                                  usd_exchange_rate_to_ngn,
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

  Future<void> selectBank() async {
    SavedBank? res = await showCustomBottomSheet(
        context: context, screen: SelectSavedBank());
    if (res != null) {
      selectedBank = res;
      setState(() {});
    }
  }

  Future<void> getAssetAndRate() async {
    try {
      Asset? res = await showCustomBottomSheet(
          context: context, screen: SelectAsset(current: asset));
      if (res == null) return;
      setState(() {
        network = null;
        asset = res;
        rate == null;
        amountController.text = "";
        unitsController.text = "";
        usd_exchange_rate_to_ngn = res.sell_rate;
      });

      // Get rate
      await fetchRate();
    } catch (e) {
      showCustomSnackBar(
          context: context, type: NotificationType.warning, text: e.toString());
    }
  }

  Future<void> fetchRate() async {
    setState(() => fetchingRate = true);

    await TransactionHelper.getCryptoBreakdown(
      trade_type: "sell",
      asset_id: asset?.id ?? "",
      asset_amount: "1",
    ).then((value) {
      rate = value.rate;
      setState(() => fetchingRate = false);
    }).catchError((e) {
      setState(() => fetchingRate = false);
      throw "An error occured while fetching rate, please enter amount";
    });
  }

  Future<void> getNetworkAlt() async {
    Network? res = await showCustomBottomSheet(
        context: context,
        screen: SelectNetwork(current: network, asset: asset!));
    if (res == null) return;
    setState(() {
      network = res;
      asset = null;
      rate == null;
      amountController.text = "";
      unitsController.text = "";
    });
  }

  Future<void> getNetwork() async {
    try {
      if (asset == null) throw "You need to select an asset";

      Network? res = await showCustomBottomSheet(
          context: context,
          screen: SelectNetwork(current: network, asset: asset!));
      if (res == null) return;

      setState(() => network = res);
    } catch (e) {
      showCustomSnackBar(
          context: context, type: NotificationType.warning, text: e.toString());
    }
  }

  void calculateAmountForAssetTradeType() {
    if (asset == null || cRSSC == null) return;
    num unit = num.tryParse(unitsController.text) ?? 0;
    num total = (unit * (rate ?? 0));
    num percent = (cRSSC! / 100);
    num payable = total + (total * percent);
    amountController.text = formatNumber(payable);
  }

  void calculateAmountForUsdTradeType() {
    if (asset == null || cRSSC == null || usd_exchange_rate_to_ngn == null) {
      return;
    }
    num unit = num.tryParse(unitsController.text) ?? 0;
    num total = (unit * (usd_exchange_rate_to_ngn ?? 0));
    num percent = (cRSSC! / 100);
    num payable = total + (total * percent);
    amountController.text = formatNumber(payable);
  }

  void calculateUnitsForAssetTradeType() {
    if (asset == null || cRSSC == null) return;
    num payable = _amountFormatter.getUnformattedValue();
    num percent = (cRSSC! / 100);
    num total_without_fee = payable / (1 + percent);
    unitsController.text = (total_without_fee / (rate ?? 1)).toString();
  }

  void calculateUnitsForUsdTradeType() {
    if (asset == null || cRSSC == null || usd_exchange_rate_to_ngn == null) {
      return;
    }

    num payable = _amountFormatter.getUnformattedValue();
    num percent = (cRSSC! / 100);
    num total_without_fee = payable / (1 + percent);
    unitsController.text =
        (total_without_fee / (usd_exchange_rate_to_ngn ?? 1)).toString();
  }

  String calculateUnitFromFinalAmount() {
    String fl = amountController.text.replaceAll(",", "");

    if (cryptoTradeType == CryptoTradeType.asset) {
      return unitsController.text.replaceAll(",", "");
    }
    num payable = num.tryParse(fl) ?? 0;
    num percent = (cRSSC! / 100);
    num total_without_fee = payable / (1 + percent);
    return (total_without_fee / (rate ?? 1)).toString();
  }

  Future<void> getCRSSCPercentage() async {
    try {
      var res = await TransactionHelper.getSystemData("CRSSC");
      if (mounted) setState(() => cRSSC = num.tryParse(res["content"]));
    } catch (e) {
      showCustomSnackBar(
        context: context,
        text: "An error occured while fetching CRSSC value",
        type: NotificationType.warning,
      );
    }
  }
}
