import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/core/constants.dart';
import 'package:jimmy_exchange/core/helpers/auth_helper.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/model/user.dart';
import '../../core/providers/user_provider.dart';
import '../../core/utils/utils.dart';
import '../resources/image_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/styles_manager.dart';
import '../widgets/dashboard_widgets.dart';
import '../widgets/popups/delete_account_popup.dart';
import '../widgets/popups/index.dart';
import '../widgets/settings/tab.dart';
import '../widgets/spacer.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    User user =
        Provider.of<UserProvider>(context).user ?? User(wallet_balance: 0);

    return Material(
      color: ColorManager.kGray11,
      child: ListView(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 140),
        children: [
          const DashboardTabTopSpacer(),
          const DashboardTitleBar(
            leadingWidget: SizedBox.shrink(),
            name: "Settings",
          ),
          SizedBox(
            height: 30,
          ),

          //

          navigatorTab(
              name: "Account Information",
              onTap: () {
                Navigator.pushNamed(context, RoutesManager.accountInfoRoute);
              }),

          navigatorTab(
              name: "Bank Information",
              onTap: () {
                Navigator.pushNamed(
                    context, RoutesManager.bankInformationRoute);
              }),
          navigatorTab(
              name: "Security",
              onTap: () {
                Navigator.pushNamed(context, RoutesManager.securityRoute);
              }),
          navigatorTab(
              name: "FAQ",
              onTap: () async {
                await launchUrl(Uri.parse(Constants.kFAQ)).catchError((_) {});
              }),
          navigatorTab(
              name: "Referrals",
              onTap: () async {
                Navigator.pushNamed(context, RoutesManager.referralsView);
              }),
          navigatorTab(
              name: "Support center",
              onTap: () {
                Navigator.pushNamed(context, RoutesManager.supportRoute);
              }),
          navigatorTab(
              name: "Terms and Conditions",
              onTap: () async {
                await launchUrl(Uri.parse(Constants.kTermsAndConditions))
                    .catchError((_) {});
              }),

          navigatorTab(
              name: "Privacy Policy",
              onTap: () async {
                await launchUrl(Uri.parse(Constants.kPrivacyPolicy))
                    .catchError((_) {});
              }),

          // //

          navigatorTab(
            name: "Log Out",
            onTap: () async => _showMyDialog(context),
          ),
          navigatorTab(
            name: "Delete Account",
            onTap: () {
              showDialogPopup(
                barrierColor: ColorManager.kBlack.withOpacity(0.60),
                context,
                DeleteAccountPopup(
                  isSuccess: false,
                  title: "Delete Account",
                  desc:
                      "Are you sure you want to delete your account? You won’t be able to create another account with this e-mail without contacting the admin",
                  proceedText: "Retry Transaction",
                  cancelText: "Return to Settings",
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  _confirmLogout(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.elliptical(8, 8),
          topRight: Radius.elliptical(8, 8),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      barrierColor: ColorManager.kBlack.withOpacity(.2),
      context: context,
      builder: (builder) {
        return Container(
          height: 279,
          color: ColorManager.kWhite,
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Log Out",
                    style:
                        get16TextStyle().copyWith(fontWeight: FontWeight.w500),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset(ImageManager.kCancel,
                        width: 24, height: 24),
                  )
                ],
              ),
              Text(
                "Are you sure you want to Log out of \nyour account",
                textAlign: TextAlign.center,
                style: get14TextStyle().copyWith(),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomBtn(
                      backgroundColor: ColorManager.kErrorBg,
                      textColor: ColorManager.kError,
                      width: 200,
                      // double.infinity,
                      onTap: () {
                        AuthHelper.logout(context,
                            deactivateTokenAndRestart: true);
                      },
                      text: "Yes, Log Out",
                      isActive: true,
                      loading: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Future<void> _showMyDialog(BuildContext context) async {
  return showDialog<void>(
    barrierColor: ColorManager.kBlack.withOpacity(0.60),
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
          backgroundColor: ColorManager.kWhite,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          titleTextStyle: get20TextStyle().copyWith(
              fontWeight: FontWeight.w700, color: ColorManager.kGray9),
          title:
              Align(alignment: Alignment.topLeft, child: const Text('Log Out')),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Builder(
              builder: (context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(16.r)),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Are you sure you want to log out of your account',
                          style: get14TextStyle().copyWith(
                              color: ColorManager.kTextColor,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 20.h),
                        GestureDetector(
                          onTap: () {
                            AuthHelper.logout(context,
                                deactivateTokenAndRestart: true);
                          },
                          child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: ColorManager.kAccountDeletion,
                                  borderRadius: BorderRadius.circular(8.r)),
                              height: 51.h,
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                'Log Out',
                                style: get14TextStyle()
                                    .copyWith(color: ColorManager.kWhite),
                              )),
                        ),
                        SizedBox(height: 10.h),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: ColorManager.kGray4,
                                  borderRadius: BorderRadius.circular(8.r)),
                              height: 51.h,
                              width: 355.w,
                              child: Text(
                                'Cancel',
                                style: get14TextStyle()
                                    .copyWith(color: ColorManager.kWhite),
                              )),
                        ),
                      ]),
                );
              },
            ),
          ));
    },
  );
}
