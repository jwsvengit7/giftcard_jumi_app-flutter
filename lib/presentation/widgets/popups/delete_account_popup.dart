import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/core/enum.dart';
import 'package:jimmy_exchange/core/helpers/auth_helper.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_snackbar.dart';

class DeleteAccountPopup extends StatefulWidget {
  final bool isSuccess;
  final String? title;
  final String? desc;
  final String? cancelText;
  final String? proceedText;

  const DeleteAccountPopup({
    Key? key,
    this.title,
    this.desc,
    this.cancelText,
    this.proceedText,
    required this.isSuccess,
  }) : super(key: key);

  @override
  _DeleteAccountPopupState createState() => _DeleteAccountPopupState();
}

class _DeleteAccountPopupState extends State<DeleteAccountPopup> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        backgroundColor: ColorManager.kWhite,
        content: SizedBox(
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Desc
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.title ?? "title",
                  style: get20TextStyle().copyWith(
                      fontWeight: FontWeight.w700, color: ColorManager.kGray9),
                ),
              ),

              //
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 30),
                child: SizedBox(

                  child: Text(
                    widget.desc ?? "description",
                    style: get14TextStyle().copyWith(
                        color: ColorManager.kTextColor,
                        fontWeight: FontWeight.w400,height: 2),
                  ),
                ),
              ),

              const SizedBox(height: 2.5),
              CustomBtn(
                padding: EdgeInsets.symmetric(vertical: 14),
                isActive: true,
                loading: loading,
                backgroundColor: ColorManager.kAccountDeletion,
                textColor: ColorManager.kWhite,
                text: "Delete Account",
                onTap: () async {
                  try {
                    setState(() => loading = true);
                    //
                    await AuthHelper.deleteAccount();
                    AuthHelper.logout(context, deactivateTokenAndRestart: true);
                    //
                  } catch (e) {
                    Navigator.pop(context);
                    showCustomSnackBar(
                      context: context,
                      text: e.toString(),
                      type: NotificationType.error,
                    );
                  }
                },
              ),
              SizedBox(height: 10.h),
              widget.cancelText != null
                  ? GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: ColorManager.kGray4,
                              borderRadius: BorderRadius.circular(8.r)),
                          height: 51.h,
                          width: 355.w,
                          child: Text(
                            'Cancel',
                            style: get14TextStyle()
                                .copyWith(color: ColorManager.kWhite),
                          )),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
