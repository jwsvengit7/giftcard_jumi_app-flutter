import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/routes_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/resources/values_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_back_button.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_logo.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_scaffold.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../core/enum.dart';
import '../../core/helpers/auth_helper.dart';
import '../../core/utils/utils.dart';
import '../resources/route_arg/two_fa_arg copy.dart';
import '../widgets/custom_snackbar.dart';

class PasswordReset2View extends StatefulWidget {
  const PasswordReset2View({super.key, required this.email});
  final String email;

  @override
  State<PasswordReset2View> createState() => _PasswordReset2ViewState();
}

class _PasswordReset2ViewState extends State<PasswordReset2View> {
  final formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  bool requestOtpLoading = false;
  String currentText = "";
  bool loading = false;
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p16, vertical: AppPadding.p16),
          children: [
            // TOP BAR
            Align(alignment: Alignment.centerLeft, child: CustomLogo()),
            SizedBox(height: 25),

            Row(
              children: [
                CustomBackButton(),
                const SizedBox(width: 16),
                Text("Reset Password",
                    style: get32TextStyle(fontSize: FontSize.s20)),
              ],
            ),

            SizedBox(height: 30),
            Text(
              "An OTP has been sent to ${obscureEmail(widget.email)} Verify it to reset your password.",
              softWrap: true,
              style: get16TextStyle().copyWith(
                  fontSize: FontSize.s16,
                  color: ColorManager.kTextColor,
                  fontWeight: FontWeight.w400,
                  height: 2),
            ),

            // INPUTS
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
                            "Resend Code",
                            style: get14TextStyle(color: ColorManager.kGrayAlt)
                                .copyWith(decoration: TextDecoration.underline),
                          ),
                        ),
                        onTap: () async {
                          setState(() {
                            requestOtpLoading = true;
                          });
                          //
                          //

                          await AuthHelper.requestPasswordResetCode(
                                  widget.email)
                              .then((msg) {
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

            //
            Padding(
              padding: const EdgeInsets.only(top: 60, bottom: 47),
              child: CustomBtn(
                text: "Next",
                isActive: true,
                loading: loading,
                onTap: () async {
                  // requestOtpLoading

                  if (currentText.length != 6) {
                    errorController!.add(ErrorAnimationType.shake);
                    return;
                  }

                  setState(() {
                    loading = true;
                  });

                  await AuthHelper.validateResetCode(
                          email: widget.email, code: currentText)
                      .then((value) {
                    //
                    //
                    setState(() {
                      loading = false;
                    });
                    Navigator.pushNamed(
                        context, RoutesManager.passwordReset3Route,
                        arguments: PasswordReset3Arg(
                            code: currentText, email: widget.email));
                  }).catchError((e) {
                    setState(() {
                      loading = false;
                    });
                    showCustomSnackBar(
                        context: context,
                        text: e.toString(),
                        type: NotificationType.error);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
