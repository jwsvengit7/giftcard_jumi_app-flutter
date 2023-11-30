import 'package:flutter/material.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/routes_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_scaffold.dart';

class PasswordResetStatusView extends StatelessWidget {
  const PasswordResetStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    bool failed = false;

    return WillPopScope(
      onWillPop: () async => false,
      child: CustomScaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //

              Image.asset(failed ? ImageManager.kCancel : ImageManager.kChecked,
                  height: 102, width: 102),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  failed ? "E-mail doesn’t exist " : "Success",
                  style: get32TextStyle().copyWith(
                    color: ColorManager.kSecBlue,
                  ),
                ),
              ),
              Text(
                failed
                    ? "The email you put in doesn’t exist in our system, create an account with the button below."
                    : "Your password reset is successful.",
                textAlign: TextAlign.center,
                style: get16TextStyle().copyWith(
                    color: ColorManager.kTextColor,
                    fontWeight: FontWeight.w400),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 60, bottom: 24),
                child: CustomBtn(
                    isActive: true,
                    loading: false,
                    text: failed ? "Sign Up" : "Continue",
                    onTap: () => popPage(context, failed)),
              ),

              failed
                  ? GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => popPage(context, failed),
                      child: Text(
                        "Use another email to Login",
                        textAlign: TextAlign.center,
                        style: get16TextStyle(color: ColorManager.kNavyBlue)
                            .copyWith(decoration: TextDecoration.underline),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  popPage(BuildContext context, bool failed) {
    Navigator.pushNamedAndRemoveUntil(
        context, RoutesManager.loginRoute, (Route<dynamic> route) => false);
    // int count = 0;
    // Navigator.popUntil(context, (route) {
    //   return count++ == 4;
    // });
    // if (failed) {
    //   Navigator.pushNamed(context, RoutesManager.signupRoute);
    // }
  }
}
