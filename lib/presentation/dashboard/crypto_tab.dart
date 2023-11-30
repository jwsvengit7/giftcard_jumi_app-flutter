import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:jimmy_exchange/core/model/crypto_txn_history.dart';
import 'package:jimmy_exchange/core/providers/txn_history_provider.dart';
import 'package:jimmy_exchange/presentation/widgets/no_content.dart';
import 'package:provider/provider.dart';

import '../../core/enum.dart';
import '../../core/utils/utils.dart';
import '../resources/color_manager.dart';
import '../resources/image_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/styles_manager.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/dashboard_widgets.dart';
import '../widgets/shimmers/square_shimmer.dart';
import '../widgets/spacer.dart';
import '../widgets/tiles/crypto_transaction_tile.dart';

class CryptoTab extends StatefulWidget {
  const CryptoTab({super.key});

  @override
  State<CryptoTab> createState() => _CryptoTabState();
}

class _CryptoTabState extends State<CryptoTab> {
  bool fetching = false;
  TextEditingController searchController = TextEditingController();

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
    if (txnHistoryProvider.cryptoTxnHistory.isEmpty) {
      setState(() => fetching = true);
    }
    await txnHistoryProvider.updateCryptoTxnHistory();
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
          const DashboardTitleBar(name: "All Crypto Transactions"),
          SizedBox(
            height: 30,
          ),
          buildInputField(
            hintText: 'Search Transactions',
            controller: searchController,
            obscureText: true,
          ),
          fetching
              ? buildLoading()
              : Expanded(
                  child: RefreshIndicator(
                    color: ColorManager.kPrimaryBlack,
                    onRefresh: updateTxnHistory,
                    child: txnHistoryProvider.cryptoTxnHistory.isEmpty
                        ? ListView(
                            children: const [NoContent(displayImage: true)],
                          )
                        : GroupedListView<CryptoTxnHistory, String>(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 85),
                            elements: txnHistoryProvider.cryptoTxnHistory,
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
                                onTap: () => Navigator.pushNamed(context,
                                    RoutesManager.cryptoTxnHistoryDetails,
                                    arguments: el.reference ?? ""),
                              );
                            },
                            separator: const SizedBox(height: 20),
                            addAutomaticKeepAlives: false,
                            addRepaintBoundaries: false,
                            addSemanticIndexes: false,
                          ),
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
}

Widget buildInputField({
  required String hintText,
  bool obscureText = false,
  required TextEditingController controller,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: TextFormField(
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    ),
  );
}
