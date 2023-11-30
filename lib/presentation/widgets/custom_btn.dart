import 'package:flutter/material.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/resources/values_manager.dart';

class CustomBtn extends StatelessWidget {
  final String text;
  final Color? textColor;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final BoxDecoration? boxDecoration;
  final EdgeInsetsGeometry? padding;
  final Color? loadingColor;
  final Function onTap;
  final double? width;
  final bool isActive;
  final bool loading;

  const CustomBtn({
    super.key,
    required this.text,
    this.textColor,
    this.backgroundColor,
    this.boxDecoration,
    this.textStyle,
    this.width,
    required this.isActive,
    required this.onTap,
    required this.loading,
    this.loadingColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => isActive && loading == false ? onTap() : () {},
      child: Container(
        width: width ?? double.infinity,
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: AppPadding.p22),
        decoration: boxDecoration ??
            BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isActive
                  ? (backgroundColor ?? ColorManager.kPrimaryBlue)
                  : (backgroundColor ?? ColorManager.kPrimaryBlue)
                      .withOpacity(0.15),
            ),
        child: loading
            ? Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      loadingColor ?? ColorManager.kPrimaryBlack,
                    ),
                  ),
                ),
              )
            : Text(
                text,
                style: textStyle ??
                    getBtnTextStyle(
                            color: textColor, fontWeight: FontWeight.w700)
                        .copyWith(decoration: TextDecoration.none),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}

class CustomSmallBtn extends StatelessWidget {
  final String text;
  final Color? textColor;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final BoxDecoration? boxDecoration;
  final EdgeInsetsGeometry? padding;
  final Color? loadingColor;
  final Function onTap;
  final double? width;
  final bool isActive;
  final bool loading;

  const CustomSmallBtn({
    super.key,
    required this.text,
    this.textColor,
    this.backgroundColor,
    this.boxDecoration,
    this.textStyle,
    this.width,
    required this.isActive,
    required this.onTap,
    required this.loading,
    this.loadingColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => isActive && loading == false ? onTap() : () {},
      child: Container(
        width: width ?? 120,
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: AppPadding.p14),
        decoration: boxDecoration ??
            BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: backgroundColor ?? ColorManager.kPrimaryBlue,
            ),
        child: loading
            ? Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      loadingColor ?? ColorManager.kPrimaryBlack,
                    ),
                  ),
                ),
              )
            : Text(
                text,
                style: textStyle ?? getBtnTextStyle(color: textColor),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
