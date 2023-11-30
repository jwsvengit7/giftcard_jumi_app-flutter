import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/core/constants.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_back_button.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../resources/styles_manager.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/settings/tab.dart';
import '../../widgets/spacer.dart';

class SupportView extends StatelessWidget {
  const SupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
          leading: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CustomBackButton(),
          ),
          title: Text("Support",
              style:
                  get16TextStyle(fontWeight: FontWeight.w700, fontSize: 20))),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          height: 370.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
              color: ColorManager.kGray11,
              borderRadius: BorderRadius.circular(8.r)),
          child: Column(
            children: [
              const SettingsPageTopSpacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Call our help line",
                      style: get16TextStyle().copyWith(
                          fontWeight: FontWeight.w400,
                          color: ColorManager.kGray8),
                    ),
                  ),
                  navigatorTab(
                    height: 50,
                    paddingTop: 8,
                    borderColor:
                        ColorManager.kSecurityDividerGrey.withOpacity(0.50),
                    rightWidget: Image(image: AssetImage(ImageManager.kCallIcon)),
                    name: "+2349012234131",
                    onTap: () async {
                      Uri url = Uri.parse("tel:${Constants.kPhoneNo}");
                      launchUrl(url).then((value) {}).catchError((onError) {});
                    },
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20.h, left: 8.w),
                    child: Text(
                      "Chat with us on Whatsapp",
                      style: get16TextStyle().copyWith(
                          fontWeight: FontWeight.w400,
                          color: ColorManager.kGray8),
                    ),
                  ),
                  navigatorTab(
                    height: 50,
                    paddingTop: 8,
                    borderColor:
                        ColorManager.kSecurityDividerGrey.withOpacity(0.50),
                    rightWidget: Image(image: AssetImage(ImageManager.kWhatsAppIcon)),
                    name: "+2349012234131",
                    onTap: () async {
                      Uri url = Uri.parse(Constants.kWhatsAppContact);
                      await launchUrl(url)
                          .then((value) {})
                          .catchError((onError) {});
                    },
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20.h, left: 8.w),
                    child: Text(
                      "Send Us a Mail",
                      style: get16TextStyle().copyWith(
                          fontWeight: FontWeight.w400,
                          color: ColorManager.kGray8),
                    ),
                  ),
                  navigatorTab(
                    height: 50,
                    paddingTop: 8,
                    borderColor: ColorManager.kGray11.withOpacity(0.50),
                    rightWidget: Image(image: AssetImage(ImageManager.kMail)),
                    name: "Likesolomon2@gmail.com",
                    onTap: () async {
                      Uri url = Uri.parse("mailto:${Constants.kEmail}");
                      launchUrl(url).then((value) {}).catchError((onError) {});
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
