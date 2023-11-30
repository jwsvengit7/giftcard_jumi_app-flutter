import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:jimmy_exchange/core/helpers/referral_helper.dart';
import 'package:jimmy_exchange/core/model/referral.dart';
import 'package:jimmy_exchange/core/providers/txn_history_provider.dart';
import 'package:jimmy_exchange/presentation/widgets/ellipse.dart';
import 'package:jimmy_exchange/presentation/widgets/no_content.dart';
import 'package:jimmy_exchange/presentation/widgets/tiles/referral_tile.dart';
import 'package:provider/provider.dart';

import '../../core/utils/utils.dart';
import '../resources/color_manager.dart';
import '../resources/image_manager.dart';
import '../resources/styles_manager.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/history_filter.dart';
import '../widgets/shimmers/square_shimmer.dart';

class ReferralHistoryView extends StatefulWidget {
  const ReferralHistoryView({super.key});

  @override
  State<ReferralHistoryView> createState() => _ReferralHistoryViewState();
}

class _ReferralHistoryViewState extends State<ReferralHistoryView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      TxnHistoryProvider txnHistoryProvider =
          Provider.of<TxnHistoryProvider>(context, listen: false);
      txnHistoryProvider.updateCryptoStat().catchError((_) {});
      txnHistoryProvider.updateGiftcardStats().catchError((_) {});
      txnHistoryProvider.updateAllTxnStats().catchError((_) {});
      await fetchHistory();
    });
    scrollController.addListener(pagination);
    super.initState();
  }

  bool paginatedLoading = false;

  // ALL
  int all_txn_page = 1;
  List<Referral> transactionHistory = [];

  // FILTER
  int filter_txn_page = 1;
  List<Referral> allFilter = [];

  // SEARCH
  int search_txn_page = 1;
  List<Referral> allSearch = [];

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
    return CustomScaffold(
      backgroundColor: ColorManager.kWhite,
      appBar: CustomAppBar(
        title: Text("Referrals List", style: get20TextStyle()),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10),
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
                        hintText: "Search by name",
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
                  Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    height: double.infinity,
                    width: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xffF4F4F4),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10.5, left: 10.5),
                      child: PopupMenuButton(
                        padding: EdgeInsets.only(),
                        position: PopupMenuPosition.under,
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            onTap: () async {
                              startFilter("filter[paid]=true");
                            },
                            child: Center(
                              child: buildPopupMenuItemCard("Completed"),
                            ),
                            padding: EdgeInsets.only(left: 20, right: 20),
                          ),
                          PopupMenuItem(
                            enabled: true,
                            padding: EdgeInsets.only(),
                            child: buildDivider(),
                            height: 1,
                          ),
                          PopupMenuItem(
                            onTap: () {
                              startFilter("filter[paid]=false");
                            },
                            child: Center(
                              child: buildPopupMenuItemCard("Pending"),
                            ),
                          ),
                        ],
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
                          child: GroupedListView<Referral, String>(
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
                              return ReferralTile(param: el);
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

  Widget buildStatsWidget({
    required String title,
    required String titleValue,
    required String desc,
    required String descValue,
    required Color color,
    TextStyle? titleStyle,
    TextStyle? valueStyle,
  }) {
    return Container(
      width: 210,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9.73196), color: color),
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title,
              style: titleStyle ??
                  get12TextStyle().copyWith(
                    color: ColorManager.kSecBlue,
                    fontWeight: FontWeight.w400,
                  )),
          const SizedBox(height: 5),
          Text(
            titleValue,
            style: valueStyle ??
                get20TextStyle().copyWith(
                  fontWeight: FontWeight.w500,
                  color: ColorManager.kSecBlue,
                ),
          ),

          // ///
          const SizedBox(height: 12),
          Text(
            desc,
            style: titleStyle ??
                get12TextStyle().copyWith(
                  color: ColorManager.kSecBlue,
                  fontWeight: FontWeight.w400,
                ),
          ),
          const SizedBox(height: 5),
          Text(
            "$descValue NGN",
            overflow: TextOverflow.visible,
            maxLines: 3,
            style: valueStyle ??
                get20TextStyle().copyWith(
                  fontWeight: FontWeight.w500,
                  color: ColorManager.kSecBlue,
                ),
          )

          //
        ],
      ),
    );
  }

  String formatTopbarValues(num val) {
    try {
      return formatNumber(val, decimalDigits: 0);
    } catch (e) {
      return "0";
    }
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

  List<Referral> getElements() {
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
    String query = "?include=referred&per_page=100";
    String page = "page=$all_txn_page";
    String others = "";
    if (filterQueryParam != null) {
      others = "$filterQueryParam";
      page = "page=$filter_txn_page";
    } else if (searchController.text.isNotEmpty) {
      others = "filter[name]=${searchController.text}";
      page = "page=$search_txn_page";
    }

    if (others.isEmpty) {
      query = "$query&$page&$others";
    } else {
      query = "$query&$page&$others";
    }

    await ReferralHelper.getReferrals(query).then((value) {
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

  Widget buildPopupMenuItemCard(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: getStatusColor(status == "Completed" ? "approved" : "pending"),
      ),
      child: Text(
        status,
        style: get12TextStyle(
          color: getStatusTextColor(
              status == "Completed" ? "approved" : "pending"),
        ),
      ),
    );
  }
}
