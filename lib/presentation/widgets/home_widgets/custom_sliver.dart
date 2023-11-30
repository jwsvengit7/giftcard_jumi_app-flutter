import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/core/enum.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/route_arg/giftcard_arg.dart';
import 'package:jimmy_exchange/presentation/resources/routes_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_snackbar.dart';
import 'package:jimmy_exchange/presentation/widgets/home_widgets/banner.dart';
import 'package:jimmy_exchange/presentation/widgets/home_widgets/quick_actions_card_uncollapsed.dart';
import 'package:jimmy_exchange/presentation/widgets/home_widgets/refer_your_friend.dart';
import 'package:jimmy_exchange/presentation/widgets/home_widgets/view_all_Transaction_history.dart';

import '../../../core/model/buy_and_sell_giftcard_view_model.dart';

class SliverScrollView extends StatefulWidget {
  @override
  _SliverScrollViewState createState() => _SliverScrollViewState();
}

class _SliverScrollViewState extends State<SliverScrollView> {
  ScrollController _scrollController = ScrollController();
  double maxScrollExtent = 0.0;
  bool isExpanded = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 130.0.h, // Set the expanded height
              collapsedHeight: 120.0.h, // Set the collapsed height
              floating: false,
              pinned: true,
              primary: false,
              forceMaterialTransparency: true,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  if (constraints.maxHeight <= 110) {
                    return CollapsedWidgets();
                  } else {
                    return FlexibleSpaceBar(
                      background: ExpandedWidgets(),
                    );
                  }
                },
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                ViewAllTransactionHistory(),
                SizedBox(height: 20.h),
                ReferYourFriend(),
                SizedBox(height: 30.h),
                Banners(),
                SizedBox(
                  height: 200.h,
                )
              ] // Replace with the number of items you want
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSliverScrollView extends StatelessWidget {
  const CustomSliverScrollView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class CollapsedWidgets extends StatelessWidget {
  const CollapsedWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorManager.kWhite,
      child: Row(
        children: [
          QuickActionCardUnCollapsed(
              imagePath: ImageManager.kMoney,
              text: "Buy Crypto",
              onTap: () {
                showCustomSnackBar(
                    context: context,
                    text:
                        "Crypto purchase unavailable. We're working on it.\n Thank you for your patience.",
                    type: NotificationType.neutral);
                // await Navigator.pushNamed(
                //     context, RoutesManager.buyCryptoRoute);
              }),
          _Spacer(),
          QuickActionCardUnCollapsed(
              imagePath: ImageManager.kMoney,
              text: "Sell Crypto",
              onTap: () async {
                await Navigator.pushNamed(
                    context, RoutesManager.sellCryptoView);
                // showCustomSnackBar(
                //     context: context,
                //     text:
                //         "Crypto purchase unavailable. We're working on it.\n Thank you for your patience.",
                //     type: NotificationType.neutral);
              }),
          _Spacer(),
          QuickActionCardUnCollapsed(
              imagePath: ImageManager.kGiftcard,
              text: "Buy Giftcard",
              onTap: () {
                // Navigator.pushNamed(context, RoutesManager.buyGiftcardRoute);
                showCustomSnackBar(
                    context: context,
                    text:
                        "Gift card purchase unavailable. We're working on it.\n Thank you for your patience.",
                    type: NotificationType.neutral);
              }),
          _Spacer(),
          QuickActionCardUnCollapsed(
              imagePath: ImageManager.kGiftcard,
              text: "Sell Giftcard",
              onTap: () {
                // Navigator.pushNamed(context, RoutesManager.buyGiftcardRoute);
                showCustomSnackBar(
                    context: context,
                    text:
                        "Gift card purchase unavailable. We're working on it.\n Thank you for your patience.",
                    type: NotificationType.neutral);
              }),
        ],
      ),
    );
  }
}

class ExpandedWidgets extends StatelessWidget {
  const ExpandedWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorManager.kWhite,
      child: Column(
        children: [
          Row(
            children: [
              QuickActionCardCollapsed(
                imagePath: ImageManager.kMoney,
                title: "Buy Crypto",
                // text: "Lorem ipsum dolor sit amet consectetur.",
                onTap: () {
                  showCustomSnackBar(
                      context: context,
                      text:
                          "Crypto purchase unavailable. We're working on it.\n Thank you for your patience.",
                      type: NotificationType.neutral);
                  // await Navigator.pushNamed(
                  //     context, RoutesManager.buyCryptoRoute);
                },
              ),
              SizedBox(width: 10),
              QuickActionCardCollapsed(
                imagePath: ImageManager.kMoney,
                title: "Sell Crypto",
                // text: "Lorem ipsum dolor sit amet consectetur.",
                onTap: () async {
                  await Navigator.pushNamed(
                      context, RoutesManager.sellCryptoView);
                  // showCustomSnackBar(
                  //     context: context,
                  //     text:
                  //         "Crypto purchase unavailable. We're working on it.\n Thank you for your patience.",
                  //     type: NotificationType.neutral);
                },
              ),
              SizedBox(width: 10),
              QuickActionCardCollapsed(
                imagePath: ImageManager.kGiftcard,
                title: "Buy Giftcard",
                // text: "Lorem ipsum dolor sit amet consectetur.",
                onTap: () {
                  // Navigator.pushNamed(context, RoutesManager.buyGiftcardRoute);
                  List<SellGiftCard2Arg> arg = [];
                  Navigator.pushNamed(context, RoutesManager.sellGiftcard1Route,
                      arguments: BuyAndSaleGiftCardViewParams(
                          giftCardList: arg, isGiftCardSale: false));
                },
              ),
              SizedBox(width: 10),
              QuickActionCardCollapsed(
                imagePath: ImageManager.kGiftcard,
                title: "Sell Giftcard",
                // text: "Lorem ipsum dolor sit amet consectetur.",
                onTap: () {
                  List<SellGiftCard2Arg> arg = [];
                  Navigator.pushNamed(context, RoutesManager.sellGiftcard1Route,
                      arguments: BuyAndSaleGiftCardViewParams(
                          giftCardList: arg, isGiftCardSale: true));
                },
              ),
              SizedBox(width: 10),
            ],
          )
        ],
      ),
    );
  }
}

class _Spacer extends StatelessWidget {
  const _Spacer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 5);
  }
}
