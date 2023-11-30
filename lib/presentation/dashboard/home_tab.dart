import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:jimmy_exchange/core/model/crypto_txn_history.dart';
import 'package:jimmy_exchange/core/model/user.dart';
import 'package:jimmy_exchange/core/providers/user_provider.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/widgets/home_widgets/custom_sliver.dart';
import 'package:jimmy_exchange/presentation/widgets/tiles/banner_tiles.dart';
import 'package:jimmy_exchange/presentation/widgets/tiles/crypto_transaction_tile.dart';
import 'package:jimmy_exchange/presentation/widgets/tiles/giftcard_transaction_tile.dart';
import 'package:provider/provider.dart';

import '../../core/model/banner.dart';
import '../../core/model/giftcard_txn_history.dart';
import '../../core/providers/generic_provider.dart';
import '../../core/providers/txn_history_provider.dart';
import '../resources/color_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/styles_manager.dart';
import '../widgets/dashboard_widgets.dart';
import '../widgets/no_content.dart';
import '../widgets/shimmers/square_shimmer.dart';
import '../widgets/spacer.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  ScrollController scrollController = ScrollController();
  bool fetching = false;
  String currentTab = "giftcard";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      updateBanners();
      await updateTxnHistory();
    });
    super.initState();
  }

  Future<void> updateBanners() async {
    try {
      GenericProvider genericProvider =
          Provider.of<GenericProvider>(context, listen: false);
      genericProvider.updateBanners();
    } catch (_) {}
  }

  Future<void> updateTxnHistory() async {
    TxnHistoryProvider txnHistoryProvider =
        Provider.of<TxnHistoryProvider>(context, listen: false);

    setState(() => fetching = true);

    await txnHistoryProvider.updateGiftcardTxnHistory();
    await txnHistoryProvider.updateCryptoTxnHistory();
    await txnHistoryProvider.updateAllTxnHistory();
    setState(() => fetching = false);
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    GenericProvider genericProvider = Provider.of<GenericProvider>(context);
    TxnHistoryProvider txnHistoryProvider =
        Provider.of<TxnHistoryProvider>(context);
    User user = userProvider.user ?? User(wallet_balance: 0);
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const DashboardTabTopSpacer(),
          DashboardTitleBar(
              name:
                  "Welcome, ${truncateWithEllipsis(10, user.firstname ?? "")}"),
          SizedBox(height: 20.h),
          // QUICK ACTIONS
          SizedBox(height: 15.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Quick Actions",
              style: get16TextStyle(fontSize: 16.sp).copyWith(
                  fontWeight: FontWeight.w500, color: ColorManager.kGray8),
            ),
          ),
          SizedBox(height: 16.h),

          SliverScrollView(),
          ////
          // Expanded(
          //   child: ListView(
          //     padding: const EdgeInsets.only(),
          //     children: [

          //       SliverScrollView(),
          //       Row(
          //         children: [
          //           Flexible(
          //             flex: 1,
          //             child: GestureDetector(
          //               behavior: HitTestBehavior.translucent,
          //               onTap: () async {
          //                 List<SellGiftcard2Arg> arg = [];
          //                 await Navigator.pushNamed(
          //                     context, RoutesManager.sellGiftcard1Route,
          //                     arguments: arg);
          //               },
          //               child: Image.asset(ImageManager.kSellGiftcard),
          //             ),
          //           ),
          //           const SizedBox(width: 22),
          //           Flexible(
          //             flex: 1,
          //             child: GestureDetector(
          //               behavior: HitTestBehavior.translucent,
          //               onTap: () {
          //                 // Navigator.pushNamed(context, RoutesManager.buyGiftcardRoute);
          //                 showCustomSnackBar(
          //                     context: context,
          //                     text:
          //                         "Gift card purchase unavailable. We're working on it.\n Thank you for your patience.",
          //                     type: NotificationType.neutral);
          //               },
          //               child: Image.asset(ImageManager.kBuyGiftcard),
          //             ),
          //           ),
          //         ],
          //       ),
          //       const SizedBox(height: 16),
          //       Row(
          //         children: [
          //           Flexible(
          //             flex: 1,
          //             child: GestureDetector(
          //               behavior: HitTestBehavior.translucent,
          //               onTap: () async {
          //                 await Navigator.pushNamed(
          //                     context, RoutesManager.sellCryptoView);
          //                 // showCustomSnackBar(
          //                 //     context: context,
          //                 //     text:
          //                 //         "Crypto purchase unavailable. We're working on it.\n Thank you for your patience.",
          //                 //     type: NotificationType.neutral);
          //               },
          //               child: Image.asset(ImageManager.kSellCrypto),
          //             ),
          //           ),
          //           const SizedBox(width: 22),
          //           Flexible(
          //             flex: 1,
          //             child: GestureDetector(
          //               behavior: HitTestBehavior.translucent,
          //               onTap: () async {
          //                 showCustomSnackBar(
          //                     context: context,
          //                     text:
          //                         "Crypto purchase unavailable. We're working on it.\n Thank you for your patience.",
          //                     type: NotificationType.neutral);
          //                 // await Navigator.pushNamed(
          //                 //     context, RoutesManager.buyCryptoRoute);
          //               },
          //               child: Image.asset(ImageManager.kBuyCrypto),
          //             ),
          //           ),
          //         ],
          //       ),

          //       // BANNERS
          //       buildBannerView(size, genericProvider.banners),

          //       // RECENT TRANSACTION
          //       const SizedBox(height: 32),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             "Recent Transactions",
          //             style: get16TextStyle()
          //                 .copyWith(fontWeight: FontWeight.w400),
          //           ),
          //           GestureDetector(
          //             behavior: HitTestBehavior.translucent,
          //             onTap: () {
          //               Navigator.pushNamed(
          //                   context, RoutesManager.allTxnHistoryView);
          //             },
          //             child: Text(
          //               "View all",
          //               style: get16TextStyle().copyWith(
          //                 fontWeight: FontWeight.w400,
          //                 decoration: TextDecoration.underline,
          //               ),
          //             ),
          //           )
          //         ],
          //       ),

          //       const SizedBox(height: 28),
          //       Row(
          //         children: [
          //           //
          //           Expanded(
          //             flex: 1,
          //             child: TabButton(
          //               active: currentTab == "giftcard",
          //               onTap: () {
          //                 setState(() {
          //                   currentTab = "giftcard";
          //                 });
          //               },
          //               child: Center(
          //                 child: Padding(
          //                   padding: const EdgeInsets.only(bottom: 14),
          //                   child: Text("Giftcard"),
          //                 ),
          //               ),
          //             ),
          //           ),
          //           Expanded(
          //             flex: 1,
          //             child: TabButton(
          //               active: currentTab == "crypto",
          //               onTap: () {
          //                 setState(() {
          //                   currentTab = "crypto";
          //                 });
          //               },
          //               child: Center(
          //                 child: Padding(
          //                   padding: const EdgeInsets.only(bottom: 14),
          //                   child: Text("Crypto"),
          //                 ),
          //               ),
          //             ),
          //           ),

          //           //
          //         ],
          //       ),

          //       SizedBox(
          //         height: 500,
          //         child: fetching
          //             ? buildLoading()
          //             : currentTab == "crypto"
          //                 ? buildCryptoTxn(txnHistoryProvider.cryptoTxnHistory
          //                     .take(5)
          //                     .toList())
          //                 : buildGiftCardTxn(txnHistoryProvider
          //                     .giftcardTxnHistory
          //                     .take(5)
          //                     .toList()),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget buildBannerView(Size size, List<Banners> banners) {
    if (banners.isEmpty) return SizedBox();

    return Column(
      children: [
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Banners",
              style: get16TextStyle().copyWith(fontWeight: FontWeight.w400),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.pushNamed(context, RoutesManager.bannerView);
              },
              child: Text(
                "View all",
                style: get16TextStyle().copyWith(
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          ],
        ),
        //
        const SizedBox(height: 16),

        SizedBox(
          height: 125,
          child: ListView.separated(
            separatorBuilder: (ctx, index) {
              return SizedBox(width: 16);
            },
            scrollDirection: Axis.horizontal,
            itemCount: banners.length,
            itemBuilder: (ctx, index) {
              return BannerTiles(banners: banners[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget buildLoading() => ListView.separated(
        separatorBuilder: ((context, index) => const SizedBox(height: 20)),
        itemCount: 4,
        itemBuilder: (_, int i) =>
            const SquareShimmer(width: double.infinity, height: 50),
      );

  Widget buildGiftCardTxn(List<GiftcardTxnHistory> txn) {
    return RefreshIndicator(
      color: ColorManager.kPrimaryBlack,
      onRefresh: updateTxnHistory,
      child: txn.isEmpty
          ? ListView(children: const [NoContent(displayImage: true)])
          : GroupedListView<GiftcardTxnHistory, String>(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 85),
              elements: txn,
              groupBy: (element) => getVerboseDateTimeRepresentationAlt(
                  parseDate(element.created_at)),
              sort: false,
              groupComparator: (value1, value2) => value2.compareTo(value1),
              order: GroupedListOrder.ASC,
              controller: scrollController,
              groupSeparatorBuilder: (String value) => Padding(
                padding: const EdgeInsets.only(top: 28, bottom: 16),
                child: Text(value,
                    style: get14TextStyle(color: ColorManager.kTextColor)),
              ),
              itemBuilder: (c, el) {
                return GiftcardTransactionTile(
                  param: el,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RoutesManager.giftcardTxnHistoryDetailsView,
                      arguments: el.reference ?? "",
                    );
                  },
                );
              },
              separator: const SizedBox(height: 20),
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: false,
              addSemanticIndexes: false,
            ),
    );
  }

  Widget buildCryptoTxn(List<CryptoTxnHistory> txn) {
    return RefreshIndicator(
      color: ColorManager.kPrimaryBlack,
      onRefresh: updateTxnHistory,
      child: txn.isEmpty
          ? ListView(children: const [NoContent(displayImage: true)])
          : GroupedListView<CryptoTxnHistory, String>(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 85),
              elements: txn,
              groupBy: (element) => getVerboseDateTimeRepresentationAlt(
                  parseDate(element.created_at)),
              sort: false,
              groupComparator: (value1, value2) => value2.compareTo(value1),
              order: GroupedListOrder.ASC,
              controller: scrollController,
              groupSeparatorBuilder: (String value) => Padding(
                padding: const EdgeInsets.only(top: 28, bottom: 16),
                child: Text(value,
                    style: get14TextStyle(color: ColorManager.kTextColor)),
              ),
              itemBuilder: (c, el) {
                return CryptoTransactionTile(
                  param: el,
                  onTap: () {
                    Navigator.pushNamed(
                        context, RoutesManager.cryptoTxnHistoryDetails,
                        arguments: el.reference ?? "");
                  },
                );
              },
              separator: const SizedBox(height: 20),
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: false,
              addSemanticIndexes: false,
            ),
    );
  }
}
