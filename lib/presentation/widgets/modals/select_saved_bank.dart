import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/core/model/saved_bank.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/route_arg/giftcard_arg.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/settings/bank/bank_information_view.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_back_button.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_bottom_sheet.dart';
import 'package:jimmy_exchange/presentation/widgets/modals/enter_transaction_pin.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/user_provider.dart';
import '../../resources/routes_manager.dart';
import '../custom_indicator.dart';
import '../saved_bank.dart';
import '../shimmers/square_shimmer.dart';

class SelectSavedBank extends StatefulWidget {
  const SelectSavedBank({Key? key, this.arg}) : super(key: key);
  final List<SellGiftCard2Arg>? arg;

  @override
  State<SelectSavedBank> createState() => _SelectSavedBankState();
}

class _SelectSavedBankState extends State<SelectSavedBank> {
  bool fetchingBanks = false;

  SavedBank? selectedBank;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        // selectedBank = widget.current;
      });
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      if (userProvider.savedBanks.isEmpty) {
        if (mounted) setState(() => fetchingBanks = true);
        await userProvider.updateAddedBanks().then((_) {}).catchError((_) {});
        if (mounted) setState(() => fetchingBanks = false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Material(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: Colors.white,
        // height: AppSize.get650ModalHeight(context),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 40.h, bottom: 20.h),
              child: Row(
                children: [
                  CustomBackButton(),
                  SizedBox(
                    width: 80.w,
                  ),
                  Text('Select Payout Account',
                      style: get16TextStyle().copyWith(
                          fontWeight: FontWeight.w700, fontSize: 20.sp))
                ],
              ),
            ),
            Expanded(
              child: fetchingBanks
                  ? ListView.separated(
                      padding: const EdgeInsets.only(top: 27),
                      separatorBuilder: ((context, index) =>
                          const SizedBox(height: 20)),
                      itemCount: 3,
                      itemBuilder: (_, int i) => const SquareShimmer(
                          width: double.infinity, height: 50),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(top: 27),
                      addAutomaticKeepAlives: false,
                      shrinkWrap: true,
                      itemCount: userProvider.savedBanks.length + 1,
                      itemBuilder: (_, int index) {
                        if (index < userProvider.savedBanks.length) {
                          SavedBank current = userProvider.savedBanks[index];
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 20.h),
                            decoration: BoxDecoration(
                                color: ColorManager.kGray11,
                                borderRadius: (index != 0 &&
                                        index !=
                                            userProvider.savedBanks.length - 1)
                                    ? null
                                    : index == 0
                                        ? BorderRadius.only(
                                            topRight: Radius.circular(8.r),
                                            topLeft: Radius.circular(8.r))
                                        : BorderRadius.only(
                                            bottomLeft: Radius.circular(8.r),
                                            bottomRight: Radius.circular(8.r)),
                                border: (index != 0 &&
                                        index !=
                                            userProvider.savedBanks.length - 1)
                                    ? Border(
                                        left: BorderSide(
                                            color: ColorManager.kBorder),
                                        right: BorderSide(
                                            color: ColorManager.kBorder),
                                        top: BorderSide(
                                            width: 0,
                                            color: ColorManager.kBorder),
                                        bottom: BorderSide(
                                            width: 0,
                                            color: ColorManager.kBorder))
                                    : index == 0
                                        ? Border(
                                            left: BorderSide(
                                                color: ColorManager.kBorder),
                                            right: BorderSide(
                                                color: ColorManager.kBorder),
                                            top: BorderSide(
                                                color: ColorManager.kBorder),
                                            bottom: BorderSide(
                                                width: 0,
                                                color: ColorManager.kBorder))
                                        : Border(
                                            left: BorderSide(
                                                color: ColorManager.kBorder),
                                            right:
                                                BorderSide(color: ColorManager.kBorder),
                                            top: BorderSide(width: 0, color: ColorManager.kBorder),
                                            bottom: BorderSide(color: ColorManager.kBorder))),
                            child: buildBankTile(current, () {
                              setState(() => selectedBank = current);
                              // Navigator.pop(context, selectedBank);
                              widget.arg!.first.selectedBank = selectedBank;
                              widget.arg!.first.fundsWithdrawal!.savedBank =
                                  selectedBank;
                              if (widget
                                  .arg!.first.fundsWithdrawal!.isWallet!) {
                                Navigator.pushNamed(context,
                                    RoutesManager.confirmYourWithdrawalDetail,
                                    arguments:
                                        widget.arg!.first.fundsWithdrawal!);
                              } else {
                                Navigator.pushNamed(
                                    context, RoutesManager.confirmCardSale,
                                    arguments: widget.arg);
                              }
                            },
                                pointer: buildCircularIndicator(
                                    selectedBank == current)),
                          );
                        }

                        return Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: AddBankBuilder(
                            onTap: () async {
                              await Navigator.pushNamed(
                                  context, RoutesManager.addBankRoute);
                              setState(() {});
                            },
                          ),
                        );
                      },
                      separatorBuilder: (context, int index) {
                        return (index < userProvider.savedBanks.length - 1)
                            ? const Divider(
                                height: 0,
                              )
                            : SizedBox.shrink();
                      }),
            ),
          ],
        ),
      ),
    );
  }

}
