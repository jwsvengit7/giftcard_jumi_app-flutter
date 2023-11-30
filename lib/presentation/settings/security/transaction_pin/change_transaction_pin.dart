import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/core/utils/validators.dart';
import 'package:jimmy_exchange/presentation/resources/routes_manager.dart';
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

class ChangeTransactionPinView extends StatefulWidget {
  const ChangeTransactionPinView({super.key});

  @override
  State<ChangeTransactionPinView> createState() =>
      _ChangeTransactionPinViewState();
}

class _ChangeTransactionPinViewState extends State<ChangeTransactionPinView> {
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
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    errorController2!.close();
    errorController3!.close();

    super.dispose();
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomScaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
            title: Text("Change Transaction PIN", style: get16TextStyle())),
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
                child: const Text("Enter Old PIN"),
              ),

              PinCodeTextField(
                appContext: context,
                length: 4,
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
                    Validator.validateField(fieldName: "Old PIN", input: value),
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
                  fieldName: "New PIN",
                  input: value,
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
                errorAnimationController: errorController2,
                controller: textEditingController2,
                keyboardType: TextInputType.number,
                onChanged: (value) {},
              ),

              const Padding(
                padding: EdgeInsets.only(top: 5, bottom: 14),
                child: Text("Enter Pin"),
              ),
              PinCodeTextField(
                appContext: context,
                length: 4,
                obscureText: false,
                animationType: AnimationType.fade,
                validator: (value) => Validator.doesPasswordMatch(
                  confirmPassword: textEditingController2.text,
                  password: value,
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
                onChanged: (value) {},
              ),

              //
              //
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Having trouble?",
                    style: get16TextStyle().copyWith(
                      color: ColorManager.kGreyscale500,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: Text(
                      "recover your PIN ",
                      style: get16TextStyle(color: ColorManager.kNavyBlue)
                          .copyWith(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                          context, RoutesManager.recoverTransactionPinView);
                    },
                  ),
                ],
              ),
              SizedBox(height: isSmallScreen(context) ? 50 : 80),
              const SizedBox(height: 60),
              CustomBtn(
                  isActive: true,
                  loading: loading,
                  text: "Change",
                  onTap: () async {
                    if (!_formKey.currentState!.validate()) return;

                    setState(() => loading = true);
                    await AuthHelper.updateTransactionPin(
                            old_pin: textEditingController.text,
                            new_pin: textEditingController2.text,
                            new_pin_confirmation: textEditingController3.text)
                        .then((msg) async {
                      showCustomSnackBar(
                          context: context,
                          text: msg,
                          type: NotificationType.success);

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
