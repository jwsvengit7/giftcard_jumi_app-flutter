import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/helpers/auth_helper.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/routes_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/resources/values_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_back_button.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_logo.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_scaffold.dart';

import '../../core/enum.dart';
import '../../core/utils/validators.dart';
import '../resources/route_arg/two_fa_arg copy.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_snackbar.dart';

class PasswordReset3View extends StatefulWidget {
  const PasswordReset3View({super.key, required this.param});
  final PasswordReset3Arg param;

  @override
  State<PasswordReset3View> createState() => _PasswordReset3ViewState();
}

class _PasswordReset3ViewState extends State<PasswordReset3View> {
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController confrimPasswordController =
      new TextEditingController();

  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: CustomScaffold(
          body: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
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

                SizedBox(height: 50),
    
                Text(
                  "Please enter a new password to reset the password",
                  style: get16TextStyle().copyWith(
                    color: ColorManager.kTextColor,
                    fontSize: FontSize.s16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
    
                // INPUTS
                const SizedBox(height: 60),
                CustomInputField(
                  textEditingController: passwordController,
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.text,
                  hintText: "New Password",
                  formHolderName: "New Password",
                  validator: (v) => Validator.validatePassword(v),
                  isPasswordField: true,
                ),
                const SizedBox(height: 24),
    
                CustomInputField(
                  textEditingController: confrimPasswordController,
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.text,
                  hintText: "Confirm New Password",
                  formHolderName: "Confirm New Password",
                  isPasswordField: true,
                  validator: (v) => Validator.validatePassword(v),
                ),
    
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: CustomBtn(
                    isActive: true,
                    loading: loading,
                    text: "Reset Password",
                    onTap: () async {
                      if (!(_formKey.currentState?.validate() ?? false) ||
                          passwordController.text !=
                              confrimPasswordController.text) {
                        showCustomSnackBar(
                          context: context,
                          type: NotificationType.error,
                          text:
                              "Please ensure that all input are filled correctly.",
                        );
                      } else {
                        setState(() {
                          loading = true;
                        });
                        await AuthHelper.completeResetPassword(
                                email: widget.param.email,
                                code: widget.param.code,
                                password: passwordController.text)
                            .then((value) {
                          setState(() {
                            loading = false;
                          });
    
                          Navigator.pushNamed(
                              context, RoutesManager.passwordResetStatusRoute);
                        }).catchError((e) {
                          setState(() {
                            loading = false;
                          });
                          showCustomSnackBar(
                            context: context,
                            type: NotificationType.error,
                            text: "$e",
                          );
                        });
                      }
                    },
                  ),
                ),
    
                //
              ],
            ),
          ),
        ),
      ),
    );
  }
}
