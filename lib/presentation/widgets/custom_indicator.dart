import 'package:flutter/material.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';

import '../resources/image_manager.dart';

buildCustomIndicator(bool isCurrentPage) {
  return Container(
      margin: const EdgeInsets.only(right: 4.0),
      height: 6.0,
      width: isCurrentPage ? 60 : 30,
      decoration: BoxDecoration(
          color: isCurrentPage
              ? ColorManager.kNavyBlue
              : ColorManager.kYellow.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10)));
}

Widget buildLine(
    {required double width, required double height, required Color color}) {
  return Container(width: width, height: height, color: color);
}

class CustomProgressIndicator extends StatelessWidget {
  final Color? backgroundColor;
  final Color? progressColor;
  // final double totalWidth;
  final double progress;

  CustomProgressIndicator({
    this.backgroundColor,
    this.progressColor,
    // this.totalWidth = 250.0,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double progressLength = this.progress * size.width;

    var boxDecoration = BoxDecoration(
      color: backgroundColor ?? ColorManager.kYellow,
      borderRadius: BorderRadius.circular(5),
      boxShadow: const [BoxShadow(color: Color(0xffEFEFEF), spreadRadius: 0)],
    );
    return Container(
      decoration: boxDecoration,
      // width: totalWidth,
      height: 4,
      child: Stack(
        children: [
          Container(
            width: progressLength,
            decoration: BoxDecoration(
              color: progressColor ?? ColorManager.kSecBlue,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildDropDownSuffixIcon() => const Padding(
    padding: EdgeInsets.only(right: 13),
    child: Icon(Icons.arrow_drop_down_sharp));

Widget buildDropDown({double? width, double? height, Color? color}) =>
    Image.asset(
      ImageManager.kArrowDown,
      width: width ?? 16,
      height: height,
      color: color ?? ColorManager.kGray7,
    );

Widget buildCircularIndicator(bool selected) => Container(
      height: 16,
      width: 16,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(width: 1, color: ColorManager.kSecBlue),
      ),
      child: selected
          ? CircleAvatar(backgroundColor: ColorManager.kYellow)
          : const SizedBox(),
    );

Widget buildCurvedRectangle(Widget child, {Color? bgColor}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 20),
    decoration: BoxDecoration(
      color: bgColor ?? ColorManager.kBackgroundAlt,
      border: Border.all(
        width: 1,
        color: ColorManager.kFormBorder,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
      child: child,
    ),
    //
  );
}

Widget getPrefixDropDown({required Widget child, required Function onTap}) =>
    GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap(),
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          // color: ColorManager.kYellow,
        ),
        height: 60,
        width: 110,
        child: child,
      ),
    );

Widget buildDot(Widget child, {Color? bgColor}) {
  return Container(
    width: 64,
    height: 64,
    decoration: BoxDecoration(
      color: bgColor ?? ColorManager.kBackgroundAlt,
      border: Border.all(
        width: 1,
        color: ColorManager.kWhite.withOpacity(0.3),
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
      child: child,
    ),
    //
  );
}
