import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/routes_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_appbar.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_scaffold.dart';
import 'package:jimmy_exchange/presentation/widgets/popups/index.dart';
import 'package:jimmy_exchange/presentation/widgets/shimmers/square_shimmer.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/user_provider.dart';

import '../../core/enum.dart';
import '../../core/model/referral.dart';
import '../../core/model/user.dart';
import '../../core/providers/referral_provider.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/no_content.dart';
import '../widgets/tiles/referral_tile.dart';

class ReferralsView extends StatefulWidget {
  const ReferralsView({super.key});

  @override
  State<ReferralsView> createState() => _BankInformationViewState();
}

class _BankInformationViewState extends State<ReferralsView> {
  bool loading = true;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await updateReferralDetails();
    });

    super.initState();
  }

  bool fetching = true;

  Future<void> updateReferralDetails() async {
    ReferralProvider referralsProvider =
        Provider.of<ReferralProvider>(context, listen: false);

    setState(() => fetching = true);
    await referralsProvider.updateReferrals();
    setState(() => fetching = false);
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    User user =
        Provider.of<UserProvider>(context).user ?? User(wallet_balance: 0);
    ReferralProvider referralsProvider = Provider.of<ReferralProvider>(context);

    return CustomScaffold(
      appBar: CustomAppBar(
        actions: [
          GestureDetector(
            onTap: () async {
              await showDialogPopup(
                  context, referralModalWidget(user.ref_code ?? ""),
                  barrierDismissible: true);
            },
            child: Image.asset(ImageManager.kExclamation, width: 24),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(left: 20, right: 20),
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      Text(user.ref_code ?? "", style: get18TextStyle()),
                      const SizedBox(width: 52),
                      GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            await copyToClipboard(context, user.ref_code ?? "");
                          },
                          child: Image.asset(ImageManager.kCopy, width: 24))
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                  decoration: BoxDecoration(
                    color: ColorManager.kSettingsItemBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Rewards Earned", style: get14TextStyle()),
                      Text("₦" + formatNumber(referralsProvider.total_reward),
                          overflow: TextOverflow.ellipsis,
                          style: get28TextStyle()),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: buildTopCard(
                            title: "Friends who signed up",
                            subtitle: formatNumber(
                                referralsProvider.total_referrals,
                                decimalDigits: 0)),
                      ),
                      const SizedBox(width: 23),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: buildTopCard(
                          title: "Friends who traded",
                          subtitle: formatNumber(referralsProvider.total_trade,
                              decimalDigits: 0),
                        ),
                      ),
                    ],
                  ),
                ),

                //
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Referrals List",
                      style: get16TextStyle()
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (referralsProvider.referrals.isEmpty) {
                          showCustomSnackBar(
                              context: context,
                              text: "You do not have a referral record(s) yet.",
                              type: NotificationType.error);
                          return;
                        }
                        Navigator.pushNamed(
                            context, RoutesManager.referralHistoryView);
                      },
                      child: Text(
                        "View all",
                        style: get16TextStyle().copyWith(
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                ),

                //
                SizedBox(
                  height: 500,
                  child: RefreshIndicator(
                    color: ColorManager.kPrimaryBlack,
                    onRefresh: updateReferralDetails,
                    child: fetching
                        ? buildLoading()
                        : referralsProvider.referrals.isEmpty
                            ? ListView(
                                children: const [NoContent(displayImage: true)])
                            : buildReferralSection(referralsProvider.referrals),
                  ),
                )

                //
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTopCard({required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: ColorManager.kReferralBoxBg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: get14TextStyle()),
          const SizedBox(height: 4),
          Text(subtitle, style: get24TextStyle()),
        ],
      ),
    );
  }

  Widget referralModalWidget(String code) {
    return AlertDialog(
      backgroundColor: ColorManager.kWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(vertical: 35, horizontal: 16),
      content: SizedBox(
        height: 340,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(ImageManager.kReferralBox, width: 177),

            //
            Center(
              child: Container(
                width: 240,
                margin: const EdgeInsets.symmetric(vertical: 30),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorManager.kYellow,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(code,
                          overflow: TextOverflow.ellipsis,
                          style: get18TextStyle()),
                    ),

                    //
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      child: Image.asset(ImageManager.kCopy, width: 24),
                      onTap: () async {
                        await copyToClipboard(context, code,
                            successMsg: "Code copied to clipboard");

                        Navigator.pop(context);
                      },
                    )

                    //
                  ],
                ),
              ),
            ),

            //
            Text(
              "Invite a friend and earn up to 1000 Naira on their first transaction worth up to 100,000 Naira.",
              textAlign: TextAlign.center,
              style: get16TextStyle().copyWith(
                  fontWeight: FontWeight.w400, color: ColorManager.kTextColor),
            )
          ],
          //
        ),
      ),
    );
  }

  Widget buildLoading() => ListView.separated(
        separatorBuilder: ((context, index) => const SizedBox(height: 20)),
        itemCount: 4,
        itemBuilder: (_, int i) =>
            const SquareShimmer(width: double.infinity, height: 50),
      );

  Widget buildReferralSection(List<Referral> elements) {
    return GroupedListView<Referral, String>(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 85),
      elements: elements,
      groupBy: (element) =>
          getVerboseDateTimeRepresentationAlt(parseDate(element.created_at)),
      sort: false,
      groupComparator: (value1, value2) => value2.compareTo(value1),
      order: GroupedListOrder.ASC,
      controller: scrollController,
      groupSeparatorBuilder: (String value) => Padding(
        padding: const EdgeInsets.only(top: 28, bottom: 16),
        child:
            Text(value, style: get14TextStyle(color: ColorManager.kTextColor)),
      ),
      itemBuilder: (c, el) {
        return ReferralTile(param: el);
      },
      separator: const SizedBox(height: 20),
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      addSemanticIndexes: false,
    );
  }
}
