import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/core/helpers/transaction_helper.dart';
import 'package:jimmy_exchange/core/model/FundsWithdrawal.dart';
import 'package:jimmy_exchange/core/model/country.dart';
import 'package:jimmy_exchange/core/model/giftcard_category.dart';
import 'package:jimmy_exchange/core/model/giftcard_product.dart';
import 'package:jimmy_exchange/core/model/saved_bank.dart';
import 'package:jimmy_exchange/core/providers/user_provider.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/resources/route_arg/giftcard_arg.dart';
import 'package:jimmy_exchange/presentation/resources/routes_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/resources/values_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_back_button.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_scaffold.dart';
import 'package:provider/provider.dart';

import '../../../../core/enum.dart';
import '../../../../core/utils/validators.dart';
import '../../resources/color_manager.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_bottom_sheet.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/modals/enter_transaction_pin.dart';
import '../../widgets/popups/index.dart';
import '../../widgets/popups/success_failed_popup.dart';

class WithdrawFundView extends StatefulWidget {
  const WithdrawFundView({super.key});

  @override
  State<WithdrawFundView> createState() => _WithdrawFundViewState();
}

class _WithdrawFundViewState extends State<WithdrawFundView> {
  final TextEditingController amountController = new TextEditingController();

  SavedBank? selectedBank;

  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  bool loading = false;

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   UserProvider userProvider =
    //       Provider.of<UserProvider>(context, listen: false);
    // });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CustomScaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          leading: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CustomBackButton(),
          ),
          title: Text("Withdraw Funds", style: get20TextStyle()),
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
            children: [
              // TOP BAR
              SizedBox(height: 20.h),

              // // // //

              CustomInputField(
                textEditingController: amountController,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.number,
                hintText: "Enter Amount",
                formHolderName: "Withdraw Amount?",
                validator: (val) => Validator.validateAmountField(
                    fieldName: "Amount", input: val),
              ),
              buildSpacer(),

              IgnorePointer(
                ignoring: !(_formKey.currentState?.validate() ?? false),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    List<SellGiftCard2Arg>? arg = [
                      SellGiftCard2Arg(
                          giftCardCategory: GiftcardCategory(),
                          giftCardProduct: GiftcardProduct(),
                          card_type: '',
                          country: Country(),
                          quantity: 0,
                          amount: 0,
                          comment: '',
                          giftCardFiles: [],
                          oneUnitPayable: 0,
                          fundsWithdrawal: FundsWithdrawal(
                              selectedAmount: amountController.text,
                              isWallet: true))
                    ];

                    Navigator.pushNamed(
                        context, RoutesManager.selectBankAccount,
                        arguments: arg);
                  },
                  child: Container(
                    height: 51.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: ColorManager.kPrimaryBlue,
                        borderRadius: BorderRadius.circular(5.r)),
                    child: Text(
                      'Proceed',
                      style: get16TextStyle().copyWith(
                          color: ColorManager.kWhite,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
              buildSpacer(),

              //

              Padding(
                padding: EdgeInsets.only(
                    top: isSmallScreen(context) ? 210.h : 280.h),
                child: CustomBtn(
                  isActive: true,
                  loading: loading,
                  text: "Withdraw",
                  onTap: () async {
                    try {
                      if (!(_formKey.currentState?.validate() ?? false) ||
                          selectedBank == null) {
                        throw "Please ensure that all input are filled correctly.";
                      }
                      num _parsedAmount =
                          num.tryParse(amountController.text) ?? 0;
                      if (_parsedAmount < 1000) {
                        throw "Minimum withdrawal is " +
                            formatCurrency(1000, code: "NGN");
                      }

                      String? transaction_pin = await showCustomBottomSheet(
                          isDismissible: true,
                          context: context,
                          screen: const EnterTransactionPin());

                      if (transaction_pin == null) return;

                      setState(() => loading = true);

                      await TransactionHelper.requestWithdrawal(
                        user_bank_account_id: selectedBank?.id ?? "",
                        amount: amountController.text,
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
                            walletTxnHistory: msg.$2,
                            proceedText: "Done",
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

              //
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSpacer() => const SizedBox(height: 30);

// Future<void> selectBank() async {
//   SavedBank? res = await showCustomBottomSheet(
//       context: context, screen: SelectSavedBank());
//   if (res != null) {
//     selectedBank = res;
//     setState(() {});
//   }
// }
}
