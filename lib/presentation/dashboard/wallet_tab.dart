import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:jimmy_exchange/core/model/user.dart';
import 'package:jimmy_exchange/core/providers/user_provider.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/values_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/popups/index.dart';
import 'package:jimmy_exchange/presentation/widgets/transaction_details_components.dart';
import 'package:provider/provider.dart';

import '../../core/enum.dart';
import '../../core/model/wallet_txn_history.dart';
import '../../core/providers/txn_history_provider.dart';
import '../../core/utils/utils.dart';
import '../resources/routes_manager.dart';
import '../resources/styles_manager.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/dashboard_widgets.dart';
import '../widgets/no_content.dart';
import '../widgets/shimmers/square_shimmer.dart';
import '../widgets/spacer.dart';
import '../widgets/tiles/wallet_transaction_tile.dart';

class WalletTab extends StatefulWidget {
  const WalletTab({super.key});

  @override
  State<WalletTab> createState() => _WalletTabState();
}

class _WalletTabState extends State<WalletTab> {
  bool fetching = false;

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

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    userProvider.updateProfileInformation();
    if (txnHistoryProvider.walletTxnHistory.isEmpty) {
      setState(() => fetching = true);
    }
    await txnHistoryProvider.updateWalletTxnHistory();
    setState(() => fetching = false);
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    User user = userProvider.user ?? User(wallet_balance: 0);
    TxnHistoryProvider txnHistoryProvider =
        Provider.of<TxnHistoryProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
      child: Column(
        children: [
          //
          const DashboardTabTopSpacer(),

          const DashboardTitleBar(name: "Wallet"),
          WalletSubTitle(
            user: user,
            contextt: context,
          ),

          // RECENT TRANSACTION
          Padding(
            padding: EdgeInsets.only(top: 50.0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Transactions",
                  style: get16TextStyle().copyWith(
                    fontWeight: FontWeight.w500,
                    color: ColorManager.kBlack,
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (txnHistoryProvider.walletTxnHistory.isEmpty) {
                      showCustomSnackBar(
                          context: context,
                          text: "You do not have a transaction history yet.",
                          type: NotificationType.error);
                      return;
                    }

                    Navigator.pushNamed(
                        context, RoutesManager.walletTxnHistoryView);
                  },
                  child: Image.asset(ImageManager.kViewAllTransaction),
                )
              ],
            ),
          ),
          const SizedBox(height: 12),
          //

          fetching
              ? buildLoading()
              : Expanded(
                  child: RefreshIndicator(
                    color: ColorManager.kPrimaryBlack,
                    onRefresh: updateTxnHistory,
                    child: txnHistoryProvider.walletTxnHistory.isEmpty
                        ? ListView(
                            children: const [NoContent(displayImage: true)],
                          )
                        : GroupedListView<WalletTxnHistory, String>(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 85),
                            elements: txnHistoryProvider.walletTxnHistory,
                            groupBy: (element) =>
                                getVerboseDateTimeRepresentationAlt(
                                    parseDate(element.createdAt.toString())),
                            sort: false,
                            groupComparator: (value1, value2) =>
                                value2.compareTo(value1),
                            order: GroupedListOrder.ASC,
                            controller: scrollController,
                            groupSeparatorBuilder: (String value) => Padding(
                              padding: const EdgeInsets.only(top: 0, bottom: 0),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0.h),
                                child: Text(value,
                                    style: get14TextStyle()
                                        .copyWith(fontWeight: FontWeight.w500)),
                              ),
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
                            // separator: const SizedBox(height: 20),
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

class WalletSubTitle extends StatelessWidget {
  const WalletSubTitle({super.key, required this.user, required this.contextt});

  final User user;
  final BuildContext contextt;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 22),
      padding: const EdgeInsets.all(14),
      height: 151,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: ColorManager.kPrimaryBlue.withOpacity(0.12),
      ),
      child: Column(
        children: [
          SizedBox(
            // padding: const EdgeInsets.only(bottom: 14),
            height: 76.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image(
                            image: AssetImage(ImageManager.kWalletBalanceIcon)),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            formatCurrency(user.wallet_balance),
                            style: get20TextStyle().copyWith(
                                fontWeight: FontWeight.w700,
                                color: ColorManager.kPrimaryBlue),
                          ),
                        )
                      ]),
                ),
                Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              color: ColorManager.kNavyBlue2, width: 1),
                          left: BorderSide(
                              color: ColorManager.kNavyBlue2, width: 1))),
                  width: 6.w,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 7.0),
                        child: Column(
                          children: [
                            Image(image: AssetImage(ImageManager.kFundWallet)),
                            Text(
                              'Fund',
                              style: get14TextStyle().copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: ColorManager.kPrimaryBlue,
                                  height: 2.h),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 7.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (user.wallet_balance <= 0) {
                                  showCustomSnackBar(
                                      context: context,
                                      text: "You cannot withdraw zero amount",
                                      type: NotificationType.error);

                                  return;
                                }

                                await Navigator.pushNamed(
                                    context, RoutesManager.withdrawFundRoute);
                                await updateTxnHistory(context);
                              },
                              behavior: HitTestBehavior.translucent,
                              child: Image(
                                  image: AssetImage(
                                      ImageManager.kWithdrawFromWallet)),
                            ),
                            Text(
                              'Withdraw',
                              style: get14TextStyle().copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: ColorManager.kPrimaryBlue,
                                  height: 2.h),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5.h),
            child: Container(
              color: ColorManager.kNavyBlue2,
              height: 1,
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialogPopup(
                barrierColor: ColorManager.kPrimaryBlack.withOpacity(0.40),
                barrierDismissible: true,
                contextt,
                UserCountInformation(),
              );
            },
            child: Image(image: AssetImage(ImageManager.kUserAccountDetails)),
          ),
        ],
      ),
    );
  }
}

