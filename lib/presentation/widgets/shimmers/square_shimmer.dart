import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SquareShimmer extends StatelessWidget {
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;

  const SquareShimmer({Key? key, this.height, this.width, this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xffEFEFEF),
      highlightColor: const Color(0xffF6F6F7),
      enabled: true,
      child: Container(
          width: width ?? 70,
          height: height ?? 10,
          decoration: BoxDecoration(
              borderRadius: borderRadius ?? BorderRadius.circular(4),
              color: const Color(0xffEFEFEF))),
    );
  }
}
