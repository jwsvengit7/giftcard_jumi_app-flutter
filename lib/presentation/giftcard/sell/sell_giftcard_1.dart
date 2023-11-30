import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/core/enum.dart';
import 'package:jimmy_exchange/core/model/country.dart';
import 'package:jimmy_exchange/core/model/giftcard_category.dart';
import 'package:jimmy_exchange/core/model/giftcard_product.dart';
import 'package:jimmy_exchange/core/model/select_giftcard_product_model.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/route_arg/giftcard_arg.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_appbar.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_back_button.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_input_field.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_scaffold.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_snackbar.dart';
import 'package:jimmy_exchange/presentation/widgets/modals/select_card_type.dart';
import 'package:jimmy_exchange/presentation/widgets/modals/select_units.dart';
import 'package:jimmy_exchange/presentation/widgets/showCardAndCryptoRate.dart';

import '../../../core/helpers/transaction_helper.dart';
import '../../../core/model/buy_and_sell_giftcard_view_model.dart';
import '../../../core/utils/validators.dart';
import '../../resources/routes_manager.dart';
import '../../widgets/custom_bottom_sheet.dart';
import '../../widgets/custom_indicator.dart';
import '../../widgets/modals/select_giftcard_country.dart';

class SellGiftcard1View extends StatefulWidget {
  final BuyAndSaleGiftCardViewParams params;
  const SellGiftcard1View({
    super.key,
    required this.params,
  });

  @override
  State<SellGiftcard1View> createState() => _SellGiftcard1ViewState();
}

class _SellGiftcard1ViewState extends State<SellGiftcard1View> {
  final CurrencyTextInputFormatter _amountFormatter =
      CurrencyTextInputFormatter(
          enableNegative: false, symbol: "", decimalDigits: 2);
  final TextEditingController amountController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  bool otherAmount = false;

  GiftcardCategory? giftcardCategory;
  Country? country;
  GiftcardProduct? giftcardProduct;
  String card_type = "";
  int quantity = 1;

