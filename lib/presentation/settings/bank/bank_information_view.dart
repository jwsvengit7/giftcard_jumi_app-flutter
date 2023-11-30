import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/core/model/saved_bank.dart';
import 'package:jimmy_exchange/presentation/resources/routes_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_appbar.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_back_button.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_scaffold.dart';
import 'package:jimmy_exchange/presentation/widgets/shimmers/square_shimmer.dart';
import 'package:provider/provider.dart';

import '../../../core/enum.dart';
import '../../../core/providers/user_provider.dart';
import '../../resources/color_manager.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/saved_bank.dart';
import '../../widgets/spacer.dart';

class BankInformationView extends StatefulWidget {
  const BankInformationView({super.key});

  @override
  State<BankInformationView> createState() => _BankInformationViewState();
}

class _BankInformationViewState extends State<BankInformationView> {
  bool loading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);

      if (userProvider.savedBanks.isNotEmpty) {
        setState(() => loading = false);
      }
      await userProvider.updateAddedBanks().then((_) {
        setState(() => loading = false);
      }).catchError((_) {
        showCustomSnackBar(
          context: context,
          text: "An error occured, please retry again.",
          type: NotificationType.success,
        );
        setState(() => loading = false);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<SavedBank> dataList = Provider.of<UserProvider>(context).savedBanks;

    return CustomScaffold(
      appBar: CustomAppBar(
          leading: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CustomBackButton(),
          ),
          title: Text("Bank Information",
              style:
                  get16TextStyle(fontWeight: FontWeight.w700, fontSize: 20))),
      body: loading
          ? ListView(
              padding: const EdgeInsets.only(top: 27, left: 20, right: 20),
              children: const [
                SquareShimmer(height: 50, width: double.infinity),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: SquareShimmer(height: 50, width: double.infinity),
                ),
                SquareShimmer(height: 50, width: double.infinity),
                //
              ],
            )
          : Column(
              children: [
                const SettingsPageTopSpacer(),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    itemCount: dataList.length + 1,
                    itemBuilder: (_, int i) {
                      if (i < dataList.length) {
                        return Container(
                          color: ColorManager.kBorder.withOpacity(0.30),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 20),
                          child: buildBankTile(dataList[i], () {
                            Navigator.pushNamed(
                                context, RoutesManager.removeBankRoute,
                                arguments: dataList[i]);
                          }),
                        );
                      }
                      return AddBankBuilder(onTap: () {
                        setState(() {});
                      });
                    },
                    separatorBuilder: (_, i) => const SizedBox(height: 20),
                  ),
                ),
              ],
            ),
    );
  }
}

class AddBankBuilder extends StatelessWidget {
  const AddBankBuilder({super.key, required this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        height: 60.h,
        width: 179.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: ColorManager.kPrimaryBlue.withOpacity(0.15)),
            color: ColorManager.kPrimaryBlueAccent.withOpacity(0.12)),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            await Navigator.pushNamed(context, RoutesManager.addBankRoute);
            onTap;
          },
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              "+ Add Another Bank",
              style: get14TextStyle().copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: ColorManager.kPrimaryBlue),
            ),
          ),
        ),
      ),
    );
    ;
  }
}
