import 'package:flutter/material.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';

class GiftcardPopup extends StatefulWidget {
  final String? title;
  final String? desc;
  final Function? onCancel;
  final String? cancelText;
  final String? proceedText;
  final Function? onProceed;

  const GiftcardPopup({
    Key? key,
    this.title,
    this.desc,
    this.onCancel,
    this.onProceed,
    this.cancelText,
    this.proceedText,
  }) : super(key: key);

  @override
  _GiftcardPopupState createState() => _GiftcardPopupState();
}

class _GiftcardPopupState extends State<GiftcardPopup> {
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
          height: 350,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 16),
                child: Image.asset(ImageManager.kChecked, width: 102),
              ),

              // Desc
              Text("Success",
                  textAlign: TextAlign.center, style: get24TextStyle()),

              //
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 30),
                child: Text(
                  "Your trade is being processed, and you will be credited once it has been approved. ",
                  textAlign: TextAlign.center,
                  style: get14TextStyle().copyWith(fontWeight: FontWeight.w300),
                ),
              ),

              CustomBtn(
                isActive: true,
                loading: false,
                text: "Monitor Transaction Status",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 17),

              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text(
                  "Return to Dashboard",
                  style: get16TextStyle().copyWith(
                    fontWeight: FontWeight.w300,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
              //
            ],
          ),
        ),
      ),
    );
  }
}
