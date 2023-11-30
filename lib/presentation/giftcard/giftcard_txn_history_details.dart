import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/core/helpers/transaction_helper.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_back_button.dart';
import 'package:jimmy_exchange/presentation/widgets/popups/image_preview_popup.dart';
import 'package:jimmy_exchange/presentation/widgets/shimmers/square_shimmer.dart';
import 'package:jimmy_exchange/presentation/widgets/transaction_details_components.dart';

import '../../core/constants.dart';
import '../../core/model/giftcard_txn_history.dart';
import '../resources/color_manager.dart';
import '../resources/image_manager.dart';
import '../resources/styles_manager.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/popups/index.dart';

class GiftcardTxnHistoryDetailsView extends StatefulWidget {
  final String reference;

  const GiftcardTxnHistoryDetailsView({super.key, required this.reference});

  @override
  State<GiftcardTxnHistoryDetailsView> createState() =>
      _GiftcardTxnHistoryDetailsViewState();
}

class _GiftcardTxnHistoryDetailsViewState
    extends State<GiftcardTxnHistoryDetailsView> {
  ScrollController scrollController = ScrollController();

  bool loading = true;
  GiftcardTxnHistory? txnDetails;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TransactionHelper.getGiftcardTxnHistoryDetails(
              "/${widget.reference}?include=bank,giftcardProduct")
          .then((value) {
        txnDetails = value;
        setState(() => loading = false);
      }).catchError((e) {
        if (mounted) {
          showCustomSnackBar(
            context: context,
            text: "An error occured, please try again.",
          );
        }
      });
    });
    super.initState();
  }

  Widget buildSpacer() => const SizedBox(height: 12);

  @override
  Widget build(BuildContext context) {
    num payable = txnDetails?.payable_amount ?? 0;
    num previous_amount = 0;

    if (txnDetails != null) {
      previous_amount =
          calPreviousPartialAmountForGiftcardTxn(txnDetails!) ?? 0;
    }

    // IF REVIEW AMOUNT IF AVAILABLE THEN OVERRIDE
    if (txnDetails?.review_amount != null) {
      payable = txnDetails?.review_amount ?? 0;
      previous_amount = txnDetails?.payable_amount ?? 0;
    }

    return CustomScaffold(
      backgroundColor: ColorManager.kWhite,
      appBar: CustomAppBar(
        backgroundColor: ColorManager.kGray11,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CustomBackButton(),
        ),
        title: Text('Transaction Detail', style: get20TextStyle()),
      ),
      body: Material(
        color: ColorManager.kGray11,
        child: loading
            ? Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    const Padding(
                      padding: EdgeInsets.only(top: 35, bottom: 20),
                      child:
                          Center(child: SquareShimmer(height: 42, width: 200)),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SquareShimmer(width: 36, height: 17),
                        SizedBox(width: 16),
                        SquareShimmer(width: 65, height: 17),
                      ],
                    ),

                    const SizedBox(height: 38),

                    //
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildItemShimmer(),
                        buildItemShimmer(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildItemShimmer(),
                          buildItemShimmer(),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildItemShimmer(),
                        buildItemShimmer(),
                      ],
                    ),
                    //
                    const SizedBox(height: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SquareShimmer(width: 58, height: 14),
                        SizedBox(height: 8),
                        SquareShimmer(width: 180, height: 20),
                      ],
                    ),

                    //
                    const SizedBox(height: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SquareShimmer(width: 58, height: 14),
                        SizedBox(height: 8),
                        SquareShimmer(width: 180, height: 20),
                      ],
                    ),

                    const SizedBox(height: 45),
                  ],
                ),
              )
            : Column(
                children: [
                  SizedBox(
                    height: 238.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SuccessBadgeCustomIcon(
                            status: txnDetails?.status ?? ''),
                        Padding(
                          padding: EdgeInsets.only(top: 18.h, bottom: 12.h),
                          child: TradeType(
                              pageReference: 'giftcard',
                              tradeType: txnDetails?.trade_type ?? ''),
                        ),
                        txnDetails?.status?.toLowerCase() ==
                                Constants.kPartiallyApprovedStatus
                            ? Center(
                                child: Text(
                                  formatCurrency(previous_amount),
                                  textAlign: TextAlign.center,
                                  style: get12TextStyle().copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: ColorManager.kError,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        Center(
                          child: Text(
                            "NGN ${formatNumber(payable)}",
                            textAlign: TextAlign.center,
                            style: get18TextStyle().copyWith(
                              color: ColorManager.kSecBlue,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 16.w
                          // top: isSmallScreen(context) ? 17 : 20,
                          ),
                      children: [
                        TxnHistorySectionsContainer(
                          title: 'Transaction History',
                          height: 175.h,
                          children: [
                            TxnRowBuilder(
                                name: 'Date',
                                value: formatDateSlash(
                                    txnDetails?.created_at ?? "")),
                            TxnRowBuilder(
                                name: 'Time',
                                value: formatTimeTwelveHours(
                                    txnDetails?.created_at ?? "NA")),
                            TxnRowBuilder(
                                name: 'Type',
                                value: txnDetails?.trade_type ?? 'NA'),
                          ],
                        ),
                        TxnHistorySectionsContainer(
                          title: 'Giftcard Specifications',
                          height: 221,
                          children: [
                            TxnRowBuilder(
                                name: 'Category',
                                value: txnDetails?.giftcard_product
                                        ?.giftcard_category_alt?.name ??
                                    "NA"),
                            TxnRowBuilder(
                              name: 'Country',
                              value: txnDetails
                                      ?.giftcard_product?.country?["name"] ??
                                  "NA",
                            ),
                            TxnRowBuilder(
                                name: 'Product',
                                value:
                                    txnDetails?.giftcard_product?.name ?? "NA"),
                            TxnRowBuilder(
                                name: 'Type',
                                value: capitalizeFirstString(
                                    txnDetails?.card_type ?? "NA")),
                          ],
                        ),
                        TxnHistorySectionsContainer(
                          height: 182.h,
                          title: 'const',
                          children: [
                            TxnRowBuilder(
                                name: 'Amount', value: formatCurrency(payable)),
                            TxnRowBuilder(name: 'Units', value: '1'),
                            TxnRowBuilder(
                                name: 'Rates',
                                value: formatCurrency(txnDetails?.rate)),
                          ],
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            decoration: BoxDecoration(
                                color: ColorManager.kWhite,
                                border: Border.all(
                                    color: ColorManager.kBorder
                                        .withOpacity(0.30))),
                            height: 141.h,
                            child: txnDetails!.trade_type!.toLowerCase() ==
                                    'sell'
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Cost',
                                        style: get16TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      PaymentIfo(
                                        accountName: txnDetails?.account_name!
                                                .toTitleCase() ??
                                            'NA',
                                        accountNumber:
                                            txnDetails?.account_number ?? 'NA',
                                        bankName:
                                            txnDetails?.bank?.name ?? 'NA',
                                      )
                                    ],
                                  )
                                : SizedBox()),
                        buildSpacer(),
                        txnDetails!.trade_type!.toLowerCase() == 'sell'
                            ? Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: buildHistoryImage(),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
                        buildSpacer(),
                        buildSpacer(),
                        buildSpacer(),
                        buildSpacer(),
                        buildSpacer(),
                        buildSpacer(),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget buildHistoryImage() {
    return Row(
      children: [
        for (int i = 0; i < (txnDetails?.cards ?? []).length; i++)
          buildMedia(txnDetails?.cards?[i].original_url ?? ""),
      ],
    );
  }

  Widget buildProofImage() {
    return Row(
      children: [
        for (int i = 0; i < (txnDetails?.review_proof ?? []).length; i++)
          buildMedia((txnDetails?.review_proof?[i] ?? "").toString()),
      ],
    );
  }

  Widget buildMedia(String imageUrl) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        showDialogPopup(context, ImagePreviewPopup(imageUrl: imageUrl),
            barrierDismissible: true);
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 12),
        child: loadNetworkImage(imageUrl, height: 79, width: 87),
      ),
    );
  }

  Widget buildItemShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SquareShimmer(height: 14, width: 58),
        SizedBox(height: 8),
        SquareShimmer(height: 20, width: 100)
      ],
    );
  }

  String? getReviewedDate() {
    String status = (txnDetails?.status ?? "").toLowerCase();
    if (status != "pending") {
      return formatDateAlt(txnDetails?.updated_at ?? "");
    }
    return null;
  }
}

class TxnHistorySectionsContainer extends StatelessWidget {
  final double height;
  final String title;
  final List<Widget> children;

  const TxnHistorySectionsContainer(
      {super.key,
      required this.height,
      required this.title,
      required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
          color: ColorManager.kWhite,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: ColorManager.kBorder.withOpacity(0.30))),
      height: height.h,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 20.h,
        ),
        Text(
          title.toTitleCase(),
          style: get16TextStyle(fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: children,
          ),
        )
      ]),
    );
  }
}