class UserCountInformation extends StatelessWidget {
  const UserCountInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          height: 182,
          margin: EdgeInsets.fromLTRB(16.w, 76.h, 16.h, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(width: 0.5, color: ColorManager.kNavyBlue2),
            color: ColorManager.kUpdateBackground,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text('Account Details',
                    style: get18TextStyle().copyWith(
                        fontWeight: FontWeight.w700,
                        color: ColorManager.kPrimaryBlue)),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: Container(
                  color: ColorManager.kNavyBlue2,
                  height: 1,
                ),
              ),
              SellersBankInfoCapsule(
                  fontWeight: FontWeight.w700,
                  dividerPadding: 7,
                  fontSize: 14,
                  separatorColor: ColorManager.kPrimaryBlue,
                  fontColor: ColorManager.kPrimaryBlue,
                  border:
                      Border.all(width: 1.w, color: ColorManager.kNavyBlue2),
                  color: ColorManager.kUpdateBackground,
                  height: 36.h,
                  sellersBankName: 'Opay (Paycom)',
                  sellerAccountNumber: 'Doe - JimmyXchange'),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '90345919111',
                      style: get18TextStyle().copyWith(
                          color: ColorManager.kPrimaryBlue,
                          fontWeight: FontWeight.w500),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 8.w,
                      ),
                      child: Image.asset(ImageManager.kAccountDetailsIcon),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Expanded(
            child: SizedBox(
          height: 20,
        ))
      ],
    );
    //   AlertDialog(
    //   backgroundColor: ColorManager.kWhite,
    //   insetPadding: const EdgeInsets.symmetric(horizontal: 20),
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(16.r),
    //   ),
    //   clipBehavior: Clip.antiAliasWithSaveLayer,
    //   titleTextStyle: get20TextStyle()
    //       .copyWith(fontWeight: FontWeight.w700, color: ColorManager.kGray9),
    //   content: Container(
    //     // margin: EdgeInsets.only(top: 71, left: 16.w, right: 16.w),
    //     color: Colors.white,
    //     height: 182.h,
    //     child: Column(),
    //   ),
    // );
  }
}

// Future<void> _showMyDialog(BuildContext context) async {
//   return showDialog<void>(
//     barrierColor: ColorManager.kBlack.withOpacity(0.60),
//     context: context,
//     barrierDismissible: true, // user must tap button!
//     builder: (BuildContext context) {
//       return AlertDialog(
//           backgroundColor: ColorManager.kWhite,
//           insetPadding: const EdgeInsets.symmetric(horizontal: 20),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16.r),
//           ),
//           clipBehavior: Clip.antiAliasWithSaveLayer,
//           titleTextStyle: get20TextStyle().copyWith(
//               fontWeight: FontWeight.w700, color: ColorManager.kGray9),
//           title:
//           Align(alignment: Alignment.topLeft, child: const Text('Log Out')),
//           content: SizedBox(
//             width: MediaQuery.of(context).size.width,
//             child: Builder(
//               builder: (context) {
//                 return Container(
//                   width: MediaQuery.of(context).size.width,
//                   decoration:
//                   BoxDecoration(borderRadius: BorderRadius.circular(16.r)),
//                   child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Are you sure you want to log out of your account',
//                           style: get14TextStyle().copyWith(
//                               color: ColorManager.kTextColor,
//                               fontWeight: FontWeight.w400),
//                         ),
//                         SizedBox(height: 20.h),
//                         GestureDetector(
//                           onTap: () {
//                             AuthHelper.logout(context,
//                                 deactivateTokenAndRestart: true);
//                           },
//                           child: Container(
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                   color: ColorManager.kAccountDeletion,
//                                   borderRadius: BorderRadius.circular(8.r)),
//                               height: 51.h,
//                               width: MediaQuery.of(context).size.width,
//                               child: Text(
//                                 'Log Out',
//                                 style: get14TextStyle()
//                                     .copyWith(color: ColorManager.kWhite),
//                               )),
//                         ),
//                         SizedBox(height: 10.h),
//                         GestureDetector(
//                           onTap: () => Navigator.pop(context),
//                           child: Container(
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                   color: ColorManager.kGray4,
//                                   borderRadius: BorderRadius.circular(8.r)),
//                               height: 51.h,
//                               width: 355.w,
//                               child: Text(
//                                 'Cancel',
//                                 style: get14TextStyle()
//                                     .copyWith(color: ColorManager.kWhite),
//                               )),
//                         ),
//                       ]),
//                 );
//               },
//             ),
//           ));
//     },
//   );
// }
