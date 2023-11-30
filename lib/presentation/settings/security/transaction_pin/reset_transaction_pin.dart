import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/core/utils/validators.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_scaffold.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/enum.dart';
import '../../../../core/helpers/auth_helper.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../../resources/values_manager.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_btn.dart';
import '../../../widgets/custom_snackbar.dart';

class RecoverTransactionPinView extends StatefulWidget {
  const RecoverTransactionPinView({super.key});

  @override
  State<RecoverTransactionPinView> createState() =>
      _RecoverTransactionPinViewState();
}

class _RecoverTransactionPinViewState extends State<RecoverTransactionPinView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();
  TextEditingController textEditingController3 = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  StreamController<ErrorAnimationType>? errorController2;
  StreamController<ErrorAnimationType>? errorController3;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    errorController2 = StreamController<ErrorAnimationType>();
    errorController3 = StreamController<ErrorAnimationType>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await sendCode();
    });

    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    errorController2!.close();
    errorController3!.close();

    super.dispose();
  }

  bool resendOtpLoading = false;
  bool loading = false;

  Future<void> sendCode() async {
    setState(() => resendOtpLoading = true);

    await AuthHelper.requestTransactionPinResetCode().then((msg) {
      showCustomSnackBar(
        context: context,
        text: msg,
        type: NotificationType.success,
      );
    }).catchError((e) {
      showCustomSnackBar(
          context: context, text: e.toString(), type: NotificationType.error);
    });
    setState(() => resendOtpLoading = false);
    //
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomScaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
            title: Text("Recover Transaction PIN", style: get16TextStyle())),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: isSmallScreen(context) ? 45 : 60, bottom: 14),
                child: const Text("Enter Code"),
              ),

              PinCodeTextField(
                appContext: context,
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  activeColor: ColorManager.kFormBg,
                  inactiveFillColor: ColorManager.kFormBg,
                  selectedColor: ColorManager.kFormBg,
                  activeFillColor: ColorManager.kFormBg,
                  selectedFillColor: ColorManager.kFormBg,
                  errorBorderColor: Colors.black,
                  inactiveColor: Colors.black,
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
                onChanged: (value) {},
                validator: (value) =>
                    Validator.validateField(fieldName: "Code", input: value),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 22,
                  child: resendOtpLoading
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
                              style:
                                  get14TextStyle(color: ColorManager.kGrayAlt)
                                      .copyWith(
                                          decoration: TextDecoration.underline),
                            ),
                          ),
                          onTap: () => sendCode(),
                        ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(top: 5, bottom: 14),
                child: Text("Enter New PIN"),
              ),

              ////
              PinCodeTextField(
                appContext: context,
                length: 4,
                obscureText: false,
                animationType: AnimationType.fade,
                validator: (value) => Validator.validateField(
                    input: value, fieldName: " New PIN"),
                pinTheme: PinTheme(
                  activeColor: ColorManager.kFormBg,
                  inactiveFillColor: ColorManager.kFormBg,
                  selectedColor: ColorManager.kFormBg,
                  activeFillColor: ColorManager.kFormBg,
                  selectedFillColor: ColorManager.kFormBg,
                  errorBorderColor: Colors.black,
                  inactiveColor: Colors.black,
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
                errorAnimationController: errorController2,
                controller: textEditingController2,
                keyboardType: TextInputType.number,
                onChanged: (value) {},
              ),

              const Padding(
                padding: EdgeInsets.only(top: 5, bottom: 14),
                child: Text("Confirm Pin"),
              ),
              PinCodeTextField(
                appContext: context,
                length: 4,
                obscureText: false,
                animationType: AnimationType.fade,
                validator: (value) => Validator.doesPasswordMatch(
                  password: value,
                  confirmPassword: textEditingController2.text,
                  fieldName: "Confirm Pin",
                ),
                pinTheme: PinTheme(
                  activeColor: ColorManager.kFormBg,
                  inactiveFillColor: ColorManager.kFormBg,
                  selectedColor: ColorManager.kFormBg,
                  activeFillColor: ColorManager.kFormBg,
                  selectedFillColor: ColorManager.kFormBg,
                  errorBorderColor: Colors.black,
                  inactiveColor: Colors.black,
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
                errorAnimationController: errorController3,
                controller: textEditingController3,
                keyboardType: TextInputType.number,
                onChanged: (_) {},
              ),

              //
              //
              SizedBox(height: isSmallScreen(context) ? 100 : 150),
              CustomBtn(
                  isActive: true,
                  loading: loading,
                  text: "Reset PIN",
                  onTap: () async {
                    if (!_formKey.currentState!.validate()) return;

                    setState(() => loading = true);
                    await AuthHelper.recoverTransactionPin(
                            code: textEditingController.text,
                            new_pin: textEditingController2.text,
                            new_pin_confirmation: textEditingController3.text)
                        .then((msg) async {
                      showCustomSnackBar(
                        context: context,
                        text: msg,
                        type: NotificationType.success,
                      );

                      Navigator.pop(context);
                    }).catchError((e) {
                      showCustomSnackBar(
                          context: context,
                          text: e.toString(),
                          type: NotificationType.error);
                    });

                    setState(() => loading = false);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
