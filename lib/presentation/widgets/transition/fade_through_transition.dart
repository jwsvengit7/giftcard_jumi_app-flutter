import 'package:flutter/material.dart';

import 'custom_transition_builder.dart';

class FadeThroughTransition extends StatelessWidget {
  const FadeThroughTransition({
    Key? key,
    required this.animation,
    required this.secondaryAnimation,
    this.child,
  }) : super(key: key);

  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomZoomDualTransitionBuilder(
      animation: animation,
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: CustomZoomDualTransitionBuilder(
          animation: ReverseAnimation(secondaryAnimation),
          child: child,
        ),
      ),
    );
  }
}
