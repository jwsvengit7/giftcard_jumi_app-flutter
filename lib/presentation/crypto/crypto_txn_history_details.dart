import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/core/helpers/transaction_helper.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/giftcard/giftcard_txn_history_details.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_back_button.dart';
import 'package:jimmy_exchange/presentation/widgets/shimmers/square_shimmer.dart';
import 'package:jimmy_exchange/presentation/widgets/transaction_details_components.dart';

import '../../core/constants.dart';
import '../../core/model/crypto_txn_history.dart';
import '../resources/color_manager.dart';
import '../resources/styles_manager.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/popups/image_preview_popup.dart';
import '../widgets/popups/index.dart';

class CryptoTxnHistoryDetails extends StatefulWidget {
  final String reference;

  const CryptoTxnHistoryDetails({super.key, required this.reference});

  @override
  State<CryptoTxnHistoryDetails> createState() =>
      _CryptoTxnHistoryDetailsState();
}

class _CryptoTxnHistoryDetailsState extends State<CryptoTxnHistoryDetails> {
  ScrollController scrollController = ScrollController();

  bool loading = true;
  CryptoTxnHistory? txnDetails;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TransactionHelper.getCryptoTxnHistoryDetails(
              "/${widget.reference}?include=network,asset")
          .then((value) {
        txnDetails = value;
        setState(() => loading = false);
      }).catchError((_) {
        showCustomSnackBar(
          context: context,
          text: "An error occurred, please try again.",
        );
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    num _payable = txnDetails?.payable_amount ?? 0;
    num previous_payable = 0;

    if (txnDetails != null) {
      previous_payable = calPreviousPartialAmountForCryptoTxn(txnDetails!) ?? 0;
    }

    if (txnDetails?.review_amount != null) {
      _payable = txnDetails?.review_amount ?? 0;
      previous_payable = txnDetails?.payable_amount ?? 0;
    }

    return CustomScaffold(
      backgroundColor: ColorManager.kWhite,
      appBar: CustomAppBar(backgroundColor: ColorManager.kGray11,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CustomBackButton(),
        ),
        title: Text("Transaction Details", style: get20TextStyle()),
      ),
      body: Material(color: ColorManager.kGray11,
        child: loading
            ? Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //

                    const Padding(
                      padding: EdgeInsets.only(top: 35, bottom: 20),
                      child: Center(child: SquareShimmer(height: 42, width: 200)),
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
                  Container(
                    color: ColorManager.kGray11,
                    height: 238.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TransactionBadgeImageIcon(
                            status: txnDetails?.status ?? '',
                            pageReference: 'crypto'),
                        Padding(
                          padding: EdgeInsets.only(top: 18.h, bottom: 12.h),
                          child: TradeType(
                              pageReference: 'crypto',
                              tradeType: txnDetails?.trade_type ?? ''),
                        ),
                        txnDetails?.status?.toLowerCase() ==
                                Constants.kPartiallyApprovedStatus
                            ? Center(
                                child: Text(
                                  formatCurrency(previous_payable),
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
                            "NGN ${formatNumber(_payable)}",
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
                      controller: scrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                      ),
                      children: [
                        TxnHistorySectionsContainer(
                          height: 174.h,
                          title: 'Transaction History',
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
                          height: 148.h,
                          title: 'Crypto Specifications',
                          children: [
                            TxnRowBuilder(
                                name: 'Network',
                                value: txnDetails?.network?.name ?? "--"),
                            TxnRowBuilder(
                              name: 'Asset',
                              value:
                                  "${formatNumber(txnDetails?.asset_amount ?? 0)} ${txnDetails?.asset?.code}",
                            ),
                          ],
                        ),
                        TxnHistorySectionsContainer(
                          height: 189.h,
                          title: 'Cost',
                          children: [
                            TxnRowBuilder(
                                name: txnDetails?.trade_type == Constants.kBuyType
                                    ? 'You Purchasing'
                                    : 'You are Selling',
                                value: '1 Unit(s)'
                                // getProductUnit(
                                //     amount: txnDetails?.payable_amount, rate: txnDetails?.rate)

                                ),
                            TxnRowBuilder(
                              name: txnDetails?.trade_type == Constants.kSellType
                                  ? 'You are Credited'
                                  : 'You are Debited',
                              value: getTxnAmount(true),
                            ),
                            TxnRowBuilder(
                              name: 'Rates',
                              value:
                                  '${txnDetails?.network?.name ?? '--'} ${txnDetails?.rate ?? '--'}',
                            ),
                          ],
                        ),

                        Container(
                            height: txnDetails!.trade_type!.toLowerCase() ==
                                    Constants.kBuyType
                                ? 110.h
                                : 141.h,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            decoration: BoxDecoration(
                                color: txnDetails!.trade_type!.toLowerCase() ==
                                        Constants.kSellType
                                    ? ColorManager.kWhite
                                    : ColorManager.kPrimaryBlue.withOpacity(0.15),
                                border: Border.all(
                                    color:
                                        ColorManager.kBorder.withOpacity(0.30))),
                            child: txnDetails!.trade_type!.toLowerCase() ==
                                    Constants.kSellType
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Text(
                                        'Pay Info',
                                        style: get16TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      PaymentIfo(
                                        accountName: 'Account Name',
                                        accountNumber: '00000000000000',
                                        bankName: 'Account Name',
                                      )
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Wallet Address',
                                        style: get14TextStyle().copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: ColorManager.kPrimaryBlue),
                                      ),
                                      Text(
                                        txnDetails?.network?.wallet ?? "--",
                                        style: get14TextStyle().copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: ColorManager.kBlack),
                                      )
                                    ],
                                  )),

                        const SizedBox(height: 12),
                        txnDetails?.status?.toLowerCase() ==
                                Constants.kPartiallyApprovedStatus
                            ? buildItemList(
                                "Old Amount", formatCurrency(previous_payable))
                            : const SizedBox(),

                        //
                        const SizedBox(height: 12),
                        (txnDetails?.comment ?? "").isEmpty
                            ? const SizedBox()
                            : buildItemList(
                                "Comments", txnDetails?.comment ?? ""),

                        //

                        (txnDetails?.proof ?? "").isEmpty &&
                                (txnDetails!.trade_type == Constants.kBuyType)
                            ? const SizedBox()
                            : Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Proof",
                                      style: get16TextStyle(
                                          fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          showDialogPopup(
                                              context,
                                              ImagePreviewPopup(
                                                  imageUrl:
                                                      txnDetails?.proof ?? ""),
                                              barrierDismissible: true);
                                        },
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(bottom: 12),
                                          child: loadNetworkImage(fit: BoxFit.fill,
                                              txnDetails?.proof ?? "",
                                              height: 79,
                                              width: 87),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                        (txnDetails?.review_proof ?? []).isEmpty
                            ? const SizedBox()
                            : Padding(
                                padding:
                                    const EdgeInsets.only(top: 12, bottom: 10),
                                child: Text("Review Proof",
                                    style: get14TextStyle().copyWith(
                                        color: ColorManager.kFormHintText))),
                        (txnDetails?.review_proof ?? []).isEmpty
                            ? const SizedBox()
                            : Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: buildProofImage()),
                                    ),
                                  ],
                                ),
                              ),

                        (txnDetails?.review_note ?? "").isEmpty
                            ? const SizedBox()
                            : buildItemList(
                                "Review Note", txnDetails?.review_note ?? ""),

                        const SizedBox(height: 30)
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

//EXPERIMENTAL VALUE
  String getProductUnit({num? rate, num? amount}) {
    num? unit;
    unit = (amount! / rate!);
    return unit.toString();
  }

  String getTxnAmount(bool useCurrency) {
    if (txnDetails?.review_amount != null) {
      return useCurrency
          ? formatCurrency(txnDetails?.review_amount)
          : formatNumber(txnDetails?.review_amount);
    }

    if (txnDetails?.review_rate == null) {
      return useCurrency
          ? formatCurrency(txnDetails?.payable_amount ?? 0)
          : formatNumber(txnDetails?.payable_amount ?? 0);
    }

    return useCurrency
        ? formatCurrency(txnDetails?.review_rate * txnDetails?.asset_amount)
        : formatNumber(txnDetails?.review_rate * txnDetails?.asset_amount);
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

  Widget buildItemList(String title, String subTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: get14TextStyle().copyWith(
            color: ColorManager.kFormHintText,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          subTitle,
          style: get16TextStyle().copyWith(
            color: ColorManager.kBlack,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
