import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/routes_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_back_button.dart';
import 'package:jimmy_exchange/presentation/widgets/popups/image_preview_popup.dart';

import '../../../core/enum.dart';
import '../../../core/model/saved_bank.dart';
import '../../../core/utils/utils.dart';
import '../../resources/color_manager.dart';
import '../../resources/route_arg/giftcard_arg.dart';
import '../../resources/styles_manager.dart';
import '../../resources/values_manager.dart';
import '../../widgets/custom_bottom_sheet.dart';
import '../../widgets/custom_btn.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/modals/select_saved_bank.dart';
import '../../widgets/popups/index.dart';

class SellGiftcard2View extends StatefulWidget {
  final List<SellGiftCard2Arg> param;
  const SellGiftcard2View({Key? key, required this.param}) : super(key: key);

  @override
  State<SellGiftcard2View> createState() => _SellGiftcard2ViewState();
}

class _SellGiftcard2ViewState extends State<SellGiftcard2View> {
  bool isLoading = false;
  ScrollController scrollController = ScrollController();

  SavedBank? selectedBank;
  List<File> imageFiles = [];
  bool imageSelected = false;

  int totalImageCount = 0;
  int totalUploadedImageCount = 0;
  final double selectedImageHeight = 80;
  ScrollController gridsController = ScrollController();

  @override
  void initState() {
    updateTotalImageCount();
    super.initState();
  }

