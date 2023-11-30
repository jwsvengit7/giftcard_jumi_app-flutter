import 'package:flutter/material.dart';
import '../transition/fade_through_transition.dart';

class SlidePageRoute extends PageRouteBuilder {
  final Widget? child;
  final Duration? transitionDurationAlt;
  final Duration? reverseTransitionDurationAlt;
  RouteSettings settings;
  bool useFadeTransition;

  SlidePageRoute(
      {Key? key,
      this.child,
      this.transitionDurationAlt,
      this.useFadeTransition = false,
      this.reverseTransitionDurationAlt,
      required this.settings})
      : super(
          transitionDuration: transitionDurationAlt ??
              (useFadeTransition
                  ? Duration(milliseconds: 300)
                  : Duration(milliseconds: 80)),
          settings: settings,
          reverseTransitionDuration: reverseTransitionDurationAlt ??
              (useFadeTransition
                  ? Duration(milliseconds: 300)
                  : Duration(milliseconds: 50)),
          pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) =>
              child!,
        );

  @override
  buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      !useFadeTransition
          ? SlideTransition(
              position: Tween<Offset>(begin: Offset(-1, 0), end: Offset.zero)
                  .animate(animation),
              child: child,
            )
          : FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child);
}

class DirectionPageRoute<T> extends PageRouteBuilder<T> {
  final Widget? child;
  final AxisDirection? direction;
  RouteSettings settings;

  DirectionPageRoute(
      {Key? key, this.child, required this.direction, required this.settings})
      : super(
          transitionDuration: Duration(milliseconds: 350),
          settings: settings,
          reverseTransitionDuration: Duration(milliseconds: 350),
          pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) =>
              child!,
        );

  @override
  buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      SlideTransition(
        position: Tween<Offset>(begin: getPosition(), end: Offset.zero)
            .animate(animation),
        child: child,
      );

  getPosition() {
    switch (direction) {
      case AxisDirection.down:
        return Offset(0, -1);

      case AxisDirection.left:
        return Offset(1, 0);

      case AxisDirection.right:
        return Offset(-1, 0);

      default:
        return Offset(0, 1);
    }
  }
}
