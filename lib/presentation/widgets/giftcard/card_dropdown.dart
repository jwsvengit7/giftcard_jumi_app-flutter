import 'package:flutter/material.dart';

import '../../../core/utils/utils.dart';
import '../../resources/color_manager.dart';
import '../../resources/image_manager.dart';
import '../../resources/route_arg/giftcard_arg.dart';
import '../../resources/styles_manager.dart';

class CardDropDownWidgt extends StatefulWidget {
  final SellGiftCard2Arg arg;
  final Function onClear;
  CardDropDownWidgt({Key? key, required this.arg, required this.onClear})
      : super(key: key);

  @override
  _CardDropDownWidgtState createState() => _CardDropDownWidgtState();
}

class _CardDropDownWidgtState extends State<CardDropDownWidgt> {
  bool _showData = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: ColorManager.kFormBg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.0),
          // list card containing country name
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              setState(() => _showData = !_showData);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: loadNetworkImage(
                      widget.arg.giftCardCategory.icon ?? "",
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      (widget.arg.giftCardProduct.name ?? ""),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: get16TextStyle()
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                  ),
                ),

                Text(
                  formatCurrency(
                      widget.arg.oneUnitPayable * widget.arg.quantity),
                  style: get14TextStyle(),
                ),
                const SizedBox(width: 8),
                Image.asset(
                    !_showData
                        ? ImageManager.kArrowDown
                        : ImageManager.kArrowUp,
                    height: 8),

                //
              ],
            ),
          ),

          // this is the company card which is toggling based upon the bool
          _showData
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 5,
                          child: buildItemList(
                              "Product", widget.arg.giftCardProduct.name ?? ""),
                        ),
                        Flexible(
                          flex: 2,
                          child: buildItemList("Type",
                              capitalizeFirstString(widget.arg.card_type)),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.5,
                          color: ColorManager.kTxnTileBorderColor,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: buildItemList(
                              "Amount",
                              formatCurrency(widget.arg.oneUnitPayable *
                                  widget.arg.quantity)),
                        ),
                        Flexible(
                          child:
                              buildItemList("Units", "${widget.arg.quantity}"),
                        ),
                        Flexible(
                          child: buildItemList(
                            "Our Rate",
                            formatCurrency(
                              widget.arg.giftCardProduct.sell_rate,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.5,
                          color: ColorManager.kTxnTileBorderColor,
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => widget.onClear(widget.arg),
                      child: Image.asset(ImageManager.kDeleteGiftcardIcon,
                          height: 24),
                    )
                  ],
                )
              : const SizedBox()
        ],
      ),
    );
  }

  Widget buildItemList(String title, String subTitle,
      {TextStyle? subTitleTextStyle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: get14TextStyle().copyWith(
              color: ColorManager.kFormHintText, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 4),
        Text(
          subTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: subTitleTextStyle ??
              get16TextStyle().copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