  void updateTotalImageCount() {
    widget.param.forEach((element) {
      totalImageCount = element.giftCardFiles.length + totalImageCount;
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: EdgeInsets.only(
              top: 50.h, left: AppPadding.p16, right: AppPadding.p16),
          child: Column(children: [
            Row(
              children: [
                CustomBackButton(),
                SizedBox(
                  width: 100.w,
                ),
                Text("Sell Giftcard",
                    style:
                        get20TextStyle().copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.only(top: isSmallScreen(context) ? 30 : 46),
                children: [
                  // Text(
                  //   "Bank Details",
                  //   style: get16TextStyle()
                  //       .copyWith(fontSize: 18, fontWeight: FontWeight.w500),
                  // ),
                  // const SizedBox(height: 20),
                  // GestureDetector(
                  //   behavior: HitTestBehavior.translucent,
                  //   onTap: () async => selectBank(),
                  //   child: selectedBank != null
                  //       ? buildBankCard(selectedBank!, () async => selectBank())
                  //       : IgnorePointer(
                  //           child: CustomInputField(
                  //             formHolderName: "Select Existing Bank Account",
                  //             hintText: "Click to select bank account to use",
                  //             textEditingController: TextEditingController(
                  //               text: selectedBank?.account_number,
                  //             ),
                  //           ),
                  //         ),
                  // ),
                  // const SizedBox(height: 32),
                  // Text(
                  //   "Confirm Trades",
                  //   style: get16TextStyle()
                  //       .copyWith(fontSize: 18, fontWeight: FontWeight.w500),
                  // ),
                  // const SizedBox(height: 20),
                  // for (int i = 0; i < widget.param.length; i++)
                  //   CardDropDownWidgt(
                  //     arg: widget.param[i],
                  //     onClear: (e) {
                  //       widget.param.removeWhere((element) => element == e);
                  //       setState(() {});
                  //     },
                  //   ),

                  buildDetailsCollector(
                    size,
                  ),

                  const SizedBox(height: 20),
                  isLoading
                      ? Row(
                          children: [
                            Text(
                                "Uploading image $totalUploadedImageCount of $totalImageCount",
                                style: get12TextStyle()),
                            const SizedBox(width: 10),
                            SizedBox(
                              height: 12,
                              width: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  ColorManager.kPrimaryBlack,
                                ),
                              ),
                            )
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            Container(
              color: ColorManager.kWhite,
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
                    loading: isLoading,
                    text: "Sell Giftcard",
                    onTap: () async {
                      widget.param.first.giftCardFiles.addAll(imageFiles);
                      Navigator.pushNamed(
                          context, RoutesManager.selectBankAccount,
                          arguments: widget.param);

                      // print("hellow");
                      // try {
                      //   if (selectedBank == null) {
                      //     throw "Please select bank preferred bank";
                      //   }

                      //   bool? proceed = await showCustomBottomSheet(
                      //     context: context,
                      //     screen: ConfirmGiftcardSell(
                      //       name: "Confirm Your Purchase Details",
                      //       param: {
                      //         "giftCards": widget.param,
                      //         "selectedBank": selectedBank
                      //       },
                      //     ),
                      //   );

                      //   if (proceed == true) {
                      //     String? transaction_pin = await showCustomBottomSheet(
                      //         isDismissible: true,
                      //         context: context,
                      //         screen: const EnterTransactionPin());

                      //     if (transaction_pin == null) {
                      //       return;
                      //     }
                      //     setState(() => isLoading = true);

                      //     for (final SellGiftcard2Arg el in widget.param) {
                      //       try {
                      //         // THIS IS A POOR IMPLEMENTATION BUT THAT'S WHAT THE CLIENT WANTS..
                      //         List<String> imgLinks = [];

                      //         for (File file in el.giftcardFiles) {
                      //           String _res =
                      //               await uploadImageToCloudinary(file);
                      //           imgLinks.add(_res);

                      //           setState(() {
                      //             totalUploadedImageCount =
                      //                 totalUploadedImageCount + 1;
                      //           });
                      //         }

                      //         await TransactionHelper.createGiftcardSale(
                      //           giftcard_product_id:
                      //               el.giftcardProduct.id ?? "",
                      //           user_bank_account_id: selectedBank?.id ?? "",
                      //           card_type: el.card_type,
                      //           amount: el.amount.toString(),
                      //           quantity: el.quantity.toString(),
                      //           comment: el.comment,
                      //           imgs: imgLinks,
                      //           virtualCode: [],
                      //           virtualPin: [],
                      //           transaction_pin: transaction_pin,
                      //           upload_type: "media",
                      //         );
                      //       } catch (err) {
                      //         throw "Error:: ${err.toString()}";
                      //       }
                      //     }

                      //     await Provider.of<TxnHistoryProvider>(context,
                      //             listen: false)
                      //         .updateGiftcardTxnHistory();
                      //     await updateTxnHistory(context);

                      //     showDialogPopup(
                      //       context,
                      //       SuccessFailedPopup(
                      //         isSuccess: true,
                      //         title: "Success",
                      //         desc:
                      //             "Your trade is being processed, and you will be credited once it has been approved by the admin.",
                      //         proceedText: "Done",
                      //         onProceed: () {
                      //           Navigator.pop(context);
                      //           Navigator.pop(context);
                      //           Navigator.pop(context);
                      //         },
                      //       ),
                      //     );
                      //     setState(() => isLoading = false);
                      //   }

                      //   //.catchError((e) async {
                      //   //   showDialogPopup(
                      //   //     context,
                      //   //     SuccessFailedPopup(
                      //   //       isSuccess: false,
                      //   //       title: "Unsuccessful\nTransaction",
                      //   //       desc: truncateWithEllipsis(
                      //   //         60,
                      //   //         e.toString(),
                      //   //       ),
                      //   //       proceedText: "Retry Transaction",
                      //   //       onProceed: () {
                      //   //         Navigator.pop(context);
                      //   //       },
                      //   //       cancelText: "Giftcard",
                      //   //       onCancel: () {
                      //   //         Navigator.pop(context);
                      //   //         Navigator.pop(context);
                      //   //         Navigator.pop(context);
                      //   //       },
                      //   //     ),
                      //   //   );
                      //   // });
                      //   // }
                      // } catch (e) {
                      //   totalUploadedImageCount = 0;
                      //   isLoading = false;
                      //   setState(() {});
                      //   showCustomSnackBar(
                      //     context: context,
                      //     text: e.toString(),
                      //     type: NotificationType.error,
                      //   );
                      // }
                    },
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Future<void> selectBank() async {
    SavedBank? res = await showCustomBottomSheet(
        context: context, screen: SelectSavedBank());
    if (res != null) {
      selectedBank = res;
      setState(() {});
    }
  }

  Widget buildDetailsCollector(
    Size size,
  ) {
    return imageSelected
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UploadImageWidget(
                      onTap: () {
                        chooseImages(widget.param.first.quantity);
                      },
                      title: "Upload Another Image"),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: buildImagePreviewHeight(),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2,
                      mainAxisSpacing: 10.h,
                      crossAxisSpacing: 10.w),
                  padding: const EdgeInsets.only(top: 0),
                  controller: gridsController,
                  itemCount: imageFiles.length,
                  itemBuilder: (_, int i) {
                    return InkWell(
                      onTap: () {
                        showDialogPopup(
                          context,
                          ImagePreviewPopup(
                            imageUrl: imageFiles[i].path,
                            file: imageFiles[i],
                            imageType: ImageType.file,
                          ),
                          barrierDismissible: true,
                        );
                      },
                      child: Image.file(
                        imageFiles[i],
                        // fit: BoxFit.contain,
                        // height: selectedImageHeight,
                        width: 78.w,
                      ),
                    );
                  },
                ),
              ),
              // Row(
              //   children: [
              //     for (int index = 0; index < imageFiles.length; index++)
              //       buildImagePreview(imageFiles[index])
              //   ],
              // )
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 12),
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(16),
              //     child: Image.file(imageFiles[index]),
              //   ),
              // )
            ],
          )
        : GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () async => await chooseImages(widget.param.first.quantity),
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Upload Giftcard Image",
                    textAlign: TextAlign.left,
                    style:
                        get16TextStyle().copyWith(fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 24.h),
                  UploadImageWidget(
                      onTap: () {
                        chooseImages(widget.param.first.quantity);
                      },
                      title: "Upload Image"),
                ],
              ),
            ),
          );
  }

