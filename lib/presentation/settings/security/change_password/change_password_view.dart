import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/resources/values_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_scaffold.dart';
import 'package:jimmy_exchange/presentation/widgets/spacer.dart';

import '../../../../core/enum.dart';
import '../../../../core/helpers/user_helper.dart';
import '../../../../core/utils/validators.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_input_field.dart';
import '../../../widgets/custom_snackbar.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final TextEditingController oldPasswordController =
      new TextEditingController();
  final TextEditingController newPasswordController =
      new TextEditingController();
  final TextEditingController confirmPasswordController =
      new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  Widget buildSpacer() => const SizedBox(height: 30);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CustomScaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
            title: Text("Change Password", style: get16TextStyle())),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
            children: [
              // TOP BAR
              const SettingsPageTopSpacer(),

              // // // //

              CustomInputField(
                textEditingController: oldPasswordController,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.text,
                hintText: "Enter Old Password",
                formHolderName: "Enter Old Password",
                isPasswordField: true,
                validator: (v) => Validator.validateField(
                    fieldName: "Old Password", input: v),
              ),
              const SizedBox(height: 24),
              CustomInputField(
                textEditingController: newPasswordController,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.text,
                hintText: "Enter New Password",
                formHolderName: "Enter New Password",
                isPasswordField: true,
                validator: (v) => Validator.validatePassword(v),
              ),
              const SizedBox(height: 24),

              CustomInputField(
                textEditingController: confirmPasswordController,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.text,
                hintText: "Confirm New Password",
                formHolderName: "Confirm New Password",
                isPasswordField: true,
                validator: (v) =>
                    Validator.validatePassword(v) ??
                    Validator.doesPasswordMatch(
                        password: newPasswordController.text,
                        confirmPassword: v),
              ),

              //

              Padding(
                padding: EdgeInsets.only(
                    top: isSmallScreen(context) ? 120 : 230, bottom: 60),
                child: CustomBtn(
                  isActive: true,
                  loading: loading,
                  text: "Update",
                  onTap: () async {
                    if (!(_formKey.currentState?.validate() ?? false)) {
                      showCustomSnackBar(
                        context: context,
                        type: NotificationType.error,
                        text:
                            "Please ensure that all input are filled correctly.",
                      );
                    } else {
                      setState(() => loading = true);

                      await UserHelper.changePassword(
                              old_password: oldPasswordController.text,
                              new_password: newPasswordController.text,
                              new_password_confirmation:
                                  confirmPasswordController.text)
                          .then((msg) {
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
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
