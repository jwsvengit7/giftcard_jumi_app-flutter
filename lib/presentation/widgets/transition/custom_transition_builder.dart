import 'package:flutter/material.dart';
import 'fade_through_transition.dart';
import 'fade_transitions.dart';

class CustomZoomDualTransitionBuilder extends StatelessWidget {
  const CustomZoomDualTransitionBuilder(
      {Key? key, required this.animation, this.child})
      : super(key: key);

  final Animation<double> animation;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return DualTransitionBuilder(
      animation: animation,
      forwardBuilder: (
        BuildContext context,
        Animation<double> animation,
        Widget? child,
      ) {
        return ZoomInFadeTransition(
          animation: animation,
          child: child,
        );
      },
      reverseBuilder: (
        BuildContext context,
        Animation<double> animation,
        Widget? child,
      ) {
        return ZoomOutFadeTransition(
          child: child,
          animation: animation,
        );
      },
      child: child,
    );
  }
}

class CustomFadeTransitionBuilder<T> extends PageTransitionsBuilder {
  const CustomFadeTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T>? route,
    BuildContext? context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeThroughTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      child: child,
    );
  }
}
