import 'package:flutter/material.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';

class NoContent extends StatelessWidget {
  final String? title;
  final String? desc;
  final Widget? btn;
  final Widget? spacing;
  final String? imgUrl;
  final bool displayImage;
  final EdgeInsetsGeometry? padding;
  const NoContent(
      {Key? key,
      this.displayImage = false,
      this.title,
      this.desc,
      this.btn,
      this.imgUrl,
      this.padding,
      this.spacing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.only(right: 16, top: 56),
      child: Center(
        child: Column(
          children: [
            displayImage
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 35),
                    child: Image.asset(ImageManager.kEmptyList, width: 200))
                : const SizedBox(),
            Text(
              title ?? "Nothing to see here yet..",
              textAlign: TextAlign.center,
              style: get14TextStyle().copyWith(
                fontWeight: FontWeight.w400,
                color: ColorManager.kFormHintText,
              ),
            ),
            Text(
              desc ?? "When you have some, you’ll find them here",
              textAlign: TextAlign.center,
              style: get14TextStyle().copyWith(
                fontWeight: FontWeight.w400,
                color: ColorManager.kFormHintText,
              ),
            ),
            btn == null
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: btn!,
                  )
          ],
        ),
      ),
    );
  }
}
