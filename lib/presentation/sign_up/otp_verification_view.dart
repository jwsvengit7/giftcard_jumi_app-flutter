import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/helpers/auth_helper.dart';
import 'package:jimmy_exchange/presentation/resources/routes_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_back_button.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_scaffold.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_logo.dart';
import '../../core/enum.dart';
import '../../core/providers/user_provider.dart';
import '../../core/utils/utils.dart';
import '../resources/color_manager.dart';
import '../resources/route_arg/otp_verification_arg.dart';
import '../resources/styles_manager.dart';
import '../resources/values_manager.dart';
import '../widgets/custom_snackbar.dart';

class OtpVerificationView extends StatefulWidget {
  final OtpVerificationArg param;
  const OtpVerificationView({super.key, required this.param});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  final formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  String currentText = "";
  bool requestOtpLoading = false;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sendOtp();
    });
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    super.dispose();
  }

  bool validatingOtp = false;

  Future<void> sendOtp() async {
    setState(() => requestOtpLoading = true);
    await AuthHelper.resendOtp(token: widget.param.token).then((msg) {
      showCustomSnackBar(
        context: context,
        text: msg,
        type: NotificationType.success,
      );
    }).catchError((e) {
      showCustomSnackBar(
          context: context, text: e.toString(), type: NotificationType.error);
    });
    setState(() => requestOtpLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: CustomScaffold(
      body: GestureDetector(
        onTap: () {},
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.p16, vertical: AppPadding.p16),
            children: <Widget>[
              /// LOGO
              SizedBox(
                height: 15,
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: CustomLogo(),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Row(
                  children: [
                    CustomBackButton(),
                    const SizedBox(width: 16),
                    Text("OTP Verification",
                        style: get32TextStyle(fontSize: FontSize.s20)),
                  ],
                ),
              ),
              Text(
                  "An OTP has been sent to ${obscureEmail(widget.param.user.email ?? "")} Input the code below to verify your account.",
                  style: get16TextStyle().copyWith(
                      fontSize: FontSize.s16,
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
                  validator: (v) {
                    return null;
                  },
                  pinTheme: PinTheme(
                      activeColor: ColorManager.kFormBorder,
                      inactiveFillColor: Colors.white,
                      selectedColor: ColorManager.kFormBorder,
                      activeFillColor: Colors.white,
                      selectedFillColor: Colors.white,
                      errorBorderColor: ColorManager.kError,
                      inactiveColor: ColorManager.kFormBorder,
                      shape: PinCodeFieldShape.box,
                      borderWidth: 0,
                      borderRadius: BorderRadius.circular(10),
                      fieldHeight: 60,
                      fieldWidth: 60,
                      fieldOuterPadding: EdgeInsets.all(0)),
                  cursorColor: ColorManager.kBlack,
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
                          onTap: () => sendOtp(),
                        ),
                ),
              ),
              const SizedBox(height: 60),
              CustomBtn(
                  isActive: true,
                  loading: validatingOtp,
                  text: "Verify Account",
                  textStyle: getBtnTextStyle(fontWeight: FontWeight.w700),
                  onTap: () async {
                    formKey.currentState!.validate();

                    if (currentText.length != 6) {
                      errorController!.add(ErrorAnimationType.shake);
                      return;
                    }

                    //
                    setState(() => validatingOtp = true);
                    await AuthHelper.verifyEmail(
                            code: currentText, token: widget.param.token)
                        .then((msg) async {
                      showCustomSnackBar(
                          context: context,
                          text: msg,
                          type: NotificationType.success);

                      if (widget.param.otpType == OtpType.signUp) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RoutesManager.loginRoute,
                          (Route<dynamic> route) => false,
                        );
                      } else if (widget.param.otpType == OtpType.login) {
                        //

                        UserProvider userProvider =
                            Provider.of<UserProvider>(context, listen: false);
                        await userProvider.updateProfileInformation();
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            RoutesManager.dashboardRoute,
                            (Route<dynamic> route) => false);
                      }
                    }).catchError((e) {
                      showCustomSnackBar(
                          context: context,
                          text: e.toString(),
                          type: NotificationType.error);
                    });

                    setState(() => validatingOtp = false);
                  })
            ],
          ),
        ),
      ),
    ));
  }
}
