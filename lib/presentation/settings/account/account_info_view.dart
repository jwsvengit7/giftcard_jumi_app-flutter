import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jimmy_exchange/core/helpers/user_helper.dart';
import 'package:jimmy_exchange/core/providers/user_provider.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/resources/values_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_back_button.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_scaffold.dart';
import 'package:provider/provider.dart';

import '../../../../core/enum.dart';
import '../../../../core/utils/validators.dart';
import '../../../core/model/country.dart';
import '../../../core/model/user.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_bottom_sheet.dart';
import '../../widgets/custom_indicator.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/modals/select_country.dart';
import '../../widgets/popups/confirmation_popup.dart';
import '../../widgets/popups/index.dart';

class AccountInfoView extends StatefulWidget {
  const AccountInfoView({super.key});

  @override
  State<AccountInfoView> createState() => _AccountInfoViewState();
}

class _AccountInfoViewState extends State<AccountInfoView> {
  final TextEditingController firstNameController = new TextEditingController();
  final TextEditingController lastNameController = new TextEditingController();
  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController phoneNoController = new TextEditingController();
  final TextEditingController bvnController = new TextEditingController();

  Country? selectedCountry;

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool imageUploading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      updateControllersData(userProvider);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    User user = userProvider.user ?? User(wallet_balance: 0);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CustomScaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          leading: Padding(
            padding: const EdgeInsets.all(12),
            child: CustomBackButton(),
          ),
          // iconTheme: IconThemeData(size: 8,weight: 8,),
          title: Text("Account Information", style: get16TextStyle(fontSize: 20,fontWeight: FontWeight.w700)),
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
            children: [
              // TOP BAR
              // const SettingsPageTopSpacer(),
              //
              Text("Profile Photo",
                  style:
                      get16TextStyle().copyWith(fontWeight: FontWeight.w400)),

              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  await showDialogPopup(
                    context,
                    ConfirmationPopup(
                      title: "Update profile image",
                      desc:
                          "Please take a picture of yourself or upload a picture from your gallery to continue",
                      cancelText: "Camera",
                      proceedText: "Gallery",
                      onCancel: () async =>
                          updateProfileImage(ImageSource.camera, userProvider),
                      onProceed: () async =>
                          updateProfileImage(ImageSource.gallery, userProvider),
                    ),
                  );

                  /// CAUSE A DELAY
                  setState(() => imageUploading = true);
                  await Future.delayed(const Duration(milliseconds: 500));
                  setState(() => imageUploading = false);
                },
                child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Align(
                        alignment: Alignment.center,
                        child: ProfileImageBuilder(
                          isLoading: imageUploading,
                          imageUrl: user.avatar,
                        ))),
              ),

              Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Edit Photo',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: ColorManager.kPrimaryBlue),
                  )),
              SizedBox(height: 10),

              // // // //
              CustomInputField(
                textEditingController: firstNameController,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.text,
                enabled: false,
                hintText: "First Name",
                formHolderName: "First Name",
                validator: (val) => Validator.validateField(
                    fieldName: "First name", input: val),
              ),
              buildSpacer(),

              CustomInputField(
                textEditingController: lastNameController,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.text,
                enabled: false,
                hintText: "Last Name",
                formHolderName: "Last Name",
                validator: (val) =>
                    Validator.validateField(fieldName: "Last name", input: val),
              ),
              buildSpacer(),

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

              // GestureDetector(
              //   behavior: HitTestBehavior.translucent,
              //   onTap: () async => selectCountry(),
              //   child: IgnorePointer(
              //     child: CustomInputField(
              //       formHolderName: "Country",
              //       hintText: "Select Country",
              //       textEditingController:
              //           TextEditingController(text: selectedCountry?.name),
              //       suffixIcon: Padding(
              //           padding: const EdgeInsets.only(right: 13),
              //           child: buildDropDown(width: 16)),
              //     ),
              //   ),
              // ),
              // buildSpacer(),

              CustomInputField(
                enabled: false,
                textEditingController: phoneNoController,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.number,
                hintText: "Phone Number",
                formHolderName: "Phone Number",
                // validator: (val) => Validator.validateField(
                //     fieldName: "Phone number", input: val),
                prefixIcon: getPrefixDropDown(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        selectedCountry?.dialing_code ??
                            selectedCountry?.alpha3Code ??
                            "--",
                        style: getPrefixTextStyle(),
                      ),
                      const SizedBox(width: 17),
                      buildDropDown(height: 24, width: 12),
                    ],
                  ),
                  onTap: () async => selectCountry(),
                ),
              ),
              buildSpacer(),

              CustomInputField(
                textEditingController: emailController,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.text,
                hintText: "Email Address",
                formHolderName: "Email Address",
                validator: (val) => Validator.validateEmail(val),
                enabled: false,
              ),
              CustomInputField(
                textEditingController: bvnController,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.text,
                hintText: "BVN",
                formHolderName: "BVN",
                // validator: (val) => Validator.validateEmail(val),
                enabled: false,
              ),
              buildSpacer(),

              ///
              const SizedBox(height: 75)
            ],
          ),
        ),
        bottomSheet: Container(
          color: Colors.white,
          height: 80,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 7,
                bottom: 10,
                left: AppPadding.p16,
                right: AppPadding.p16),
            child: Center(
              child: CustomBtn(
                isActive: true,
                loading: loading,
                text: "Save",
                onTap: () async {
                  try {
                    if (!(_formKey.currentState?.validate() ?? false) ||
                        selectedCountry == null) {
                      throw "Please ensure that all input are filled correctly.";
                    } else {
                      setState(() => loading = true);

                      String msg = await UserHelper.updateProfile(
                        country_id: selectedCountry?.id,
                        firstname: firstNameController.text,
                        lastname: lastNameController.text,
                        email: emailController.text,
                        username: usernameController.text,
                        phone_number: phoneNoController.text,
                      );
                      await userProvider.updateProfileInformation();
                      updateControllersData(userProvider);

                      showCustomSnackBar(
                        context: context,
                        text: msg,
                        type: NotificationType.success,
                      );
                      setState(() => loading = false);
                    }
                  } catch (err) {
                    setState(() => loading = false);
                    showCustomSnackBar(
                      context: context,
                      type: NotificationType.error,
                      text: "$err",
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSpacer() => const SizedBox(height: 30);

  void updateControllersData(UserProvider userProvider) {
    User user = userProvider.user ?? User(wallet_balance: 0);
    firstNameController.text = user.firstname ?? "";
    lastNameController.text = user.lastname ?? "";
    usernameController.text = user.username ?? "";
    emailController.text = user.email ?? "";
    phoneNoController.text = user.phone_number ?? "";
    selectedCountry = user.country;

    setState(() {});
    //
  }

  Future<void> selectCountry() async {
    Country? res = await showCustomBottomSheet(
        context: context, screen: const SelectCountry());
    if (res != null) {
      selectedCountry = res;
      setState(() {});
    }
  }

  Future<void> updateProfileImage(
      ImageSource imageSource, UserProvider userProvider) async {
    Navigator.pop(context);
    try {
      File? file = await selectImage(imageSource);
      if (file == null) return;
      setState(() => imageUploading = true);
      String msg = await UserHelper.updateProfileAvatar(file);

      await userProvider.updateProfileInformation();
      imageUploading = false;
      setState(() {});
      showCustomSnackBar(
        context: context,
        text: msg,
        type: NotificationType.success,
      );
    } catch (e) {
      setState(() => imageUploading = false);
      showCustomSnackBar(context: context, text: e.toString());
    }
  }
}

class ProfileImageBuilder extends StatelessWidget {
  const ProfileImageBuilder(
      {super.key, required this.isLoading, this.imageUrl});

  final bool isLoading;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
            color: ColorManager.kTextColor, strokeWidth: 2.4),
      );
    } else if (imageUrl!.startsWith('null')) {
      return Container(
        height: 107,
        width: 107,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image:
                    Image.asset(height: 107, width: 107, ImageManager.kUserIcon)
                        .image)),
      );
    } else
      return ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: loadNetworkImage(
          imageUrl ?? ImageManager.kUserIcon,
          width: 107,
          height: 107,
          fit: BoxFit.fill,
          strokeWidth: 2.4,
          strokeWidthColor: ColorManager.kTextColor,
        ),
      );
  }
}
