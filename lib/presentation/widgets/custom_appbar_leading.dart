import 'package:flutter/material.dart';

class CustomAppBarLeading extends StatelessWidget {
  const CustomAppBarLeading(
      {Key? key, this.color, this.widget, this.onTap, this.isCancel = false})
      : super(key: key);
  final Function? onTap;
  final bool isCancel;
  final Color? color;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null ? onTap!() : () => Navigator.pop(context),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: widget ??
                    Icon(isCancel ? Icons.cancel : Icons.arrow_back_ios,
                        color: color ?? Colors.black, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
