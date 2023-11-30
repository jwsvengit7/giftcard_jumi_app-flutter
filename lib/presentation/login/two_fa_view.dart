import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_scaffold.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../core/enum.dart';
import '../../core/helpers/auth_helper.dart';
import '../../core/providers/user_provider.dart';
import '../../core/utils/utils.dart';
import '../resources/color_manager.dart';
import '../resources/route_arg/two_fa_arg.dart';
import '../resources/routes_manager.dart';
import '../resources/styles_manager.dart';
import '../resources/values_manager.dart';
import '../widgets/custom_snackbar.dart';

class TwoFAView extends StatefulWidget {
  final TwoFaArg param;
  const TwoFAView({super.key, required this.param});

  @override
  State<TwoFAView> createState() => _TwoFAViewState();
}

class _TwoFAViewState extends State<TwoFAView> {
  final formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  String currentText = "";

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  bool requestOtpLoading = false;
  bool validatingCode = false;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: GestureDetector(
        onTap: () {},
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
            children: <Widget>[
              SizedBox(height: isSmallScreen(context) ? 70 : 110),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text("2FA Verification", style: get32TextStyle()),
              ),
              Text(
                  "Your account is protected by 2FA verification. Please input the code sent to ${obscureEmail(widget.param.user.email ?? "")} to verify your account.",
                  style: get16TextStyle().copyWith(
                      color: ColorManager.kTextColor,
                      fontWeight: FontWeight.w400)),
              const SizedBox(height: 60),
              Form(
                key: formKey,
                child: PinCodeTextField(
                  appContext: context,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  validator: (v) {},
                  pinTheme: PinTheme(
                    activeColor: ColorManager.kPrimaryBlue,
                    inactiveFillColor: ColorManager.kFormBg,
                    selectedColor: ColorManager.kPrimaryBlue,
                    activeFillColor: ColorManager.kFormBg,
                    selectedFillColor: ColorManager.kFormBg,
                    errorBorderColor: ColorManager.kError,
                    inactiveColor: ColorManager.kFormBorder,
                    shape: PinCodeFieldShape.box,
                    borderWidth: 0,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 50,
                    fieldWidth: 50,
                  ),
                  cursorColor: ColorManager.kFormHintText,
                  cursorWidth: 1.5,
                  cursorHeight: 20,
                  animationDuration: const Duration(milliseconds: 50),
                  enableActiveFill: true,
                  errorAnimationController: errorController,
                  controller: textEditingController,
                  keyboardType: TextInputType.number,
                  onCompleted: (_) {},
                  onChanged: (value) {
                    setState(() {
                      currentText = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    debugPrint("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 22,
                  child: requestOtpLoading
                      ? SizedBox(
                          height: 14,
                          width: 22,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  ColorManager.kPrimaryBlack),
                            ),
                          ),
                        )
                      : GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              "Resend OTP",
                              style:
                                  get14TextStyle(color: ColorManager.kGrayAlt)
                                      .copyWith(
                                          decoration: TextDecoration.underline),
                            ),
                          ),
                          onTap: () async {
                            setState(() {
                              requestOtpLoading = true;
                            });
                            //
                            //

                            await AuthHelper.resendTwoFaCode().then((msg) {
                              showCustomSnackBar(
                                context: context,
                                text: msg,
                                type: NotificationType.success,
                              );
                            }).catchError((e) {
                              showCustomSnackBar(
                                  context: context,
                                  text: e.toString(),
                                  type: NotificationType.error);
                            });
                            setState(() {
                              requestOtpLoading = false;
                            });
                            //
                          },
                        ),
                ),
              ),
              const SizedBox(height: 60),
              CustomBtn(
                  isActive: true,
                  loading: validatingCode,
                  text: "Verify Account",
                  onTap: () async {
                    formKey.currentState!.validate();
                    if (currentText.length != 6) {
                      errorController!.add(ErrorAnimationType.shake);
                      return;
                    }

                    setState(() => validatingCode = true);
                    await AuthHelper.completeTwoFa(
                            code: currentText, password: widget.param.password)
                        .then((msg) async {
                      showCustomSnackBar(
                          context: context,
                          text: msg,
                          type: NotificationType.success);

                      UserProvider userProvider =
                          Provider.of<UserProvider>(context, listen: false);
                      await userProvider.updateProfileInformation();

                      Navigator.pushNamedAndRemoveUntil(
                          context,
                          RoutesManager.dashboardRoute,
                          (Route<dynamic> route) => false);
                    }).catchError((e) {
                      showCustomSnackBar(
                          context: context,
                          text: e.toString(),
                          type: NotificationType.error);
                    });

                    setState(() => validatingCode = false);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
