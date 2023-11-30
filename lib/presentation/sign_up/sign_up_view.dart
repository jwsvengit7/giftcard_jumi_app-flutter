import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/routes_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/resources/values_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/alternate_logins.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_indicator.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_logo.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_scaffold.dart';
import 'package:provider/provider.dart';

import '../../core/enum.dart';
import '../../core/helpers/auth_helper.dart';
import '../../core/model/country.dart';
import '../../core/providers/generic_provider.dart';
import '../../core/utils/validators.dart';
import '../resources/route_arg/otp_verification_arg.dart';
import '../widgets/custom_bottom_sheet.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/modals/select_country.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController firstNameController = new TextEditingController();
  final TextEditingController lastNameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController phoneNoController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController refController = new TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        selectCountry();
      } catch (_) {}
    });
    super.initState();
  }

  void selectCountry() async {
    GenericProvider genericProvider =
        Provider.of<GenericProvider>(context, listen: false);
    List<Country> _countries = [];
    if (genericProvider.countries.isEmpty) {
      _countries = await genericProvider.updateCountries();
    }

    for (final Country el in _countries) {
      if (el.dialing_code == "+234") {
        selectedCountry = el;
        break;
      }
    }
    setState(() {});
  }

  Country? selectedCountry;

  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  Widget buildSpacer() => const SizedBox(height: 30);

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
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
            children: [
              /// LOGO
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomLogo(),
              ),

              // TOP BAR
              SizedBox(height: isSmallScreen(context) ? 15 : 25),
              Text("Create An Account ",
                  style: get32TextStyle(fontSize: FontSize.s20)),
              const SizedBox(height: 30),

              CustomInputField(
                textEditingController: firstNameController,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.text,
                hintText: "First Name",
                formHolderName: "First Name",
                validator: (val) =>
                    Validator.validateField(fieldName: "Full name", input: val),
              ),
              buildSpacer(),

              CustomInputField(
                textEditingController: lastNameController,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.text,
                hintText: "Last Name",
                formHolderName: "Last Name",
                validator: (val) =>
                    Validator.validateField(fieldName: "Full name", input: val),
              ),
              buildSpacer(),

              // CustomInputField(
              //   textEditingController: lastNameController,
              //   textInputAction: TextInputAction.next,
              //   textInputType: TextInputType.text,
              //   hintText: "Last Name",
              //   formHolderName: "Last Name",
              //   validator: (val) =>
              //       Validator.validateField(fieldName: "Last name", input: val),
              // ),

              CustomInputField(
                textEditingController: usernameController,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.text,
                hintText: "Username",
                formHolderName: "Username",
                validator: (val) =>
                    val!.isEmpty ? "Username cannot be empty !!" : null,
              ),
              buildSpacer(),

              CustomInputField(
                textEditingController: emailController,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.text,
                hintText: "Email Address",
                formHolderName: "Email Address",
                validator: (val) => Validator.validateEmail(val),
              ),
              buildSpacer(),

              // GestureDetector(
              //   behavior: HitTestBehavior.translucent,
              //   onTap: () async {

              //   },
              //   child: IgnorePointer(
              //     child: CustomInputField(
              //       formHolderName: "Country",
              //       hintText: "Select Country",
              //       textEditingController:
              //           TextEditingController(text: selectedCountry?.name),
              //       suffixIcon: Padding(
              //         padding: const EdgeInsets.only(right: 13),
              //         child: Image.asset(
              //           ImageManager.kArrowDown,
              //           width: 16,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // buildSpacer(),

              CustomInputField(
                  textEditingController: phoneNoController,
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.number,
                  hintText: "Phone Number",
                  formHolderName: "Phone Number",
                  validator: (val) => Validator.validateField(
                      fieldName: "Phone number", input: val),
                  prefixIcon: getPrefixDropDown(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            selectedCountry?.dialing_code ??
                                selectedCountry?.alpha3Code ??
                                "---",
                            style:
                                getPrefixTextStyle(color: ColorManager.kGray7),
                          ),
                          const SizedBox(width: 17),
                          buildDropDown(height: 24, width: 12),
                          VerticalDivider()
                        ],
                      ),
                      onTap: () async {
                        Country? res = await showCustomBottomSheet(
                            context: context, screen: const SelectCountry());
                        if (res != null) {
                          selectedCountry = res;
                          setState(() {});
                        }
                      })),
              buildSpacer(),

              CustomInputField(
                textEditingController: passwordController,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.text,
                hintText: "Password",
                formHolderName: "Password",
                isPasswordField: true,
                validator: (v) => Validator.validatePassword(v),
              ),
              //
              const SizedBox(height: 27),

              Padding(
                padding: const EdgeInsets.only(top: 27, bottom: 34),
                child: CustomBtn(
                  isActive: true,
                  loading: loading,
                  text: "Create Account",
                  textStyle: getBtnTextStyle(fontWeight: FontWeight.w700),
                  onTap: () async {
                    if (!(_formKey.currentState?.validate() ?? false) ||
                        selectedCountry == null) {
                      showCustomSnackBar(
                        context: context,
                        type: NotificationType.error,
                        text:
                            "Please ensure that all input are filled correctly.",
                      );
                    } else {
                      setState(() => loading = true);

                      await AuthHelper.signUp(
                        countryId: selectedCountry?.id ?? "",
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                        username: usernameController.text,
                        phoneNumber: phoneNoController.text,
                        ref: refController.text,
                      ).then((value) {
                        showCustomSnackBar(
                            context: context,
                            text: "Account creation was sucessful.",
                            type: NotificationType.success);
                        // Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          RoutesManager.otpVerificationRoute,
                          arguments: OtpVerificationArg(
                            user: value['user'],
                            token: value['token'],
                            otpType: OtpType.signUp,
                          ),
                        );
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

              Center(
                child: Text("OR",
                    style: get16TextStyle(
                        fontSize: FontSize.s16,
                        fontWeight: FontWeight.w300,
                        color: ColorManager.kGray2)),
              ),
              const SizedBox(height: 27),
              //
              // TODO:: uncomment
              // Include when API is available

              AlternateLogins(),

//
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ",
                      style: get16TextStyle().copyWith(
                          color: ColorManager.kGrayB3,
                          fontWeight: FontWeight.w400)),
                  const SizedBox(width: 2),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: Text(
                      "Sign In",
                      style: get16TextStyle().copyWith(
                          decoration: TextDecoration.underline,
                          color: ColorManager.kPrimaryBlue,
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () => Navigator.pushReplacementNamed(
                        context, RoutesManager.loginRoute),
                  ),
                ],
              ),
              const SizedBox(height: 55)
            ],
          ),
        ),
      ),
    ));
  }
}
