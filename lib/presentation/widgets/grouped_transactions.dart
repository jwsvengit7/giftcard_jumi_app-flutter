import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:jimmy_exchange/presentation/resources/routes_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/tiles/all_transaction_tile.dart';

import '../../core/constants.dart';
import '../../core/model/all_txn_history.dart';
import '../../core/utils/utils.dart';
import '../resources/color_manager.dart';
import '../resources/styles_manager.dart';

class GroupTransactionHistory extends StatelessWidget {
  const GroupTransactionHistory(
      {required this.scrollController,
      required this.transactionHistoryList,
      super.key});
  final ScrollController scrollController;
  final List<AllTxnHistory> transactionHistoryList;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        color: ColorManager.kPrimaryBlack,
        onRefresh: () async {
          // DO NOTHING
        },
        child: Container(
          // color: ColorManager.kGray3.withOpacity(0.30),
          child: GroupedListView<AllTxnHistory, String>(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(),
            separator: Container(
                decoration: BoxDecoration(
                  color: ColorManager.kGray3.withOpacity(0.30),
                ),
                child: Divider()),
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            addSemanticIndexes: false,
            elements: transactionHistoryList,
            order: GroupedListOrder.ASC,
            controller: scrollController,
            sort: false,
            groupBy: (element) => getVerboseDateTimeRepresentationAlt(
                parseDate(element.created_at)),
            groupComparator: (value1, value2) => value2.compareTo(value1),
            groupSeparatorBuilder: (String value) => Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 0),
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0.h),
                child: Text(value,
                    style: get14TextStyle(color: ColorManager.kTextColor,fontWeight: FontWeight.w500)),
              ),
            ),
            itemBuilder: (c, el) {
              return AllTransactionTile(
                param: el,
                onTap: () {
                  if (el.type == Constants.kCryptoTxnTypeValue) {
                    Navigator.pushNamed(
                        context, RoutesManager.cryptoTxnHistoryDetails,
                        arguments: el.reference ?? "");
                  } else if (el.type == Constants.kGiftCardTransaction) {
                    Navigator.pushNamed(
                        context, RoutesManager.giftcardTxnHistoryDetailsView,
                        arguments: el.reference ?? "");
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
