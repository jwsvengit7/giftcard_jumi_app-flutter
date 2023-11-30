import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/helpers/user_helper.dart';
import 'package:jimmy_exchange/core/model/saved_bank.dart';
import 'package:jimmy_exchange/core/providers/user_provider.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/resources/values_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_appbar.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_back_button.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_scaffold.dart';
import 'package:provider/provider.dart';

import '../../../core/enum.dart';
import '../../resources/styles_manager.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/spacer.dart';

class RemoveBankView extends StatefulWidget {
  final SavedBank param;

  const RemoveBankView({super.key, required this.param});

  @override
  State<RemoveBankView> createState() => _RemoveBankViewState();
}

class _RemoveBankViewState extends State<RemoveBankView> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CustomScaffold(
        appBar: CustomAppBar(
            leading: Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomBackButton(),
            ),
            title: Text("Bank Information",
                style:
                    get16TextStyle(fontWeight: FontWeight.w700, fontSize: 20))),
        body: ListView(
          padding: const EdgeInsets.only(
              left: AppPadding.p16, right: AppPadding.p16),
          children: [
            const SettingsPageTopSpacer(),
            //

            CustomInputField(
              formHolderName: "Bank",
              hintText: "Select Bank",
              textEditingController:
                  TextEditingController(text: widget.param.bank?.name),
              enabled: false,
            ),

            //
            const SizedBox(height: 24),
            CustomInputField(
              textEditingController:
                  TextEditingController(text: widget.param.account_number),
              formHolderName: "Account Number",
              hintText: "Account Number",
              enabled: false,
            ),

            //
            const SizedBox(height: 24),
            CustomInputField(
              textEditingController:
                  TextEditingController(text: widget.param.account_name),
              formHolderName: "Account Name",
              hintText: "Account Name",
              enabled: false,
            ),

            SizedBox(height: isSmallScreen(context) ? 130 : 250),

            CustomBtn(
              text: "Remove",
              onTap: () async {
                setState(() => loading = true);

                try {
                  String msg =
                      await UserHelper.deleteSavedBank(widget.param.id ?? "");

                  await Provider.of<UserProvider>(context, listen: false)
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
              },
              loading: loading,
              isActive: true,
            )
          ],
        ),
      ),
    );
  }
}