  num? gCSSC;
  num? payableAmount;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getGCSSCPercentage();
    });
    super.initState();
  }

  Future<void> getGCSSCPercentage() async {
    try {
      var res = await TransactionHelper.getSystemData("GCSSC");
      setState(() => gCSSC = num.tryParse(res["content"]));
    } catch (e) {
      showCustomSnackBar(
        context: context,
        text: "An error occured while fetching GCSSC value",
        type: NotificationType.warning,
      );
    }
  }

  Future<void> selectCategory() async {
    Navigator.pushNamed<GiftcardCategory?>(
            context, RoutesManager.giftCardCategories,
            arguments: giftcardCategory)
        .then((returnValue) {
      // Handle the returned value here
      if (returnValue != null) {
        // Do something with the returned value
        giftcardCategory = returnValue;
        country = null;
        giftcardProduct = null;
        setState(() {});
      } else {
        // Handle the case where no value is returned
      }
    });

    // GiftcardCategory? res = await showCustomBottomSheet(
    //   context: context,
    //   screen: SelectGiftcardCategory(current: giftcardCategory, isSale: true),
    // );

    // if (res != null) {
    //   giftcardCategory = res;
    //   country = null;
    //   giftcardProduct = null;
    //   setState(() {});
    // }
  }

  Future<void> selectCountry() async {
    if (giftcardCategory == null) {
      showCustomSnackBar(
        context: context,
        text: "Please select a category",
        type: NotificationType.warning,
      );

      return;
    }
    Country? res = await showCustomBottomSheet(
      context: context,
      screen: SelectGiftcardCountry(
        current: country,
        availableCountries: giftcardCategory?.countries ?? [],
      ),
    );
    if (res != null) {
      giftcardProduct = null;
      country = res;
      setState(() {});
    }
  }

  Future<void> selectProduct() async {
    if (giftcardCategory == null || country == null) {
      showCustomSnackBar(
        context: context,
        text: "Please select a category and country",
        type: NotificationType.warning,
      );

      return;
    }

    Navigator.pushNamed<GiftcardProduct?>(
            context, RoutesManager.giftCardProducts,
            arguments: SelectGiftCardProduct(
                country: country,
                giftCardCategory: giftcardCategory,
                current: giftcardProduct))
        .then((returnValue) {
      // Handle the returned value here
      if (returnValue != null) {
        // Do something with the returned value
        // if (res != null) {
        setState(() => giftcardProduct = returnValue);
      } else {
        // Handle the case where no value is returned
      }
    });
  }

  void selectCardType() async {
    int res = await showCustomBottomSheet(
      context: context,
      screen: SelectCardType(),
    );
    switch (res) {
      case 0:
        card_type = "physical";
        break;
      case 1:
        card_type = "virtual";
        break;
      default:
        card_type = "";
    }

    setState(() {});
  }

  void selectUnit() async {
    quantity = await showCustomBottomSheet(
      context: context,
      isDismissible: true,
      screen: SelectUnits(),
    );

    setState(() {});
  }

  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  ScrollController scrollController = ScrollController();
  ScrollController gridsController = ScrollController();

  Widget buildExistingTrade(SellGiftCard2Arg arg) {
    return Container(
      margin: const EdgeInsets.only(right: 26),
      width: 310,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: ColorManager.kFormBg),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: loadNetworkImage(arg.giftCardCategory.icon ?? ""),
            ),
          ),
          const SizedBox(width: 16),
          //
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  arg.giftCardProduct.name ?? "",
                  maxLines: 2,
                  style: get16TextStyle().copyWith(fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      formatCurrency(arg.oneUnitPayable * arg.quantity),
                      style: get14TextStyle(),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: ColorManager.kYellow,
                      ),
                    ),
                    Text(
                      "${arg.quantity} Unit(s)",
                      style: get14TextStyle(),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: ColorManager.kYellow,
                      ),
                    ),
                    Text(
                      "${getCurrencySymbol(arg.giftCardProduct.currency!["code"])}${arg.giftCardProduct.sell_rate}",
                      style: get14TextStyle(),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     color: Colors.white,
  //     child: Column(
  //       children: [],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CustomScaffold(
        backgroundColor: ColorManager.kWhite,
        appBar: CustomAppBar(
          leading: Center(child: CustomBackButton(width: 36.h, height: 36.h)),
          title: Text(
              widget.params.isGiftCardSale ? "Sell Giftcard" : 'Buy Giftcard',
              style:
                  get20TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700)),
          toolbarHeight: 100.h,
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
              ),
              children: [
                ///
                ///
                widget.params.giftCardList.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Existing Trades",
                            style: get16TextStyle().copyWith(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 80,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for (var i = 0;
                                      i < widget.params.giftCardList.length;
                                      i++)
                                    buildExistingTrade(
                                        widget.params.giftCardList[i])
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'New Trade Details',
                            style: get16TextStyle().copyWith(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 24),
                        ],
                      )
                    : const SizedBox(),

                ///
                ///
                ///
                ///
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async => selectCategory(),
                  child: IgnorePointer(
                    child: CustomInputField(
                      textEditingController: TextEditingController(
                        text: giftcardCategory?.name,
                      ),
                      formHolderName: "Category",
                      hintText: "Select Category",
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: 15.w),
                        child: buildDropDown(),
                      ),
                      enabled: false,
                      hintStyle: getHintTextStyle(
                          fontWeight: FontWeight.w500, fontSize: 14.sp),
                    ),
                  ),
                ),

                enableProceedForSelectedCategory()
                    ? Column(
                        children: [
                          //
                          const SizedBox(height: 24),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async => selectCountry(),
                            child: IgnorePointer(
                              child: CustomInputField(
                                textEditingController: TextEditingController(
                                  text: country?.name ?? "",
                                ),
                                formHolderName: "Country",
                                hintText: "Select Country",
                                enabled: false,
                                suffixIcon: Padding(
                                  padding: EdgeInsets.only(right: 15.w),
                                  child: buildDropDown(),
                                ),
                                hintStyle: getHintTextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp),
                              ),
                            ),
                          ),

                          //
                          const SizedBox(height: 24),

                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async => selectProduct(),
                            child: IgnorePointer(
                              child: CustomInputField(
                                textEditingController: TextEditingController(
                                  text: giftcardProduct?.name ?? "",
                                ),
                                formHolderName: "Product",
                                hintText: "Select Product",
                                suffixIcon: Padding(
                                  padding: EdgeInsets.only(right: 15.w),
                                  child: buildDropDown(),
                                ),
                                hintStyle: getHintTextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp),
                              ),
                            ),
                          ),
                          enableProceedForSelectedProduct()
                              ? Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    if (giftcardProduct == null)
                                      GestureDetector(
                                        onTap: () {
                                          showCustomBottomSheet(
                                              context: context,
                                              enableDrag: true,
                                              isDismissible: true,
                                              showDragHandle: false,
                                              //  constraints: BoxConstraints(minHeight: 500,maxHeight: 700),
                                              screen: GiftCardAndCryptoRates());
                                        },
                                        child: Row(
                                          children: [
                                            Image.asset(ImageManager.kInfo,
                                                width: 17.w, height: 17.w),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            Text(
                                              "See Product Rates",
                                              style: get14TextStyle(
                                                  color:
                                                      ColorManager.kPrimaryBlue,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            Icon(
                                              Icons.play_arrow,
                                              size: 24.w,
                                              color: ColorManager.kPrimaryBlue,
                                            )
                                          ],
                                        ),
                                      )
                                    else
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 5.h),
                                        decoration: BoxDecoration(
                                            color:
                                                ColorManager.kUpdateBackground,
                                            border: Border.all(
                                                color: ColorManager.kPrimaryBlue
                                                    .withOpacity(0.15)),
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                                "Rate: ${giftcardProduct == null ? "--" : formatCurrency(giftcardProduct?.sell_rate, code: giftcardProduct?.currency!["code"])}",
                                                style: get16TextStyle(
                                                        color: ColorManager
                                                            .kPrimaryBlue)
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400)),
                                            const Spacer(),
                                            Text(
                                              "Minimum: ${giftcardProduct == null ? "--" : formatCurrency(giftcardProduct?.sell_min_amount, code: giftcardProduct?.currency!["code"])}",
                                              style: get16TextStyle(
                                                      color: ColorManager
                                                          .kPrimaryBlue)
                                                  .copyWith(
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 13.h,
                                              child: VerticalDivider(),
                                            ),
                                            Text(
                                              "Maximum: ${giftcardProduct == null ? "--" : formatCurrency(giftcardProduct?.sell_max_amount, code: giftcardProduct?.currency!["code"])}",
                                              style: get16TextStyle(
                                                      color: ColorManager
                                                          .kPrimaryBlue)
                                                  .copyWith(
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    const SizedBox(height: 24),
                                    GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () async => selectCardType(),
                                      child: IgnorePointer(
                                        child: CustomInputField(
                                          textEditingController:
                                              TextEditingController(
                                            text: card_type,
                                          ),
                                          formHolderName: "Type",
                                          hintText: "Select Type",
                                          suffixIcon: Padding(
                                            padding:
                                                EdgeInsets.only(right: 15.w),
                                            child: buildDropDown(),
                                          ),
                                          hintStyle: getHintTextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.sp),
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      height: 24.h,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () async => selectUnit(),
                                            child: IgnorePointer(
                                              child: CustomInputField(
                                                textEditingController:
                                                    TextEditingController(
                                                  text: quantity.toString(),
                                                ),
                                                formHolderName: "Units",
                                                hintText: "1",
                                                suffixIcon: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 15.w),
                                                  child: buildDropDown(),
                                                ),
                                                hintStyle: getHintTextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14.sp),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: CustomInputField(
                                            textEditingController:
                                                amountController,
                                            hintText: "Enter Amount",
                                            formHolderName: "Amount",
                                            validator: (val) =>
                                                Validator.validateField(
                                              fieldName: "Amount",
                                              input: val,
                                            ),
                                            textInputType: const TextInputType
                                                    .numberWithOptions(
                                                decimal: true),
                                            inputFormatters: [_amountFormatter],
                                            onChanged: (_) => calculateTotal(),
                                            hintStyle: getHintTextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.sp),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),

                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     giftcardProduct == null
                                    //         ? const SizedBox()
                                    //         : Text(
                                    //             "You Get: ${payableAmount == null ? "--" : formatCurrency(payableAmount! * quantity)}",
                                    //             style: get16TextStyle()
                                    //                 .copyWith(
                                    //                     color: ColorManager
                                    //                         .kFormHintText,
                                    //                     fontWeight:
                                    //                         FontWeight.w400)),

                                    //     // Removed Fee
                                    //     // Text(
                                    //     //   gCSSC == null ? " ---" : "Fee $gCSSC%",
                                    //     //   style: get14TextStyle().copyWith(
                                    //     //     color: ColorManager.kFormHintText,
                                    //     //     fontWeight: FontWeight.w400,
                                    //     //   ),
                                    //     // ),
                                    //   ],
                                    // ),

                                    //

                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Column(
                                    //       crossAxisAlignment:
                                    //           CrossAxisAlignment.start,
                                    //       children: [
                                    //         Text("Type",
                                    //             style: get16TextStyle()
                                    //                 .copyWith(
                                    //                     fontWeight:
                                    //                         FontWeight.w400)),
                                    //         const SizedBox(height: 17),
                                    //         Row(
                                    //           children: [
                                    //             GestureDetector(
                                    //               behavior: HitTestBehavior
                                    //                   .translucent,
                                    //               onTap: () {
                                    //                 card_type = "physical";
                                    //                 setState(() {});
                                    //               },
                                    //               child: Row(
                                    //                 children: [
                                    //                   buildCircularIndicator(
                                    //                       card_type ==
                                    //                           "physical"),
                                    //                   const SizedBox(width: 4),
                                    //                   const Text("Physical"),
                                    //                 ],
                                    //               ),
                                    //             ),
                                    //             const SizedBox(width: 23),
                                    //             GestureDetector(
                                    //               behavior: HitTestBehavior
                                    //                   .translucent,
                                    //               onTap: () {
                                    //                 card_type = "virtual";
                                    //                 setState(() {});
                                    //               },
                                    //               child: Row(
                                    //                 children: [
                                    //                   buildCircularIndicator(
                                    //                       card_type ==
                                    //                           "virtual"),
                                    //                   const SizedBox(width: 4),
                                    //                   const Text("Virtual")
                                    //                 ],
                                    //               ),
                                    //             )
                                    //           ],
                                    //         ),
                                    //       ],
                                    //     ),
                                    //     Column(
                                    //       crossAxisAlignment:
                                    //           CrossAxisAlignment.start,
                                    //       children: [
                                    //         Text("Units",
                                    //             style: get16TextStyle()
                                    //                 .copyWith(
                                    //                     fontWeight:
                                    //                         FontWeight.w400)),
                                    //         const SizedBox(height: 8),
                                    //         Row(
                                    //           children: [
                                    //             GestureDetector(
                                    //                 behavior: HitTestBehavior
                                    //                     .translucent,
                                    //                 onTap: () {
                                    //                   updateQuantity(true);
                                    //                 },
                                    //                 child: Image.asset(
                                    //                     ImageManager
                                    //                         .kSubstraction,
                                    //                     width: 16.5)),
                                    //             Padding(
                                    //               padding: const EdgeInsets
                                    //                       .symmetric(
                                    //                   horizontal: 10),
                                    //               child: Text("$quantity"),
                                    //             ),
                                    //             GestureDetector(
                                    //               behavior: HitTestBehavior
                                    //                   .translucent,
                                    //               onTap: () {
                                    //                 updateQuantity(false);
                                    //               },
                                    //               child: Image.asset(
                                    //                 ImageManager.kAddition,
                                    //                 width: 16.5,
                                    //               ),
                                    //             ),
                                    //           ],
                                    //         )
                                    //       ],
                                    //     )
                                    //   ],
                                    // ),

                                    const SizedBox(height: 24),
                                    CustomInputField(
                                      textEditingController: commentController,
                                      formHolderName: "Add Comment (Optional)",
                                      hintText: "",
                                    ),

                                    //
                                    const SizedBox(height: 24),
                                    //  buildDetailsCollector(size),
                                    // const SizedBox(height: 24),
                                    // Container(
                                    //   padding: const EdgeInsets.symmetric(
                                    //       horizontal: 15, vertical: 8),
                                    //   decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(16),
                                    //     color: ColorManager.kNoteColor,
                                    //   ),
                                    //   child: Column(
                                    //     crossAxisAlignment:
                                    //         CrossAxisAlignment.start,
                                    //     children: [
                                    //       //
                                    //       Text(
                                    //         "Note:",
                                    //         style: get16TextStyle().copyWith(
                                    //           fontWeight: FontWeight.w500,
                                    //           color: ColorManager.kYellow,
                                    //         ),
                                    //       ),
                                    //       const SizedBox(height: 10),

                                    //       Text(
                                    //         giftcardCategory?.sale_term ?? "--",
                                    //         style: get12TextStyle().copyWith(
                                    //             color: ColorManager
                                    //                 .kNoteTextColor),
                                    //       )
                                    //       //
                                    //     ],
                                    //   ),
                                    // ),

                                    // const SizedBox(height: 26),
                                    // Align(
                                    //   alignment: Alignment.centerLeft,
                                    //   child: GestureDetector(
                                    //     behavior: HitTestBehavior.translucent,
                                    //     onTap: () {
                                    //       num amount = num.tryParse(
                                    //               amountController.text
                                    //                   .replaceAll(",", "")) ??
                                    //           0;

                                    //       if (canProceed(amount)) {
                                    //         SellGiftcard2Arg newItem =
                                    //             SellGiftcard2Arg(
                                    //           giftcardCategory:
                                    //               giftcardCategory!,
                                    //           country: country!,
                                    //           giftcardProduct: giftcardProduct!,
                                    //           card_type: card_type,
                                    //           giftcardFiles: imageFiles,
                                    //           quantity: quantity,
                                    //           amount: amount,
                                    //           comment: commentController.text,
                                    //           oneUnitPayable:
                                    //               payableAmount ?? 1,
                                    //         );
                                    //         widget.param.add(newItem);
                                    //         Navigator.pushReplacementNamed(
                                    //             context,
                                    //             RoutesManager
                                    //                 .sellGiftcard1Route,
                                    //             arguments: widget.param);
                                    //       }
                                    //     },
                                    //     child: Image.asset(
                                    //       ImageManager.kAddAnotherGiftcard,
                                    //       height: 22,
                                    //     ),
                                    //   ),
                                    // ),

                                    //
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 23, bottom: 47),
                                      child: CustomBtn(
                                        isActive: canProceed(),
                                        loading: false,
                                        text: "Next",
                                        onTap: () async {
                                          num amount = num.tryParse(
                                                  amountController.text
                                                      .replaceAll(",", "")) ??
                                              0;
                                          // if (canProceed()) {
                                          SellGiftCard2Arg newItem =
                                              SellGiftCard2Arg(
                                            giftCardCategory: giftcardCategory!,
                                            country: country!,
                                            giftCardProduct: giftcardProduct!,
                                            card_type: card_type,
                                            giftCardFiles: [],
                                            quantity: quantity,
                                            amount: amount,
                                            comment: commentController.text,
                                            oneUnitPayable: payableAmount ?? 1,
                                          );

                                          widget.params.giftCardList
                                              .add(newItem);
                                          if (widget.params.isGiftCardSale) {
                                            Navigator.pushNamed(
                                              context,
                                              RoutesManager.sellGiftcard2Route,
                                              arguments:
                                                  widget.params.giftCardList,
                                            );
                                          } else {
                                             Navigator.pushNamed(
                                              context,
                                              RoutesManager.confirmCardSale,
                                              arguments:
                                                  widget.params.giftCardList,
                                            );
                                          }

                                          //widget.param.removeLast();
                                          // }
                                        },
                                      ),
                                    )
                                    //
                                    //
                                  ],
                                )
                              : buildUnavailableField(
                                  "The selected product is not active currently, please select another product.")
                        ],
                      )
                    : buildUnavailableField(
                        "The selected category is not active currently, please select another category.",
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool enableProceedForSelectedCategory() {
    if (giftcardCategory == null) return true;
    if (giftcardCategory?.sale_activated_at == null) return false;
    return true;
  }

  bool enableProceedForSelectedProduct() {
    if (giftcardProduct == null) return true;
    if (giftcardProduct?.activated_at == null) return false;
    return true;
  }

  // bool canProceed(num amount) {
  //   try {
  //     if (!(_formKey.currentState?.validate() ?? false) ||
  //         giftcardCategory == null ||
  //         country == null ||
  //         giftcardProduct == null ||
  //         imageFiles.isEmpty) {
  //       throw "Please ensure that all input are filled correctly.";
  //     } else if (card_type == "") {
  //       throw "Please select a card type.";
  //     } else if (amount > giftcardProduct!.sell_max_amount! ||
  //         amount < giftcardProduct!.sell_min_amount!) {
  //       throw "Amount should be between the min and max.";
  //     } else if (imageFiles.length < quantity) {
  //       throw "Please submit $quantity or more images";
  //     } else {
  //       return true;
  //     }
  //   } catch (err) {
  //     showCustomSnackBar(
  //       context: context,
  //       type: NotificationType.error,
  //       text: "$err",
  //     );
  //     return false;
  //   }
  // }

  bool canProceed() {
    num amount = num.tryParse(amountController.text.replaceAll(",", "")) ?? 0;
    return (giftcardCategory != null &&
        country != null &&
        giftcardProduct != null &&
        card_type.isNotEmpty &&
        (amountController.text.isNotEmpty &&
            (amount >= giftcardProduct!.sell_max_amount! ||
                amount <= giftcardProduct!.sell_min_amount!)));
  }

  void calculateTotal() {
    if (giftcardProduct == null || gCSSC == null) return;
    num amount = _amountFormatter.getUnformattedValue();
    num total = amount * (giftcardProduct?.sell_rate ?? 1);
    num percent = (gCSSC! / 100);

    payableAmount = total - (total * percent);
    setState(() {});
  }

  void updateQuantity(bool isDecrement) {
    if (isDecrement) {
      if (quantity > 1) {
        quantity -= 1;
        setState(() {});
      }
    } else {
      if (quantity < 50) {
        quantity += 1;
        setState(() {});
      }
    }
  }

  List<File> imageFiles = [];
  bool imageSelected = false;

  double buildImagePreviewHeight() {
    double hg = imageFiles.length / 3;
    if (hg < 1) return selectedImageHeight;

    hg = hg.ceilToDouble();
    return (selectedImageHeight * hg);
  }

  final double selectedImageHeight = 80;

  Widget buildUnavailableField(String subText) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ColorManager.kError,
        ),
      ),
      child: Text(
        subText,
        style: get14TextStyle().copyWith(
          color: ColorManager.kError,
        ),
      ),
    );
  }
}
