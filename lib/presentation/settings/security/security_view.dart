import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/routes_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_back_button.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_scaffold.dart';
import 'package:provider/provider.dart';

import '../../../core/helpers/auth_helper.dart';
import '../../../core/model/user.dart';
import '../../../core/providers/user_provider.dart';
import '../../resources/styles_manager.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/settings/tab.dart';

class SecurityView extends StatefulWidget {
  const SecurityView({super.key});

  @override
  State<SecurityView> createState() => _SecurityViewState();
}

class _SecurityViewState extends State<SecurityView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      userProvider.updateProfileInformation().catchError((_) {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    User user = userProvider.user ?? User(wallet_balance: 0);

    return CustomScaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
          leading: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CustomBackButton(),
          ),
          title: Text("Security",
              style:
                  get16TextStyle(fontWeight: FontWeight.w700, fontSize: 20))),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
              color: ColorManager.kGray11,
              borderRadius: BorderRadius.circular(8.r)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              navigatorTab(
                name: "Activate Login 2FA",
                rightWidget: SizedBox(
                  height: 32,
                  width: 32,
                  child: Transform.scale(
                    transformHitTests: false,
                    scale: .65,
                    child: CupertinoSwitch(
                      activeColor: ColorManager.kPrimaryBlue,
                      value: user.two_fa_activated_at != null,
                      onChanged: (value) async {
                        await AuthHelper.toggleTwoFAStatus();
                        userProvider.updateProfileInformation();
                      },
                    ),
                  ),
                ),
                onTap: () {},
              ),
// This is a new field and there's no API for the transaction pin.
              navigatorTab(
                name: "Transaction Pin",
                rightWidget: SizedBox(
                  height: 32,
                  width: 32,
                  child: Transform.scale(
                    transformHitTests: false,
                    scale: .65,
                    child: CupertinoSwitch(
                      activeColor: ColorManager.kPrimaryBlue,
                      value: user.transaction_pin != null,
                      onChanged: (value) async {
                        await AuthHelper.toggleTransactionPin();
                        userProvider.updateProfileInformation();
                      },
                    ),
                  ),
                ),
                onTap: () {},
              ),

              //
              navigatorTab(
                name: "Change Password",
                borderColor:
                    ColorManager.kSecurityDividerGrey.withOpacity(0.50),
                onTap: () {
                  Navigator.pushNamed(
                      context, RoutesManager.changePasswordRoute);
                },
              ),
              (user.transaction_pin_set == true)
                  ? navigatorTab(
                      borderColor:
                          ColorManager.kSecurityDividerGrey.withOpacity(0.50),
                      name: "Change Transaction PIN",
                      onTap: () {
                        Navigator.pushNamed(
                            context, RoutesManager.changeTransactionPinView);
                      },
                    )
                  : const SizedBox(),
              (user.transaction_pin_set == true)
                  ? navigatorTab(
                      borderColor:
                          ColorManager.kSecurityDividerGrey.withOpacity(0.50),
                      name: "Recover Transaction PIN",
                      onTap: () {
                        Navigator.pushNamed(
                            context, RoutesManager.recoverTransactionPinView);
                      },
                    )
                  : const SizedBox(),

              //
            ],
          ),
        ),
      ),
    );
  }
}
