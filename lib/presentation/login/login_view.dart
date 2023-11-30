import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jimmy_exchange/core/constants.dart';
import 'package:jimmy_exchange/core/helpers/auth_helper.dart';
import 'package:jimmy_exchange/core/model/user.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/routes_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/resources/values_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/spacer.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_indicator.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_scaffold.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../core/enum.dart';
import '../../core/providers/user_provider.dart';
import '../../core/services/secure_storage.dart';
import '../../core/utils/validators.dart';
import '../resources/route_arg/otp_verification_arg.dart';
import '../resources/route_arg/two_fa_arg.dart';
import '../widgets/alternate_logins.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_logo.dart';
import '../widgets/custom_snackbar.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  LocalAuthentication localAuth = LocalAuthentication();

  bool canCheckBiometrics = false;
  bool loading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      canCheckBiometrics = await localAuth.canCheckBiometrics;
      setState(() {});
    });

    super.initState();
  }

  //
  Future<void> _verifyBiometrics(BuildContext context) async {
    bool didAuthenticate = await localAuth.authenticate(
        localizedReason: "Please complete the authentication process");

    //
    if (didAuthenticate) {
      var authCred = await SecureStorage.getInstance()
          .then((pref) => json.decode(pref.getString("authCred") ?? "{}"))
          .catchError((_) => {});

      String email = authCred["user"]["email"];
      String password = authCred["pass_cred"];
      String? social_token = authCred["social_token"];
      String? channel = authCred["channel"];

      signIn(
        email: email,
        password: password,
        social_token: social_token,
        channel: channel,
      ).catchError((e) {
        AuthHelper.logout(context);
        showCustomSnackBar(
          context: context,
          text:
              "An error occured during authentication, login with your actual credentials.",
          type: NotificationType.error,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    User? user = Provider.of<UserProvider>(context).user;
    bool locked = user != null;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CustomScaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
          children: [
            // TOP BAR
            SizedBox(height: 50.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomLogo(),
                if (locked)
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    child: GestureDetector(
                      onTap: () async {
                        await AuthHelper.logout(context);
                        setState(() {
                          user = null;
                        });
                      },
                      child: Text("Log In to Another Account",
                          style: get32TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorManager.kPrimaryBlue),
                          maxLines: 2),
                    ),
                  )
              ],
            ),
            SizedBox(height: isSmallScreen(context) ? 20 : 30),
            Text(
                locked
                    ? "Welcome back, \n${capitalizeFirstString(user!.firstname)}"
                    : "Login to your account",
                style: get32TextStyle(fontSize: 20),
                maxLines: 2),
            // const SizedBox(height: 16),

            // INPUTS
            const SizedBox(height: 60),
            locked
                ? const SizedBox()
                : Column(
                    children: [
                      CustomInputField(
                        textEditingController: emailController,
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.text,
                        hintText: "Email Address",
                        formHolderName: "Email Address",
                        validator: (val) => Validator.validateField(
                            fieldName: "Email", input: val),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),

            CustomInputField(
              textEditingController: passwordController,
              textInputAction: TextInputAction.done,
              textInputType: TextInputType.text,
              hintText: "Password",
              formHolderName: "Password",
              isPasswordField: true,
              validator: (val) =>
                  Validator.validateField(fieldName: "Password", input: val),
            ),
            SizedBox(height:20.h),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Forgot Password?',
                    style: get14TextStyle(color: ColorManager.kPrimaryBlue)
                       
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(
                      context, RoutesManager.passwordReset1Route);
                },
              ),
            ),

            //

            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: CustomBtn(
                text: "Login",
                isActive: true,
                loading: loading,
                onTap: () async {
                  if (locked) {
                    if (passwordController.text.isEmpty) {
                      showCustomSnackBar(
                          context: context,
                          text: "Please enter your password.",
                          type: NotificationType.error);
                      return;
                    }
                    emailController.text = user?.email ?? "";
                  } else if (emailController.text.isEmpty ||
                      passwordController.text.isEmpty) {
                    showCustomSnackBar(
                        context: context,
                        text: "All fields are required.",
                        type: NotificationType.error);
                    return;
                  }

                  signIn(
                    email: emailController.text,
                    password: passwordController.text,
                  ).catchError((e) {
                    showCustomSnackBar(
                        context: context,
                        text: e.toString(),
                        type: NotificationType.error);
                  });
                },
              ),
            ),

            //
            locked
                ? Column(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 54, bottom: 74),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Text(
                      //           "Not ${truncateWithEllipsis(10, capitalizeFirstString(user!.firstname))}?",
                      //           style: get16TextStyle(
                      //               color: ColorManager.kGrayB3)),
                      //       const SizedBox(width: 4),
                      //       GestureDetector(
                      //         behavior: HitTestBehavior.translucent,
                      //         child: Text(
                      //           "Login Here",
                      //           style: get16TextStyle(
                      //                   color: ColorManager.kNavyBlue)
                      //               .copyWith(
                      //                   decoration: TextDecoration.underline),
                      //         ),
                      //         onTap: () async {
                      //           await AuthHelper.logout(context);
                      //           setState(() {
                      //             user = null;
                      //           });
                      //         },
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      canCheckBiometrics
                          ? Column(
                              children: [
                                SizedBox(height: 40.h),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 44.w),
                                  child: Text("Or Tap the Icon to log in",
                                      style: get14TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,color: ColorManager.kTextColor)),
                                ),
                                const SizedBox(height: 22),
                                GestureDetector(
                                  child: Image.asset(
                                      ImageManager.kFaceBiometrics,
                                      width: 64.w,
                                      height: 64.w),
                                  onTap: () => _verifyBiometrics(context),
                                  behavior: HitTestBehavior.translucent,
                                ),
                              ],
                            )
                          : const SizedBox(),

                      //
                    ],
                  )
                : Column(
                    children: [
                      const SizedBox(height: 78),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('OR', style: get14TextStyle()),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 22, bottom: 60),
                          child: AlternateLogins(
                            onTap: Platform.isIOS
                                ? () async {
                                    AuthorizationCredentialAppleID? credential;
                                    try {
                                      credential = await SignInWithApple
                                          .getAppleIDCredential(
                                        scopes: [
                                          AppleIDAuthorizationScopes.email,
                                          AppleIDAuthorizationScopes.fullName,
                                        ],
                                      );
                                    } catch (e) {}

                                    if (credential != null) {
                                      signIn(
                                        email: "",
                                        password: "",
                                        social_token: credential.identityToken,
                                        channel: Constants.kAppleChannel,
                                      ).catchError((e) {
                                        AuthHelper.logout(context);
                                        showCustomSnackBar(
                                          context: context,
                                          text: e.toString(),
                                          type: NotificationType.error,
                                        );
                                      });
                                    }
                                  }
                                : () async {
                                    try {
                                      GoogleSignInAccount? acc =
                                          await GoogleSignIn().signIn();

                                      if (acc != null) {
                                        GoogleSignInAuthentication all =
                                            await acc.authentication;

                                        signIn(
                                          email: "",
                                          password: "",
                                          social_token: all.accessToken,
                                          channel: Constants.kGoogleChannel,
                                        ).catchError((e) {
                                          AuthHelper.logout(context);
                                          showCustomSnackBar(
                                            context: context,
                                            text: e.toString(),
                                            type: NotificationType.error,
                                          );
                                        });
                                      }
                                    } catch (error) {}
                                  },
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don’t have an account?",
                              style: get16TextStyle().copyWith(
                                  color: ColorManager.kGrayB3,
                                  fontWeight: FontWeight.w400)),
                          const SizedBox(width: 8),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            child: Text(
                              'Sign Up',
                              style: get16TextStyle().copyWith(
                                  decoration: TextDecoration.underline,
                                  color: ColorManager.kPrimaryBlue,
                                  fontWeight: FontWeight.w500),
                            ),
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, RoutesManager.signupRoute);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
            //
            const BottomSpacer()
          ],
        ),
      ),
    );
  }

  Future<void> signIn(
      {required String email,
      required String password,
      String? channel,
      String? social_token}) async {
    try {
      if (mounted) setState(() => loading = true);
      var res = await AuthHelper.signIn(
        email: email,
        password: password,
        social_token: social_token,
        channel: channel,
      );

      User user = res["user"];
      bool requires_two_fa = res["requires_two_fa"];

      if (user.email_verified_at == null) {
        String token = await SecureStorage.getInstance().then((pref) {
          var authCred = pref.getString("authCred");
          return json.decode(authCred ?? "")['token'];
        }).catchError((_) {});
        setState(() => loading = false);
        Navigator.pushNamed(context, RoutesManager.otpVerificationRoute,
            arguments: OtpVerificationArg(
                user: user, token: token, otpType: OtpType.login));
        return;
      } else if (requires_two_fa) {
        setState(() => loading = false);
        Navigator.pushNamed(context, RoutesManager.twoFARoute,
            arguments: TwoFaArg(user: user, password: password));
        return;
      }

      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      await userProvider.updateProfileInformation();
      Navigator.pushNamedAndRemoveUntil(context, RoutesManager.dashboardRoute,
          (Route<dynamic> route) => false);
      if (mounted) setState(() => loading = false);
    } catch (e) {
      if (mounted) setState(() => loading = false);
      rethrow;
      ////
    }
  }
}