  Future<void> chooseImages(int quantity) async {
    try {
      List<File>? files = await selectMultipleImages(ImageSource.gallery);
      if (files == null) throw "Please select $quantity image(s)";
      if (files.length >= quantity) {
        imageFiles = files;
        imageSelected = true;
        setState(() {});
      } else {
        throw "Please select $quantity or more image(s)";
      }
    } catch (e) {
      showCustomSnackBar(
        context: context,
        text: e.toString(),
        type: NotificationType.error,
      );
    }
  }

  double buildImagePreviewHeight() {
    double hg = imageFiles.length / 3;
    if (hg < 1) return selectedImageHeight;

    hg = hg.ceilToDouble();
    return (selectedImageHeight * hg);
  }
}

class UploadImageWidget extends StatelessWidget {
  const UploadImageWidget(
      {required this.onTap, required this.title, super.key});
  final Function() onTap;
  final String title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        dashPattern: [8],
        strokeWidth: 2,
        strokeCap: StrokeCap.round,
        color: ColorManager.kPrimaryBlue.withOpacity(0.3),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          width: 395.w,
          height: 81.h,
          decoration: BoxDecoration(
            color: ColorManager.kUpdateBackground,
          ),
          child: Row(children: [
            Image.asset(
              ImageManager.kGallery,
              width: 20.w,
              height: 20.w,
            ),
            SizedBox(width: 10.w),
            Text(
              title,
              textAlign: TextAlign.left,
              style: get16TextStyle().copyWith(
                  fontWeight: FontWeight.w500,
                  color: ColorManager.kPrimaryBlue,
                  fontSize: 14.sp),
            ),
            const Spacer(),
            Image.asset(
              ImageManager.kUploadFile,
              width: 17.5.w,
              height: 17.5.w,
            )
          ]),
        ),
      ),
    );
  }
}
