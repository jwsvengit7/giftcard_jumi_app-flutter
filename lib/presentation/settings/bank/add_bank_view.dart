import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/constants.dart';
import 'package:jimmy_exchange/core/helpers/user_helper.dart';
import 'package:jimmy_exchange/core/model/bank.dart';
import 'package:jimmy_exchange/core/providers/user_provider.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/resources/values_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_appbar.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_back_button.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_scaffold.dart';
import 'package:provider/provider.dart';

import '../../../core/enum.dart';
import '../../resources/image_manager.dart';
import '../../resources/styles_manager.dart';
import '../../widgets/custom_bottom_sheet.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/modals/select_bank.dart';
import '../../widgets/spacer.dart';

class AddBankView extends StatefulWidget {
  const AddBankView({super.key});

  @override
  State<AddBankView> createState() => _AddBankViewState();
}

class _AddBankViewState extends State<AddBankView> {
  final TextEditingController bankController = new TextEditingController();
  final TextEditingController accountNoController = new TextEditingController();
  final TextEditingController accountNameController =
      new TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Bank? selectedBank;
  bool verified = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    bool isNGAUser = userProvider.user?.country?.name == Constants.kNigeriaName;

    // Nigeria

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CustomScaffold(
        appBar: CustomAppBar(leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CustomBackButton(),
        ),
            title: Text("Add Bank",
                style:
                get16TextStyle(fontWeight: FontWeight.w700, fontSize: 20))),
        body: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.only(
              left: AppPadding.p16, right: AppPadding.p16),
          children: [
            //
            const SettingsPageTopSpacer(),

            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                if (loading == true) return;
                Bank? res = await showCustomBottomSheet(
                    context: context, screen: const SelectBank());
                if (res != null) {
                  selectedBank = res;
                  accountNameController.text = "";
                  verified = false;
                  setState(() {});
                }
              },
              child: IgnorePointer(
                child: CustomInputField(
                  formHolderName: "Bank",
                  hintText: "Select Bank",
                  textEditingController:
                      TextEditingController(text: selectedBank?.name),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 13),
                    child: Image.asset(
                      ImageManager.kArrowDown,
                      width: 16,
                    ),
                  ),
                ),
              ),
            ),

            //
            const SizedBox(height: 24),
            CustomInputField(
              textEditingController: accountNoController,
              formHolderName: "Account Number",
              hintText: "Account Number",
              textInputAction: TextInputAction.next,
              maxLength: isNGAUser ? 10 : null,
              counterText: "",
              textInputType:
                  isNGAUser ? TextInputType.number : TextInputType.text,
              enabled: !loading,
              onChanged: (e) {
                accountNameController.text = "";
                verified = false;
                setState(() {});
                if (e.length == 10 && isNGAUser && selectedBank != null) {
                  verifyBankInfo().then((_) {}).catchError((_) {});
                }
              },
              validator: (val) =>
                  val!.isEmpty ? "Account Number cannot be empty !!" : null,
            ),

            //
            const SizedBox(height: 24),
            CustomInputField(
              textEditingController: accountNameController,
              formHolderName: "Account Name",
              hintText: "Account Name",
              enabled: isNGAUser ? false : true,
              onTap: () {},
            ),

            SizedBox(height: isSmallScreen(context) ? 130 : 250),

            CustomBtn(
              text: verified ? "Add" : "Verify",
              onTap: () async {
                try {
                  if (!verified) {
                    await verifyBankInfo();
                    return;
                  }

                  //
                  setState(() => loading = true);
                  String msg = await UserHelper.storeSavedBank(
                      bank_id: selectedBank?.id ?? "",
                      account_number: accountNoController.text);

                  await userProvider
                      .updateAddedBanks()
                      .then((_) {})
                      .catchError((_) {});

                  showCustomSnackBar(
                    context: context,
                    text: msg,
                    type: NotificationType.success,
                  );
                  Navigator.pop(context);
                } catch (e) {
                  showCustomSnackBar(
                      context: context,
                      text: "$e",
                      type: NotificationType.error);
                  setState(() => loading = false);
                }

                //
              },
              loading: loading,
              isActive: true,
            )
          ],
        ),
      ),
    );
  }

  Future<void> verifyBankInfo() async {
    setState(() => loading = true);
    accountNameController.text = await UserHelper.verifySavedBank(
            bank_id: selectedBank?.id ?? "",
            account_number: accountNoController.text)
        .then((value) => value)
        .catchError((e) {
      showCustomSnackBar(
          context: context, text: "$e", type: NotificationType.error);
      setState(() => loading = false);
    });

    loading = false;
    verified = true;
    setState(() {});
  }
}
