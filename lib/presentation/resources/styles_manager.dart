import 'package:flutter/material.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';

import 'image_manager.dart';
import 'values_manager.dart';

TextStyle _getTextStyle(
    {required double fontSize,
    required FontWeight fontWeight,
    required Color color}) {
  return TextStyle(
    // fontFamily: "fontFamily",
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
  );
}

//
TextStyle get16TextStyle(
    {double fontSize = FontSize.s16, Color? color, FontWeight? fontWeight}) {
  return _getTextStyle(
    fontSize: fontSize,
    color: color ?? ColorManager.kBlack,
    fontWeight: fontWeight ?? FontWeight.w600,
  );
}

TextStyle get18TextStyle({double fontSize = FontSize.s18, Color? color}) {
  return _getTextStyle(
    fontSize: fontSize,
    color: color ?? ColorManager.kBlack,
    fontWeight: FontWeight.w700,
  );
}

TextStyle getPrefixTextStyle({double fontSize = FontSize.s16, Color? color}) {
  return get16TextStyle()
      .copyWith(fontWeight: FontWeight.w400, color: ColorManager.kSecBlue);
}

TextStyle get14TextStyle(
    {double fontSize = FontSize.s14, Color? color, FontWeight? fontWeight}) {
  return _getTextStyle(
    fontSize: fontSize,
    color: color ?? ColorManager.kBlack,
    fontWeight: fontWeight ?? FontWeight.w400,
  );
}

TextStyle get12TextStyle({double fontSize = FontSize.s12, Color? color}) {
  return _getTextStyle(
    fontSize: fontSize,
    color: color ?? ColorManager.kBlack,
    fontWeight: FontWeight.w400,
  );
}

TextStyle get24TextStyle({double fontSize = FontSize.s24, Color? color}) {
  return _getTextStyle(
    fontSize: fontSize,
    color: color ?? ColorManager.kBlack,
    fontWeight: FontWeight.w600,
  );
}

TextStyle get28TextStyle({double fontSize = 28, Color? color}) {
  return _getTextStyle(
    fontSize: fontSize,
    color: color ?? ColorManager.kBlack,
    fontWeight: FontWeight.w700,
  );
}

TextStyle get32TextStyle(
    {double fontSize = FontSize.s32, Color? color, FontWeight? fontWeight}) {
  return _getTextStyle(
    fontSize: fontSize,
    color: color ?? ColorManager.kBlack,
    fontWeight: fontWeight ?? FontWeight.w700,
  );
}

TextStyle get20TextStyle(
    {double? fontSize, Color? color, FontWeight? fontWeight}) {
  return _getTextStyle(
    fontSize: fontSize ?? FontSize.s20,
    color: color ?? ColorManager.kBlack,
    fontWeight: fontWeight ?? FontWeight.w600,
  );
}

TextStyle getHintTextStyle(
    {double fontSize = FontSize.s14, Color? color, FontWeight? fontWeight}) {
  return _getTextStyle(
    fontSize: fontSize,
    color: color ?? ColorManager.kFormHintText,
    fontWeight: fontWeight ?? FontWeight.w400,
  );
}

TextStyle getBtnTextStyle(
    {double fontSize = FontSize.s16, Color? color, FontWeight? fontWeight}) {
  return _getTextStyle(
    fontSize: fontSize,
    color: color ?? ColorManager.kWhite,
    fontWeight: fontWeight ?? FontWeight.w500,
  );
}

InputDecoration getSearchInputDecoration({
  String? hintText,
  Widget? suffixIcon,
  Widget? prefixIcon,
  EdgeInsetsGeometry? padding,
  TextStyle? hintTextStyle,
}) =>
    InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          width: 1.2,
          color: Color(0xffF4F4F4),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(width: 1.2, color: Color(0xffF4F4F4)),
      ),
      border: InputBorder.none,
      hintText: hintText ?? 'Search',
      hintStyle:  getHintTextStyle(),
      suffixIcon: suffixIcon ??
          Padding(
            padding: const EdgeInsets.only(right: 13),
            child: SizedBox(
              width: 20,
              height: 20,
              child: Center(
                child: Image.asset(ImageManager.kSearchIcon,
                    width: 20, height: 20),
              ),
            ),
          ),
      contentPadding:
          padding ?? const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      fillColor: ColorManager.kWhite,
      filled: true,
      prefixIcon: prefixIcon,
    );



// // light text style

// TextStyle getLightStyle(
//     {double fontSize = FontSize.s12, required Color color}) {
//   return _getTextStyle(
//       fontSize, FontConstants.fontFamily, FontWeightManager.light, color);
// }
// // bold text style

// TextStyle getBoldStyle({double fontSize = FontSize.s12, required Color color}) {
//   return _getTextStyle(
//       fontSize, FontConstants.fontFamily, FontWeightManager.bold, color);
// }

// // semi bold text style

// TextStyle getSemiBoldStyle(
//     {double fontSize = FontSize.s12, required Color color}) {
//   return _getTextStyle(
//       fontSize, FontConstants.fontFamily, FontWeightManager.semiBold, color);
// }

// // medium text style

// TextStyle getMediumStyle(
//     {double fontSize = FontSize.s12, required Color color}) {
//   return _getTextStyle(
//       fontSize, FontConstants.fontFamily, FontWeightManager.medium, color);
// }
