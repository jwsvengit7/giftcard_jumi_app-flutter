import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/core/helpers/transaction_helper.dart';
import 'package:jimmy_exchange/core/model/wallet_txn_history.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/giftcard/giftcard_txn_history_details.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_back_button.dart';
import 'package:jimmy_exchange/presentation/widgets/shimmers/square_shimmer.dart';
import 'package:jimmy_exchange/presentation/widgets/transaction_details_components.dart';

import '../resources/color_manager.dart';
import '../resources/styles_manager.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/custom_snackbar.dart';

class WalletTxnHistoryDetails extends StatefulWidget {
  final WalletTxnHistory param;

  const WalletTxnHistoryDetails({super.key, required this.param});

  @override
  State<WalletTxnHistoryDetails> createState() =>
      _WalletTxnHistoryDetailsState();
}

class _WalletTxnHistoryDetailsState extends State<WalletTxnHistoryDetails> {
  ScrollController scrollController = ScrollController();

  bool loading = true;
  WalletTxnHistory? txnDetails;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TransactionHelper.getWalletTxnHistoryDetails(
              "/${widget.param.id}?include=bank")
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
    return CustomScaffold(
      backgroundColor: ColorManager.kGray11,
      appBar: CustomAppBar(
        backgroundColor: ColorManager.kGray11,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CustomBackButton(),
        ),
        title: Text("Transaction Details", style: get20TextStyle()),
      ),
      body: loading
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
                    ],
                  ),
                ],
              ),
            )
          : Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
              ),
              child: Column(
                children: [
                  //
                  SizedBox(
                    height: 238.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TransactionBadgeImageIcon(
                          status: txnDetails?.status ?? '',
                          pageReference: 'fundsWithdrawal',
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 18.h, bottom: 12.h),
                          child: TradeType(
                              pageReference: 'Funds Withdrawal', tradeType: ''),
                        ),
                      ],
                    ),
                  ),
                  //
                  TxnHistorySectionsContainer(
                    title: 'Transaction History',
                    height: 175.h,
                    children: [
                      TxnRowBuilder(
                          name: 'Date',
                          value: formatDateSlash(
                              txnDetails?.createdAt.toString() ?? "")),
                      TxnRowBuilder(
                          name: 'Time',
                          value: formatTimeTwelveHours(
                              txnDetails?.createdAt.toString() ?? "NA")),
                    ],
                  ),

                  TxnHistorySectionsContainer(
                    title: 'Paid Info',
                    height: 138.h,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: PaymentIfo(
                              accountName:
                                  txnDetails?.accountName?.toTitleCase() ??
                                      'NA',
                              accountNumber: txnDetails?.accountNumber ?? 'NA',
                              bankName: txnDetails?.bank?.name ?? 'NA',
                            ),
                          ),
                        ],
                      )
                    ],
                  ),

                  TxnHistorySectionsContainer(
                    title: 'Transaction ID',
                    height: 108.h,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: buildItemList(
                                subTitle: txnDetails!.id ?? 'NA')),
                      ),
                    ],
                  ),

                  //
                  TxnHistorySectionsContainer(
                    title: 'Description',
                    height: 145.h,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: buildItemList(
                                subTitle: txnDetails?.summary ?? "NA")),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildSpacer() => const SizedBox(height: 12);

  String? getReviewedDate() {
    String status = (txnDetails?.status ?? "").toLowerCase();
    if (status == "completed" || status == "declined") {
      return formatDateAlt(txnDetails?.updatedAt.toString() ?? "");
    }
    return null;
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

  Widget buildItemList({String? title, required String subTitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? '',
          style: get14TextStyle().copyWith(
            color: ColorManager.kFormHintText,
          ),
        ),
        title == null ? SizedBox(height: 0.h) : SizedBox(height: 7.h),
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
