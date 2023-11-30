import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/ellipse.dart';

class TransactionTile extends StatelessWidget {
  final String imageUrl;
  final String symbol;
  final String txnType;
  final String txnStatus;
  final String amountusd;
  final String amountngn;
  final num units;

  const TransactionTile({
    super.key,
    required this.imageUrl,
    required this.symbol,
    required this.txnType,
    required this.txnStatus,
    required this.amountusd,
    required this.amountngn,
    required this.units,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
            child: Row(
              children: [
                Image.asset(imageUrl, width: 48, height: 48),
                SizedBox(width: isSmallScreen(context) ? 8 : 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      symbol,
                      style: get16TextStyle().copyWith(
                        color: ColorManager.kGray1,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          txnType,
                          style: get16TextStyle().copyWith(
                            color: ColorManager.kGray1,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: ColorManager.kErrorBg,
                          ),
                          child: Text(
                            txnStatus,
                            style: get12TextStyle(color: ColorManager.kError),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),

          //

          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("₦$amountngn",
                    style: get16TextStyle(color: ColorManager.kSecBlue)),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        "$units Units",
                        overflow: TextOverflow.ellipsis,
                        style: get14TextStyle().copyWith(
                            color: ColorManager.kGreyscale500, fontSize: 10),
                      ),
                    ),
                    buildEllipse(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    Text(
                      "\$$amountusd",
                      style: get14TextStyle().copyWith(
                        color: ColorManager.kGreyscale500,
                        fontSize: 10,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
