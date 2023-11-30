import 'package:flutter/material.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/resources/values_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_indicator.dart';

class AlternateLogins extends StatelessWidget {
  const AlternateLogins({super.key, this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 34),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: buildCurvedRectangle(
                GestureDetector(
                  onTap: onTap,
                  behavior: HitTestBehavior.translucent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(ImageManager.kGoogle,
                          width: 24, height: 24),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Google",
                          style: get16TextStyle(
                              fontSize: FontSize.s14,
                              fontWeight: FontWeight.w500,
                              color: ColorManager.kTextGray))
                    ],
                  ),
                ),
                bgColor: ColorManager.kWhite),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: buildCurvedRectangle(
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(ImageManager.kFacebook,
                        width: 24, height: 24),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Facebook",
                        style: get16TextStyle(
                            fontSize: FontSize.s14,
                            fontWeight: FontWeight.w500,
                            color: ColorManager.kTextGray))
                  ],
                ),
                bgColor: ColorManager.kWhite),
          )
        ],
      ),
    );
  }
}
