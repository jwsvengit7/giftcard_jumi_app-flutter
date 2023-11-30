import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:jimmy_exchange/core/providers/txn_history_provider.dart';
import 'package:jimmy_exchange/presentation/resources/route_arg/giftcard_arg.dart';
import 'package:jimmy_exchange/presentation/widgets/no_content.dart';
import 'package:provider/provider.dart';

import '../../core/enum.dart';
import '../../core/model/all_txn_history.dart';
import '../../core/model/buy_and_sell_giftcard_view_model.dart';
import '../../core/model/giftcard_txn_history.dart';
import '../../core/utils/utils.dart';
import '../resources/color_manager.dart';
import '../resources/image_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/styles_manager.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/dashboard_widgets.dart';
import '../widgets/grouped_transactions.dart';
import '../widgets/shimmers/square_shimmer.dart';
import '../widgets/spacer.dart';
import '../widgets/tiles/giftcard_transaction_tile.dart';

class GiftCardTab extends StatefulWidget {
  const GiftCardTab({super.key});

  @override
  State<GiftCardTab> createState() => _GiftCardTabState();
}

class _GiftCardTabState extends State<GiftCardTab> {
  bool fetching = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await updateTxnHistory();
    });
    super.initState();
  }

  Future<void> updateTxnHistory() async {
    TxnHistoryProvider txnHistoryProvider =
        Provider.of<TxnHistoryProvider>(context, listen: false);
    if (txnHistoryProvider.giftcardTxnHistory.isEmpty) {
      setState(() => fetching = true);
    }
    await txnHistoryProvider.updateGiftcardTxnHistory();
    setState(() => fetching = false);
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    TxnHistoryProvider txnHistoryProvider =
        Provider.of<TxnHistoryProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const DashboardTabTopSpacer(),
          const DashboardTitleBar(
            name: "GiftCards",
            leadingWidget: SizedBox.shrink(),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    List<SellGiftCard2Arg> arg = [];
                    await Navigator.pushNamed(
                        context, RoutesManager.sellGiftcard1Route,
                        arguments: BuyAndSaleGiftCardViewParams(
                            giftCardList: arg, isGiftCardSale: true));
                  },
                  child: Container(
                    height: 86.h,
                    padding: EdgeInsets.only(
                      left: 20.w,
                      right: 20.w,
                    ),
                    decoration: BoxDecoration(
                      color: ColorManager.kPrimaryBlueAccent.withOpacity(0.12),
                      border: Border.all(
                          color: ColorManager.kPrimaryBlue.withOpacity(0.15)),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              ImageManager.kGiftcard,
                              height: 27.h,
                              width: 39.w,
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sell Giftcard",
                                    style: get14TextStyle(
                                      color: ColorManager.kPrimaryBlue,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Text(
                                    'Lorem ipsum dolor sit amet consectetur.',
                                    textAlign: TextAlign.left,
                                    style: get14TextStyle(
                                      color: ColorManager.kGray1,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Icon(Icons.arrow_forward_ios_outlined,
                                color: ColorManager.kPrimaryBlue, size: 20)
                          ]),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    List<SellGiftCard2Arg> arg = [];
                    await Navigator.pushNamed(
                        context, RoutesManager.sellGiftcard1Route,
                        arguments: BuyAndSaleGiftCardViewParams(
                            giftCardList: arg, isGiftCardSale: false));
                    // showCustomSnackBar(
                    //     context: context,
                    //     text:
                    //         "Gift card purchase unavailable. We're working on it.\n Thank you for your patience.",
                    //     type: NotificationType.neutral);
                  },
                  child: Container(
                    height: 86.h,
                    padding: EdgeInsets.only(
                      left: 20.w,
                      right: 20.w,
                    ),
                    decoration: BoxDecoration(
                      color: ColorManager.kPrimaryBlueAccent.withOpacity(0.12),
                      border: Border.all(
                          color: ColorManager.kPrimaryBlue.withOpacity(0.15)),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              ImageManager.kGiftcard,
                              height: 27.h,
                              width: 39.w,
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Buy Giftcard",
                                    style: get14TextStyle(
                                      color: ColorManager.kPrimaryBlue,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Text(
                                    'Lorem ipsum dolor sit amet consectetur.',
                                    textAlign: TextAlign.left,
                                    style: get14TextStyle(
                                      color: ColorManager.kGray1,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Icon(Icons.arrow_forward_ios_outlined,
                                color: ColorManager.kPrimaryBlue, size: 20)
                          ]),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 40.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Transactions",
                style: get16TextStyle().copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: ColorManager.kBlack),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (txnHistoryProvider.giftcardTxnHistory.isEmpty) {
                    showCustomSnackBar(
                        context: context,
                        text: "You do not have a transaction history yet.",
                        type: NotificationType.error);

                    return;
                  }
                  Navigator.pushNamed(
                      context, RoutesManager.giftcardTxnHistoryView);
                },
                child: Row(
                  children: [
                    Text(
                      "View All",
                      style: get16TextStyle().copyWith(
                          fontWeight: FontWeight.w400,
                          color: ColorManager.kPrimaryBlue,
                          fontSize: 14.sp),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Icon(
                      Icons.play_arrow,
                      color: ColorManager.kPrimaryBlue,
                    )
                  ],
                ),
              )
            ],
          ),
          fetching
              ? buildLoading()
              : Expanded(
                  child: RefreshIndicator(
                      color: ColorManager.kPrimaryBlack,
                      onRefresh: updateTxnHistory,
                      child: txnHistoryProvider.giftcardTxnHistory.isEmpty
                          ? ListView(
                              children: const [NoContent(displayImage: true)],
                            )
                          : Column(
                              children: [
                                GroupTransactionHistory(
                                  scrollController: scrollController,
                                  transactionHistoryList: convertDataType(
                                      txnHistoryProvider.giftcardTxnHistory),
                                ),
                              ],
                            )

                      //  GroupedListView<GiftcardTxnHistory, String>(
                      //     physics: const AlwaysScrollableScrollPhysics(),
                      //     padding: const EdgeInsets.only(bottom: 85),
                      //     elements: txnHistoryProvider.giftcardTxnHistory,
                      //     groupBy: (element) =>
                      //         getVerboseDateTimeRepresentationAlt(
                      //             parseDate(element.created_at)),
                      //     sort: false,
                      //     groupComparator: (value1, value2) =>
                      //         value2.compareTo(value1),
                      //     order: GroupedListOrder.ASC,
                      //     controller: scrollController,
                      //     groupSeparatorBuilder: (String value) => Padding(
                      //       padding:
                      //           const EdgeInsets.only(top: 28, bottom: 16),
                      //       child: Text(value,
                      //           style: get14TextStyle(
                      //               color: ColorManager.kTextColor)),
                      //     ),
                      //     itemBuilder: (c, el) {
                      //       return GiftcardTransactionTile(
                      //         param: el,
                      //         onTap: () {
                      //           Navigator.pushNamed(
                      //             context,
                      //             RoutesManager.giftcardTxnHistoryDetailsView,
                      //             arguments: el.reference ?? "",
                      //           );
                      //         },
                      //       );
                      //     },
                      //     separator: const SizedBox(height: 20),
                      //     addAutomaticKeepAlives: false,
                      //     addRepaintBoundaries: false,
                      //     addSemanticIndexes: false,
                      //   ),
                      ),
                ),
        ],
      ),
    );
  }

  Widget buildLoading() => Expanded(
        child: ListView.separated(
          separatorBuilder: ((context, index) => const SizedBox(height: 20)),
          itemCount: 5,
          itemBuilder: (_, int i) =>
              const SquareShimmer(width: double.infinity, height: 50),
        ),
      );

  List<AllTxnHistory> convertDataType(List<GiftcardTxnHistory> historyList) {
    return historyList
        .map((e) => AllTxnHistory(
            id: e.id,
            type: e.card_type,
            reference: e.reference,
            status: e.status,
            trade_type: e.trade_type,
            amount: e.amount,
            payable_amount: e.payable_amount,
            created_at: e.created_at,
            rate: e.rate,
            review_rate: e.review_rate,
            service_charge: e.service_charge,
            review_amount: e.review_amount,
            category_icon: e.giftcard_product!.giftcard_category_alt!.icon,
            category_name: e.giftcard_product!.name,
            currency: formatCurrency(null,
                code: e.giftcard_product!.currency?["code"] ?? "")))
        .toList();
  }
}
