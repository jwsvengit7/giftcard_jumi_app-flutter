import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';

import '../../../core/constants.dart';
import '../../../core/model/crypto_txn_history.dart';
import '../../resources/image_manager.dart';

class CryptoTransactionTile extends StatelessWidget {
  final CryptoTxnHistory param;
  final Function onTap;

  const CryptoTransactionTile(
      {super.key, required this.param, required this.onTap});

  @override
  Widget build(BuildContext context) {
    num _payable = param.payable_amount ?? 0;
    num _previous_payable = calPreviousPartialAmountForCryptoTxn(param) ?? 0;

    if (param.review_amount != null) {
      _payable = param.review_amount ?? 0;
      _previous_payable = param.payable_amount ?? 0;
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.only(top: 5, bottom: 9),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.5,
              color: ColorManager.kTxnTileBorderColor,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 3,
              child: Row(
                children: [
                  SizedBox(
                    width: 45,
                    height: 45,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: loadNetworkImage(param.asset?.icon ?? "",
                          errorDefaultImage: ImageManager.kBtc),
                    ),
                  ),
                  SizedBox(width: isSmallScreen(context) ? 8 : 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (param.asset?.code ?? "--").toUpperCase(),
                          style: get16TextStyle().copyWith(
                            color: ColorManager.kGray1,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              capitalizeFirstString(
                                  param.trade_type?.toLowerCase()),
                              style: get16TextStyle().copyWith(
                                color: param.trade_type?.toLowerCase() == "buy"
                                    ? ColorManager.kSuccess
                                    : ColorManager.kError,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 6),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: getStatusColor(param.status ?? "")),
                              child: Text(
                                param.status?.toLowerCase() ==
                                        Constants.kPartiallyApprovedStatus
                                    ? "Partial"
                                    : capitalizeFirstString(
                                        param.status?.toLowerCase()),
                                style: get12TextStyle(
                                  color: getStatusTextColor(param.status ?? ""),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            //
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  param.status?.toLowerCase() ==
                          Constants.kPartiallyApprovedStatus
                      ? Text(
                          formatCurrency(_previous_payable),
                          style: get12TextStyle().copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: ColorManager.kError,
                          ),
                        )
                      : const SizedBox(),
                  Text(formatCurrency(_payable),
                      style: get16TextStyle(color: ColorManager.kSecBlue)),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          "${formatNumberAlt(param.asset_amount)} Unit(s)",
                          overflow: TextOverflow.ellipsis,
                          style: get14TextStyle().copyWith(
                              color: ColorManager.kGreyscale500, fontSize: 10),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
