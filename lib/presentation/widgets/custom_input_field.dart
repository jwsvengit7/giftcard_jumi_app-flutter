import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';

import '../resources/image_manager.dart';

class CustomInputField extends StatefulWidget {
  const CustomInputField({
    Key? key,
    this.textEditingController,
    this.textInputAction,
    this.textInputType,
    this.focusNode,
    this.onSubmitted,
    this.validator,
    this.hintText,
    this.forceRefresh,
    this.decoration,
    this.obscureText,
    this.readOnly,
    this.style,
    this.onFieldSubmitted,
    this.cursorColor,
    this.inputFormatters,
    this.onChanged,
    this.isPasswordField = false,
    this.suffixConstraints,
    this.suffixIcon,
    this.prefixIcon,
    this.hintStyle,
    this.onTap,
    this.autofillHints,
    this.formHolderName,
    this.prefixIconConstraints,
    this.enabled,
    this.maxLength,
    this.fillColor,
    this.counterText,
  }) : super(key: key);
  final bool? enabled;
  final int? maxLength;
  final String? formHolderName;
  final TextEditingController? textEditingController;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final String? hintText;
  final bool? obscureText;
  final bool? readOnly;
  final String? counterText;
  final Function? forceRefresh;
  final InputDecoration? decoration;
  final TextStyle? style;
  final ValueChanged<String>? onFieldSubmitted;
  final Color? cursorColor;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final bool? isPasswordField;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final BoxConstraints? suffixConstraints;
  final BoxConstraints? prefixIconConstraints;
  final TextStyle? hintStyle;
  final Function? onTap;
  final Iterable<String>? autofillHints;
  final Color? fillColor;
  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _isVisible = false;
  bool _showVisibility = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.formHolderName != null
            ? Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  widget.formHolderName!,
                  style: get14TextStyle(
                      fontWeight: FontWeight.w300, fontSize: 14.sp),
                ),
              )
            : const SizedBox(),
        TextFormField(
          enabled: widget.enabled,
          autofillHints: widget.autofillHints,
          inputFormatters: widget.inputFormatters ?? [],
          maxLength: widget.maxLength,
          cursorColor:
              widget.cursorColor ?? ColorManager.kTextColor.withOpacity(0.25),
          focusNode: widget.focusNode,
          controller: widget.textEditingController,
          textInputAction: widget.textInputAction,
          onTap: () {
            if (widget.onTap != null) widget.onTap!();
          },
          onChanged: (args) {
            if (args.length > 1) {
              setState(() {
                _isVisible = true;
              });
            } else if (args.isEmpty) {
              setState(() {
                _isVisible = false;
              });
            } else if (widget.textEditingController!.text.isEmpty) {
              setState(() {
                _isVisible = false;
              });
            }
            if (widget.forceRefresh != null) widget.forceRefresh!();
            if (widget.onChanged != null) widget.onChanged!(args);
          },
          obscureText: widget.isPasswordField! ? _showVisibility : false,
          readOnly: widget.readOnly ?? false,
          decoration: widget.decoration ??
              InputDecoration(
                counterText: widget.counterText,
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: widget.suffixIcon ??
                      SizedBox(
                        child: widget.isPasswordField!
                            ? GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  setState(
                                      () => _showVisibility = !_showVisibility);
                                },
                                child: Image.asset(
                                  _showVisibility
                                      ? ImageManager.kEyeClosed
                                      : ImageManager.kEyeOpen,
                                  width: 20,
                                ),
                              )
                            : const SizedBox(),
                      ),
                ),
                prefixIcon: widget.prefixIcon,
                suffixIconConstraints: widget.suffixConstraints ??
                    const BoxConstraints(minHeight: 0, minWidth: 0),
                prefixIconConstraints: widget.prefixIconConstraints ??
                    const BoxConstraints(minHeight: 0, minWidth: 0),
                filled: true,
                fillColor: widget.fillColor ?? ColorManager.kFormBg,
                contentPadding:EdgeInsets.only(
                    top: 20.h, bottom: 20.h, left: 15.w, right: 7.w),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide:
                      BorderSide(color: ColorManager.kFormBorder, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(
                    width: 1,
                    color: ColorManager.kTextColor,
                  ),
                ),
                hintText: widget.hintText,
                hintStyle: 
                    getHintTextStyle(fontWeight: FontWeight.w400),
                errorStyle: getHintTextStyle(color: ColorManager.kError),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: ColorManager.kError),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: ColorManager.kError),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(
                      color: ColorManager.kFormBorder.withOpacity(0.5),
                      width: 0),
                ),
                
              ),
          onFieldSubmitted: widget.onFieldSubmitted ?? (_) {},
          validator: (val) {
            if (widget.validator != null) return widget.validator!(val);
            return null;
          },
          keyboardType: widget.textInputType,
        ),
      ],
    );
  }
}
