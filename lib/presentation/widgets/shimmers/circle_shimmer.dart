import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CircularShimmer extends StatelessWidget {
  final double? height;
  final double? width;

  const CircularShimmer({Key? key, this.height, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xffEFEFEF),
      highlightColor: const Color(0xffF6F6F7),
      enabled: true,
      child: Container(
        width: width ?? 35,
        height: height ?? 35,
        decoration: BoxDecoration(
          color: const Color(0xffEFEFEF),
          shape: BoxShape.circle,
          border: Border.all(width: .5),
        ),
      ),
    );
  }
}
