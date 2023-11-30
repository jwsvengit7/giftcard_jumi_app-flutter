import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/enum.dart';
import 'package:jimmy_exchange/core/helpers/auth_helper.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/routes_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/resources/values_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_back_button.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_logo.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_scaffold.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_snackbar.dart';

import '../../core/utils/validators.dart';
import '../widgets/custom_input_field.dart';

class PasswordReset1View extends StatefulWidget {
  const PasswordReset1View({super.key});

  @override
  State<PasswordReset1View> createState() => _PasswordReset1ViewState();
}

class _PasswordReset1ViewState extends State<PasswordReset1View> {
  final TextEditingController emailController = new TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScaffold(
        body: ListView(
          padding: EdgeInsets.symmetric(
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
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Text(
                  "Kindly Input your email so as to be able to reset your password",
                  style: get16TextStyle().copyWith(
                      fontSize: FontSize.s16,
                      color: ColorManager.kTextColor,
                      height: 2,
                      fontWeight: FontWeight.w400)),
            ),

            // INPUTS
            const SizedBox(height: 60),
            CustomInputField(
              textEditingController: emailController,
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.text,
              hintText: "E-mail Address",
              formHolderName: "E-mail Address",
              validator: (val) =>
                  Validator.validateField(fieldName: "Email", input: val),
              suffixIcon: Image.asset(ImageManager.kMail, width: 22),
            ),

            //
            Padding(
              padding: const EdgeInsets.only(top: 60, bottom: 47),
              child: CustomBtn(
                isActive: true,
                loading: loading,
                text: "Reset",
                onTap: () async {
                  if (emailController.text.isEmpty) {
                    showCustomSnackBar(
                        context: context,
                        text: "Please input your email",
                        type: NotificationType.error);
                    return;
                  }

                  setState(() {
                    loading = true;
                  });

                  await AuthHelper.requestPasswordResetCode(
                          emailController.text)
                      .then((e) {
                    setState(() {
                      loading = false;
                    });
                    Navigator.pushNamed(
                        context, RoutesManager.passwordReset2Route,
                        arguments: emailController.text);
                    //
                  }).catchError((e) {
                    //
                    showCustomSnackBar(
                        context: context,
                        text: "$e",
                        type: NotificationType.error);
                    setState(() {
                      loading = false;
                    });
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
