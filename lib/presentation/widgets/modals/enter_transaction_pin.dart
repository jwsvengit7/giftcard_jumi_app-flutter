import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/core/utils/validators.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_back_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../resources/color_manager.dart';

import '../../resources/styles_manager.dart';
import '../custom_btn.dart';

class EnterTransactionPin extends StatefulWidget {
  const EnterTransactionPin({super.key, this.width});

  final double? width;

  @override
  State<EnterTransactionPin> createState() => _EnterTransactionPinState();
}

class _EnterTransactionPinState extends State<EnterTransactionPin> {
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  ScrollController scrollController = ScrollController();

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

  bool resendOtpLoading = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50.h, bottom: 20),
                child: Row(
                  children: [
                    CustomBackButton(),
                    SizedBox(width: 80.w),
                    Text(
                      'Enter Transaction Pin',
                      style: get16TextStyle().copyWith(
                          fontWeight: FontWeight.w700, fontSize: 20.sp),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "KIndly enter your transaction PIN to process the transaction",
                  textAlign: TextAlign.center,
                  style: get14TextStyle().copyWith(
                      fontWeight: FontWeight.w400,
                      height: 1.8,
                      fontSize: 16.sp,
                      color: ColorManager.kGray1),
                ),
              ),
              SizedBox(height: 80.h),
              Text(
                "Input PIN",
                textAlign: TextAlign.center,
                style: get14TextStyle().copyWith(
                    fontWeight: FontWeight.w300,
                    fontSize: 14.sp,
                    color: ColorManager.kGray1..withOpacity(0.67)),
              ),
              SizedBox(
                height: 8.h,
              ),
              PinCodeTextField(
                appContext: context,
                length: 4,
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  activeColor: ColorManager.kGray3,
                  inactiveFillColor: ColorManager.kWhite,
                  selectedColor: ColorManager.kGray3,
                  activeFillColor: ColorManager.kWhite,
                  selectedFillColor: ColorManager.kWhite,
                  errorBorderColor: Colors.red,
                  inactiveColor: ColorManager.kGray3,
                  disabledColor: ColorManager.kGray3,
                  shape: PinCodeFieldShape.box,
                  borderWidth: 0.6,
                  fieldHeight: 60,
                  fieldWidth: widget.width ?? 98.w,
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
                autoFocus: true,
              ),

              //
              SizedBox(height: 150.h),
              CustomBtn(
                  isActive: true,
                  loading: loading,
                  text: "Continue",
                  onTap: () async {
                    // if (!_formKey.currentState!.validate()) return;

                    Navigator.pop(context, textEditingController.text);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
