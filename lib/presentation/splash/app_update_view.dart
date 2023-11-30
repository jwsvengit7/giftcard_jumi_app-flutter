import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import '../resources/color_manager.dart';
import '../resources/styles_manager.dart';
import '../resources/values_manager.dart';
import '../widgets/custom_btn.dart';
import '../widgets/custom_scaffold.dart';

class AppUpdateView extends StatelessWidget {
  const AppUpdateView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: ColorManager.kBackground,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 200.h),
          //
          //

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Column(
              children: [
                Center(
                  child: Image.asset(ImageManager.kAppUpdateIcon, width: 200),
                ),
                SizedBox(height: 120),
                Text(
                  "Update available",
                  style: get32TextStyle(
                      fontSize: FontSize.s24, color: ColorManager.kSecBlue),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 9),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 80),
                  child: Text(
                    "Please update your app to use our recently improved version.",
                    style: get16TextStyle().copyWith(
                        fontWeight: FontWeight.w400,
                        height: 1.35,
                        fontSize: FontSize.s14,
                        color: ColorManager.kTextColor),
                    textAlign: TextAlign.center,
                  ),
                ),

                // //
                const SizedBox(height: 50),
                CustomBtn(
                  isActive: true,
                  loading: false,
                  text: "Update Now",
                  onTap: () {
                    try {
                      String url =
                          "https://play.google.com/store/apps/details?id=com.app.ksbtech";

                      if (Platform.isIOS) {
                        url =
                            "https://apps.apple.com/us/app/ksbtech/id1576849320";
                      }

                      launchUrl(Uri.parse(url));
                    } catch (_) {}
                  },
                ),
                const SizedBox(height: 28),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w,vertical:20.h),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => Navigator.pop(context),
                    child: Text("Remind me later",
                        style: get16TextStyle().copyWith(
                            decoration: TextDecoration.none,
                            fontSize: FontSize.s14,
                            color: ColorManager.kSecBlue,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(),
        ],
      ),
    );
  }
}
