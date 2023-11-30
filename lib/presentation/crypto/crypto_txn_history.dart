import 'dart:async';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:jimmy_exchange/core/helpers/transaction_helper.dart';
import 'package:jimmy_exchange/core/model/crypto_txn_history.dart';
import 'package:jimmy_exchange/core/providers/txn_history_provider.dart';
import 'package:jimmy_exchange/presentation/widgets/no_content.dart';
import 'package:provider/provider.dart';

import '../../core/utils/utils.dart';
import '../resources/color_manager.dart';
import '../resources/image_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/styles_manager.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_bottom_sheet.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/ellipse.dart';
import '../widgets/history_filter.dart';
import '../widgets/shimmers/square_shimmer.dart';
import '../widgets/tiles/crypto_transaction_tile.dart';

class CryptoTxnHistoryView extends StatefulWidget {
  const CryptoTxnHistoryView({super.key});

  @override
  State<CryptoTxnHistoryView> createState() => _CryptoTxnHistoryViewState();
}

class _CryptoTxnHistoryViewState extends State<CryptoTxnHistoryView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      TxnHistoryProvider txnHistoryProvider =
          Provider.of<TxnHistoryProvider>(context, listen: false);
      txnHistoryProvider.updateCryptoStat().then((_) {}).catchError((_) {});
      await fetchHistory();
    });
    scrollController.addListener(pagination);
    super.initState();
  }

  bool paginatedLoading = false;

  // ALL
  int all_txn_page = 1;
  List<CryptoTxnHistory> transactionHistory = [];
  List<CryptoTxnHistory> allBought = [];
  List<CryptoTxnHistory> allSold = [];

  // FILTER
  int filter_txn_page = 1;
  List<CryptoTxnHistory> allFilter = [];
  List<CryptoTxnHistory> boughtFilter = [];
  List<CryptoTxnHistory> soldFilter = [];

  // SEARCH
  int search_txn_page = 1;
  List<CryptoTxnHistory> allSearch = [];
  List<CryptoTxnHistory> boughtSearch = [];
  List<CryptoTxnHistory> soldSearch = [];

  //
  void pagination() async {
    if ((scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !paginatedLoading)) {
      setState(() => paginatedLoading = true);
      fetchHistory();
    }
  }

  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  double _activeTabPosition = 0;

  bool fetching = true;

  String? filterQueryParam;

  @override
  Widget build(BuildContext context) {
    TxnHistoryProvider txnHistoryProvider =
        Provider.of<TxnHistoryProvider>(context);

    return CustomScaffold(
      backgroundColor: ColorManager.kWhite,
      appBar: CustomAppBar(
        title: Text("Crypto Transaction History", style: get20TextStyle()),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 34),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: ColorManager.kCryptoTab1,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Crypto Sold:",
                            style: get12TextStyle()
                                .copyWith(color: ColorManager.kSecBlue)),
                        const SizedBox(height: 8),
                        Text(
                          "${txnHistoryProvider.getCryptoPartailAndApprovedSoldCount()}",
                          style: get24TextStyle().copyWith(
                            fontWeight: FontWeight.w500,
                            color: ColorManager.kSecBlue,
                          ),
                        ),
                        const Spacer(),
                        Text("Value:",
                            style: get12TextStyle()
                                .copyWith(color: ColorManager.kSecBlue)),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            style: get24TextStyle().copyWith(
                              fontWeight: FontWeight.w500,
                              color: ColorManager.kSecBlue,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: formatNumber(
                                  txnHistoryProvider
                                      .getCryptoPartailAndApprovedSoldAmount(),
                                ),
                              ),
                              const TextSpan(
                                  text: ' NGN', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 170,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: ColorManager.kCryptoTab2,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Crypto Bought:",
                            style: get12TextStyle()
                                .copyWith(color: ColorManager.kSecBlue)),
                        const SizedBox(height: 8),
                        Text(
                          "${txnHistoryProvider.getCryptoPartailAndApprovedBuyCount()}",
                          style: get24TextStyle().copyWith(
                            fontWeight: FontWeight.w500,
                            color: ColorManager.kSecBlue,
                          ),
                        ),
                        const Spacer(),
                        Text("Value:",
                            style: get12TextStyle()
                                .copyWith(color: ColorManager.kSecBlue)),
                        const SizedBox(height: 8),
                        RichText(
                          overflow: TextOverflow.visible,
                          text: TextSpan(
                            style: get24TextStyle().copyWith(
                              fontWeight: FontWeight.w500,
                              color: ColorManager.kSecBlue,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: formatNumber(txnHistoryProvider
                                      .getCryptoPartailAndApprovedBuyAmount())),
                              const TextSpan(
                                  text: ' NGN', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: isSmallScreen(context) ? 20 : 38),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildTabHeader(text: "All", tabPosition: 0),
                buildTabHeader(text: "Bought", tabPosition: 1),
                buildTabHeader(text: "Sold", tabPosition: 2),
              ],
            ),

            Container(
              height: 50,
              margin: const EdgeInsets.only(top: 24),
              child: Row(
                children: [
                  Expanded(
                    child: CustomInputField(
                      textEditingController: searchController,
                      onChanged: (e) => startSearch(e),
                      decoration: getSearchInputDecoration(
                        hintText: "Search by status",
                        suffixIcon: const SizedBox(),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: Center(
                              child: Image.asset(ImageManager.kSearchIcon,
                                  width: 20, height: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      String? queryParam = await showCustomBottomSheet(
                        context: context,
                        screen: const HistoryFilter(),
                        isDismissible: true,
                      );
                      if (queryParam == null) {
                        filterQueryParam = null;
                        searchController.text = "";
                        setState(() {});
                        return;
                      }
                      startFilter(queryParam);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      height: double.infinity,
                      width: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xffF4F4F4),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(right: 10.5, left: 10.5),
                        child: Image.asset(
                          ImageManager.kFilter,
                          height: 18,
                          width: 15,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            filterQueryParam != null
                ? Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: buildHistoryFilterRow(),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),

            //
            fetching
                ? Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(top: 15),
                      separatorBuilder: ((context, index) =>
                          const SizedBox(height: 20)),
                      itemCount: 5,
                      itemBuilder: (_, int i) => const SquareShimmer(
                          width: double.infinity, height: 50),
                    ),
                  )
                : (getElements().isEmpty)
                    ? Expanded(
                        child: ListView(
                          children: const [
                            NoContent(
                              displayImage: true,
                              desc: "Please try different search param(s)",
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: RefreshIndicator(
                          color: ColorManager.kPrimaryBlack,
                          onRefresh: () async {
                            // DO NOTHING
                          },
                          child: GroupedListView<CryptoTxnHistory, String>(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(),
                            elements: getElements(),
                            groupBy: (element) =>
                                getVerboseDateTimeRepresentationAlt(
                                    parseDate(element.created_at)),
                            sort: false,
                            groupComparator: (value1, value2) =>
                                value2.compareTo(value1),
                            order: GroupedListOrder.ASC,
                            controller: scrollController,
                            groupSeparatorBuilder: (String value) => Padding(
                              padding:
                                  const EdgeInsets.only(top: 28, bottom: 16),
                              child: Text(value,
                                  style: get14TextStyle(
                                      color: ColorManager.kTextColor)),
                            ),
                            itemBuilder: (c, el) {
                              return CryptoTransactionTile(
                                param: el,
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      RoutesManager.cryptoTxnHistoryDetails,
                                      arguments: el.reference ?? "");
                                },
                              );
                            },
                            separator: const SizedBox(height: 20),
                            addAutomaticKeepAlives: false,
                            addRepaintBoundaries: false,
                            addSemanticIndexes: false,
                          ),
                        ),
                      ),

            //
            // PAGINATING...
            paginatedLoading
                ? const Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: SquareShimmer(height: 50, width: double.infinity))
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Widget buildHistoryFilterRow() {
    List<String> queries = filterQueryParam!.split("&");

    return Row(
      children: [
        for (var i = 0; i < queries.length; i++)
          HistoryFilterCard(
            filterQueryParam: queries[i],
            onClear: (val) {
              String res = filterQueryParam!.replaceAll(val, "");
              startFilter(res);
            },
          )
      ],
    );
  }

  List<CryptoTxnHistory> getElements() {
    if (filterQueryParam != null) {
      return (_activeTabPosition == 0
          ? allFilter
          : _activeTabPosition == 1
              ? boughtFilter
              : soldFilter);
    } else if (searchController.text.isNotEmpty) {
      return (_activeTabPosition == 0
          ? allSearch
          : _activeTabPosition == 1
              ? boughtSearch
              : soldSearch);
    } else {
      return (_activeTabPosition == 0
          ? transactionHistory
          : _activeTabPosition == 1
              ? allBought
              : allSold);
    }
  }

  Flexible buildTabHeader({required String text, required double tabPosition}) {
    return Flexible(
      flex: 1,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => setState(() => _activeTabPosition = tabPosition),
        child: Container(
          padding: EdgeInsets.only(
              bottom: tabPosition != _activeTabPosition ? 0 : 0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  width: 2,
                  style: BorderStyle.solid,
                  color: tabPosition != _activeTabPosition
                      ? const Color(0xffF4F5FF)
                      : ColorManager.kYellow),
            ),
          ),
          child: Column(
            children: [
              Text(
                text,
                style: get14TextStyle().copyWith(
                  fontWeight: tabPosition == _activeTabPosition
                      ? FontWeight.w500
                      : FontWeight.w400,
                  color: tabPosition == _activeTabPosition
                      ? ColorManager.kSecBlue
                      : const Color(0xff6B7280),
                ),
              ),
              const SizedBox(height: 6),
              tabPosition == _activeTabPosition
                  ? Container()
                  : buildDivider(height: 0)
            ],
          ),
        ),
      ),
    );
  }

  Timer? timer;
  Future<void> startSearch(String arg) async {
    allSearch.clear();
    soldSearch.clear();
    boughtSearch.clear();
    search_txn_page = 1;
    filterQueryParam = null;
    if (arg.isEmpty) return;
    if (mounted) setState(() => fetching = true);
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 750), () async {
      await fetchHistory();
      fetching = false;
      if (mounted) setState(() {});
    });
  }

  //
  Future<void> startFilter(String arg) async {
    allFilter.clear();
    soldFilter.clear();
    boughtFilter.clear();
    filter_txn_page = 1;
    filterQueryParam = arg;
    if (mounted) setState(() => fetching = true);
    await fetchHistory();
    fetching = false;
    if (mounted) setState(() {});
  }

  Future<void> fetchHistory() async {
    // ADD QUERY FOR SEARCH AND FILTER IF AVAILABLE
    String query = "?per_page=100&include=network,asset";
    String page = "page=$all_txn_page";
    String others = "";
    if (filterQueryParam != null) {
      others = "$filterQueryParam";
      page = "page=$filter_txn_page";
    } else if (searchController.text.isNotEmpty) {
      others = "filter[status]=${searchController.text}";
      page = "page=$search_txn_page";
    }
    if (others.isEmpty) {
      query = "$query&$page&$others";
    } else {
      query = "$query&$page&$others";
    }

    await TransactionHelper.getCryptoTxnHistory(query).then((value) {
      if (value.isNotEmpty) {
        if (filterQueryParam != null) {
          filter_txn_page = filter_txn_page + 1;
        } else if (searchController.text.isNotEmpty) {
          search_txn_page = search_txn_page + 1;
        } else {
          all_txn_page = all_txn_page + 1;
        }
      }

      /// IF no filter is applied
      if (filterQueryParam != null) {
        //

        allFilter.addAll(value);
        for (final CryptoTxnHistory e in value) {
          if (e.trade_type?.toLowerCase() == "buy") {
            boughtFilter.add(e);
          } else {
            soldFilter.add(e);
          }
        }
      } else if (searchController.text.isNotEmpty) {
        //

        allSearch.addAll(value);
        for (final CryptoTxnHistory e in value) {
          if (e.trade_type?.toLowerCase() == "buy") {
            boughtSearch.add(e);
          } else {
            soldSearch.add(e);
          }
        }
      } else {
        transactionHistory.addAll(value);

        for (final CryptoTxnHistory e in value) {
          if (e.trade_type?.toLowerCase() == "buy") {
            allBought.add(e);
          } else {
            allSold.add(e);
          }
        }
      }

      //
      if (mounted) {
        setState(() {
          fetching = false;
          paginatedLoading = false;
        });
      }
    }).catchError((err) {
      throw err.toString();
    });

    if (mounted) setState(() => paginatedLoading = false);
  }
}
