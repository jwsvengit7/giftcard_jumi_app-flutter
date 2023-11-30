import 'package:flutter/material.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';

class TabButton extends StatelessWidget {
  final double? width;
  final Widget child;
  final bool active;
  final Function onTap;

  TabButton({
    super.key,
    this.width,
    required this.child,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap(),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active ? ColorManager.kYellow : ColorManager.kFilterBg,
              width: 1,
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}
