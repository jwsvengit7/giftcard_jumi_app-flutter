import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/core/utils/validators.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_scaffold.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../../core/enum.dart';
import '../../../../core/helpers/auth_helper.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../../resources/values_manager.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_btn.dart';
import '../../../widgets/custom_snackbar.dart';

class SetupTransactionPinView extends StatefulWidget {
  const SetupTransactionPinView({super.key});

  @override
  State<SetupTransactionPinView> createState() =>
      _SetupTransactionPinViewState();
}

class _SetupTransactionPinViewState extends State<SetupTransactionPinView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  StreamController<ErrorAnimationType>? errorController2;
  String currentText = "";

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    errorController2 = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    errorController2!.close();

    super.dispose();
  }

  bool requestOtpLoading = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomScaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
            title: Text("Set up Transaction PIN", style: get16TextStyle())),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: isSmallScreen(context) ? 45 : 60, bottom: 14),
                child: const Text("Enter Pin"),
              ),

              PinCodeTextField(
                appContext: context,
                length: 4,
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  activeColor: ColorManager.kPrimaryBlue,
                  inactiveFillColor: ColorManager.kWhite,
                  selectedColor: ColorManager.kPrimaryBlue,
                  activeFillColor: ColorManager.kFormBg,
                  selectedFillColor: ColorManager.kWhite,
                  errorBorderColor: ColorManager.kError,
                  inactiveColor: ColorManager.kFormBorder,
                  shape: PinCodeFieldShape.box,
                  borderWidth: 0,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 80,
                  fieldWidth: 80,
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
                    Validator.validateField(fieldName: "PIN", input: value),
                beforeTextPaste: (text) {
                  debugPrint("Allowing to paste $text");
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
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
                  confirmPassword: textEditingController.text,
                  fieldName: "Confirm Pin",
                ),
                pinTheme: PinTheme(
                  activeColor: ColorManager.kPrimaryBlue,
                  inactiveFillColor: ColorManager.kWhite,
                  selectedColor: ColorManager.kPrimaryBlue,
                  activeFillColor: ColorManager.kFormBg,
                  selectedFillColor: ColorManager.kWhite,
                  errorBorderColor: ColorManager.kError,
                  inactiveColor: ColorManager.kFormBorder,
                  shape: PinCodeFieldShape.box,
                  borderWidth: 0,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 80,
                  fieldWidth: 80,
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

              //

              SizedBox(height: isSmallScreen(context) ? 150 : 70),
              const SizedBox(height: 30),
              CustomBtn(
                  isActive: true,
                  loading: loading,
                  text: "Set Up",
                  onTap: () async {
                    if (!_formKey.currentState!.validate()) return;

                    setState(() => loading = true);
                    await AuthHelper.updateTransactionPin(
                            new_pin: textEditingController.text,
                            new_pin_confirmation: textEditingController2.text)
                        .then((msg) async {
                      showCustomSnackBar(
                          context: context,
                          text: msg,
                          type: NotificationType.success);

                      userProvider.updateProfileInformation();
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
