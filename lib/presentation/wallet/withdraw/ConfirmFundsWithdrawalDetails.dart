import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/core/enum.dart';
import 'package:jimmy_exchange/core/helpers/transaction_helper.dart';
import 'package:jimmy_exchange/core/model/FundsWithdrawal.dart';
import 'package:jimmy_exchange/core/providers/user_provider.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_appbar.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_back_button.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_bottom_sheet.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_scaffold.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_snackbar.dart';
import 'package:jimmy_exchange/presentation/widgets/popups/index.dart';
import 'package:jimmy_exchange/presentation/widgets/popups/success_failed_popup.dart';
import 'package:jimmy_exchange/presentation/widgets/saved_bank.dart';
import 'package:provider/provider.dart';

import '../../widgets/modals/enter_transaction_pin.dart';

class ConfirmFundsWithdrawalDetails extends StatefulWidget {
  final FundsWithdrawal? params;
  final String? name;

  const ConfirmFundsWithdrawalDetails({super.key, this.params, this.name});

  @override
  State<ConfirmFundsWithdrawalDetails> createState() =>
      _ConfirmFundsWithdrawalDetailsState();
}

class _ConfirmFundsWithdrawalDetailsState
    extends State<ConfirmFundsWithdrawalDetails> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return CustomScaffold(
      backgroundColor: ColorManager.kWhite,
      appBar: CustomAppBar(
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CustomBackButton(),
        ),
        title: Text(widget.name ?? '', style: get20TextStyle()),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 39.0.h,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              decoration: BoxDecoration(
                  color: ColorManager.kGray11,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: ColorManager.kBorder.withOpacity(0.30))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Withdrawal Amount',
                    style: get14TextStyle().copyWith(
                        fontWeight: FontWeight.w400,
                        color: ColorManager.kFormHintText),
                  ),
                  SizedBox(
                    height: 7.0.h,
                  ),
                  Text(
                    formatCurrency(int.parse(widget.params!.selectedAmount!)),
                    style: get16TextStyle().copyWith(
                        fontWeight: FontWeight.w400,
                        color: ColorManager.kBlack),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 19.0.h,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              decoration: BoxDecoration(
                  color: ColorManager.kGray11,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: ColorManager.kBorder.withOpacity(0.30))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payout Account',
                    style: get16TextStyle().copyWith(
                        fontWeight: FontWeight.w500,
                        color: ColorManager.kPrimaryBlack),
                  ),
                  SizedBox(
                    height: 17.0.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.params?.savedBank?.account_name! ?? 'NA'}',
                              style: get16TextStyle().copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: ColorManager.kBlack),
                            ),
                            SizedBox(
                              height: 7.h,
                            ),
                            BankNameNumberCapsule(
                                current: widget.params!.savedBank!)
                          ]),
                      Image.asset(ImageManager.kIconOirEditedIt)
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 34.h),
              child: CustomBtn(
                isActive: true,
                loading: loading,
                text: "Withdraw",
                onTap: () async {
                  try {
                    num _parsedAmount =
                        num.tryParse(widget.params!.selectedAmount!) ?? 0;
                    if (_parsedAmount < 1000) {
                      throw "Minimum withdrawal is " +
                          formatCurrency(1000, code: "NGN");
                    }

                    String? transaction_pin = await showCustomBottomSheet(
                        isDismissible: true,
                        context: context,
                        screen: EnterTransactionPin(width: 94.0.w));

                    if (transaction_pin == null) return;

                    setState(() => loading = true);

                     TransactionHelper.requestWithdrawal(
                      user_bank_account_id: widget.params!.savedBank?.id ?? "",
                      amount: widget.params!.selectedAmount!,
                      transaction_pin: transaction_pin,
                    ).then((msg) async {
                      setState(() => loading = false);
                      await userProvider
                          .updateProfileInformation()
                          .then((_) {})
                          .catchError((_) {});
                      //
                      await showDialogPopup(
                        context,
                        SuccessFailedPopup(
                          isSuccess: true,
                          title: "Success",
                          desc: msg.$1,
                          proceedText: "Done",
                          walletTxnHistory: msg.$2,
                          onProceed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        ),
                      );

                      //
                    }).catchError((e) async {
                      setState(() => loading = false);
                      await showDialogPopup(
                        context,
                        SuccessFailedPopup(
                          isSuccess: false,
                          title: "Unsuccessful\nTransaction",
                          desc: "$e",
                          proceedText: "Retry withdrawal",
                          onProceed: () {
                            Navigator.pop(context);
                          },
                          cancelText: "Return to Wallet",
                          onCancel: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    });
                  } catch (err) {
                    setState(() => loading = false);
                    showCustomSnackBar(
                      context: context,
                      text: "$err",
                      type: NotificationType.error,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
