import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:jimmy_exchange/core/helpers/transaction_helper.dart';
import 'package:jimmy_exchange/core/providers/txn_history_provider.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_back_button.dart';
import 'package:jimmy_exchange/presentation/widgets/no_content.dart';
import 'package:jimmy_exchange/presentation/widgets/tiles/wallet_transaction_tile.dart';
import 'package:provider/provider.dart';

import '../../core/model/wallet_txn_history.dart';
import '../../core/utils/utils.dart';
import '../resources/color_manager.dart';
import '../resources/image_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/styles_manager.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_bottom_sheet.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/history_filter.dart';
import '../widgets/shimmers/square_shimmer.dart';

class WalletTxnHistoryView extends StatefulWidget {
  const WalletTxnHistoryView({super.key});

  @override
  State<WalletTxnHistoryView> createState() => _WalletTxnHistoryViewState();
}

class _WalletTxnHistoryViewState extends State<WalletTxnHistoryView> {
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
  List<WalletTxnHistory> transactionHistory = [];

  // FILTER
  int filter_txn_page = 1;
  List<WalletTxnHistory> allFilter = [];

  // SEARCH
  int search_txn_page = 1;
  List<WalletTxnHistory> allSearch = [];

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

  bool fetching = true;

  String? filterQueryParam;

  @override
  Widget build(BuildContext context) {
    TxnHistoryProvider txnHistoryProvider =
        Provider.of<TxnHistoryProvider>(context);

    return CustomScaffold(
      backgroundColor: ColorManager.kWhite,
      appBar: CustomAppBar(
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CustomBackButton(),
        ),
        title: Text("All Wallet Transaction", style: get20TextStyle()),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 34),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: CustomInputField(
                      textEditingController: searchController,
                      onChanged: (e) => startSearch(e),
                      decoration: getSearchInputDecoration(
                        hintText: "Search by transactions",
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
                          child: GroupedListView<WalletTxnHistory, String>(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(),
                            elements: getElements(),
                            groupBy: (element) =>
                                getVerboseDateTimeRepresentationAlt(
                                    parseDate(element.createdAt.toString())),
                            sort: false,
                            groupComparator: (value1, value2) =>
                                value2.compareTo(value1),
                            order: GroupedListOrder.ASC,
                            controller: scrollController,
                            groupSeparatorBuilder: (String value) => Padding(
                              padding:
                                   EdgeInsets.symmetric(vertical: 8.0.h),
                              child: Text(value,
                                  style: get14TextStyle(
                                      color: ColorManager.kTextColor)),
                            ),
                            itemBuilder: (c, el) {
                              return WalletTransactionTile(
                                param: el,
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      RoutesManager.walletTxnHistoryDetails,
                                      arguments: el);
                                },
                              );
                            },
                            separator: const SizedBox(height: 00),
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

  List<WalletTxnHistory> getElements() {
    if (filterQueryParam != null) {
      return allFilter;
    } else if (searchController.text.isNotEmpty) {
      return allSearch;
    } else {
      return transactionHistory;
    }
  }

  Timer? timer;
  Future<void> startSearch(String arg) async {
    allSearch.clear();
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
    filter_txn_page = 1;
    filterQueryParam = arg;
    if (mounted) setState(() => fetching = true);
    await fetchHistory();
    fetching = false;
    if (mounted) setState(() {});
  }

  Future<void> fetchHistory() async {
    // ADD QUERY FOR SEARCH AND FILTER IF AVAILABLE
    String query = "?per_page=100&include=bank";
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

    await TransactionHelper.getWalletTxnHistory(query).then((value) {
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
        allFilter.addAll(value);
      } else if (searchController.text.isNotEmpty) {
        allSearch.addAll(value);
      } else {
        transactionHistory.addAll(value);
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
