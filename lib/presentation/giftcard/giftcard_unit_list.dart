import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/widgets/shimmers/square_shimmer.dart';
import '../../core/helpers/transaction_helper.dart';
import '../../core/model/giftcard_txn_history.dart';
import '../resources/color_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/styles_manager.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/tiles/giftcard_transaction_tile.dart';

class GiftcardUnitListView extends StatefulWidget {
  final GiftcardTxnHistory param;
  const GiftcardUnitListView({super.key, required this.param});

  @override
  State<GiftcardUnitListView> createState() => _GiftcardUnitListViewState();
}

class _GiftcardUnitListViewState extends State<GiftcardUnitListView> {
  ScrollController scrollController = ScrollController();

  bool loading = true;

  List<GiftcardTxnHistory> txnHistoryList = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TransactionHelper.getGiftcardTxnHistoryDetails(
              "/${widget.param.reference}?include=bank,giftcardProduct")
          .then((value) {
        txnHistoryList.add(value);
        txnHistoryList.addAll(value.related_giftcards);
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
    return CustomScaffold(
      backgroundColor: ColorManager.kWhite,
      appBar: CustomAppBar(
        title: Text("Transaction Unit List", style: get20TextStyle()),
      ),
      body: loading
          ? Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 33),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildItemShimmer(),
                  buildItemShimmer(),
                  buildItemShimmer(),
                  buildItemShimmer(),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: isSmallScreen(context) ? 17 : 20,
                    ),
                    itemCount: txnHistoryList.length,
                    itemBuilder: (c, idx) {
                      return GiftcardTransactionTile(
                        param: txnHistoryList[idx],
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RoutesManager.giftcardTxnHistoryDetailsView,
                            arguments: txnHistoryList[idx].reference ?? "",
                          );
                        },
                      );
                    },
                    separatorBuilder: (c, el) => const SizedBox(height: 20),
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: false,
                    addSemanticIndexes: false,
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildItemShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SquareShimmer(height: 54, width: double.infinity),
        const SizedBox(height: 30),
      ],
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
