import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jimmy_exchange/core/helpers/transaction_helper.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_appbar.dart';

import 'package:provider/provider.dart';

import '../../../core/enum.dart';
import '../../../core/model/asset_transaction.dart';
import '../../../core/providers/txn_history_provider.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/utils/utils.dart';
import '../../resources/color_manager.dart';
import '../../resources/route_arg/sell_crypto_details_arg.dart';
import '../../resources/styles_manager.dart';
import '../../resources/values_manager.dart';
import '../../widgets/custom_btn.dart';
import '../../widgets/custom_scaffold.dart';
import '../custom_bottom_sheet.dart';
import '../custom_snackbar.dart';
import '../modals/enter_transaction_pin.dart';
import '../popups/confirmation_popup.dart';
import '../popups/index.dart';
import '../popups/success_failed_popup.dart';

class ConfirmCryptoTxn extends StatefulWidget {
  final ConfirmCryptoTxnArg param;
  const ConfirmCryptoTxn({Key? key, required this.param}) : super(key: key);

  @override
  State<ConfirmCryptoTxn> createState() => _ConfirmCryptoTxnState();
}

class _ConfirmCryptoTxnState extends State<ConfirmCryptoTxn> {
  final TextEditingController controller1 = new TextEditingController();
  File? file;
  bool imageUploading = false;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CustomScaffold(
        backgroundColor: ColorManager.kWhite,
        appBar: CustomAppBar(
          title: Text(
              "${capitalizeFirstString(widget.param.trade_type)} Giftcard",
              style: get20TextStyle()),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 46),
          height: size.height - pageMargin,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Text(
                      "Upload transaction proof",
                      style: get16TextStyle()
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                        onTap: () async {
                          await showDialogPopup(
                            context,
                            ConfirmationPopup(
                              title: "Select Image",
                              desc:
                                  "Please take a picture of your transaction history or upload a picture from your gallery to complete your transaction.",
                              cancelText: "Camera",
                              proceedText: "Gallery",
                              onCancel: () async {
                                try {
                                  file = await selectImage(ImageSource.camera);
                                  if (file != null) {
                                    setState(() {});
                                    Navigator.pop(context);
                                  }
                                } catch (e) {
                                  showCustomSnackBar(
                                      context: context,
                                      text: e.toString(),
                                      type: NotificationType.warning);
                                }
                              },
                              onProceed: () async {
                                try {
                                  file = await selectImage(ImageSource.gallery);
                                  if (file != null) {
                                    setState(() {});
                                    Navigator.pop(context);
                                  }
                                } catch (e) {
                                  showCustomSnackBar(
                                      context: context,
                                      text: e.toString(),
                                      type: NotificationType.warning);
                                }

                                // if (file != null) setState(() {});
                              },
                            ),
                          );
                        },
                        child: file != null
                            ? SizedBox(
                                height: size.height * 0.5,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Image.file(file!),
                                ),
                              )
                            : Image.asset(ImageManager.kImagePicker,
                                height: 174)),
                    const SizedBox(height: 24),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              CustomBtn(
                isActive: true,
                loading: imageUploading,
                text: widget.param.trade_type == "sell"
                    ? "I have transferred asset"
                    : "Submit",
                onTap: () async {
                  try {
                    if (file == null) {
                      showCustomSnackBar(
                        context: context,
                        text: "Please select an image",
                        type: NotificationType.warning,
                      );
                      return;
                    }

                    String? transaction_pin = await showCustomBottomSheet(
                        isDismissible: true,
                        context: context,
                        screen: const EnterTransactionPin());

                    if (transaction_pin == null) return;

                    setState(() => imageUploading = true);
                    AssetTransaction atxn =
                        await widget.param.createTransaction(transaction_pin);

                    String imageUrl = await uploadImageToCloudinary(file!);

                    await TransactionHelper.uploadCryptoTransactionProof(
                        assetTransactionId: atxn.id ?? "", imageUrl);

                    await Provider.of<TxnHistoryProvider>(context,
                            listen: false)
                        .updateCryptoTxnHistory();
                    await updateTxnHistory(context);

                    showDialogPopup(
                      context,
                      SuccessFailedPopup(
                        isSuccess: true,
                        title: "Success",
                        desc:
                            "Your trade is being processed, and you will be credited once it has been approved by the admin.",
                        proceedText: "Done",
                        onProceed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    );

                    await userProvider.updateProfileInformation();
                    setState(() => imageUploading = false);
                  } catch (e) {
                    setState(() => imageUploading = false);
                    await showDialogPopup(
                      context,
                      SuccessFailedPopup(
                        isSuccess: false,
                        title: "Unsuccessful\nTransaction",
                        desc: "$e",
                        proceedText: "Retry Transaction",
                        onProceed: () {
                          Navigator.pop(context);
                        },
                        cancelText: "Crypto",
                        onCancel: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
