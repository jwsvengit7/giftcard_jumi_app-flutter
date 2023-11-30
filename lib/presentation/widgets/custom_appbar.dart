import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';

import 'custom_appbar_leading.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar({
    Key? key,
    this.leading,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.shadowColor,
    this.shape,
    this.isCancel = false,
    this.backgroundColor,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.textTheme,
    this.centerTitle,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.toolbarHeight,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.scrolledUnderElevation,
    this.systemOverlayStyle,
    this.automaticallyImplyLeading = true,
  })  : assert(elevation == null || elevation >= 0.0),
        preferredSize = Size.fromHeight(toolbarHeight ??
            kToolbarHeight + (bottom?.preferredSize.height ?? 0.0)),
        super(key: key);

  @override
  final Size preferredSize;

  final Widget? leading;
  final Widget? title;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final double? scrolledUnderElevation;
  final Color? shadowColor;
  final ShapeBorder? shape;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final TextTheme? textTheme;
  final bool? centerTitle;
  final bool isCancel;
  final double? titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;
  final double? toolbarHeight;
  final double? leadingWidth;
  final TextStyle? toolbarTextStyle;
  final TextStyle? titleTextStyle;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool automaticallyImplyLeading;

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    bool canPop = parentRoute?.canPop ?? false;
    Widget? leading = widget.leading;
    if (leading == null && canPop) {
      leading = CustomAppBarLeading(isCancel: widget.isCancel);
    }

    return AppBar(
        leading: leading,
        title: widget.title,
        actions: widget.actions,
        flexibleSpace: widget.flexibleSpace,
        bottom: widget.bottom,
        elevation: widget.elevation ?? 0,
        scrolledUnderElevation: widget.scrolledUnderElevation ?? 0,
        shadowColor: widget.shadowColor ?? const Color.fromRGBO(0, 0, 0, .2),
        shape: widget.shape,
        backgroundColor: widget.backgroundColor ?? ColorManager.kWhite,
        foregroundColor: widget.foregroundColor,
        iconTheme: widget.iconTheme,
        actionsIconTheme: widget.actionsIconTheme,
        centerTitle: widget.centerTitle ?? true,
        titleSpacing: widget.titleSpacing,
        toolbarOpacity: widget.toolbarOpacity,
        bottomOpacity: widget.bottomOpacity,
        toolbarHeight: widget.toolbarHeight,
        leadingWidth: widget.leadingWidth,
        toolbarTextStyle: widget.toolbarTextStyle,
        titleTextStyle: widget.titleTextStyle,
        // systemOverlayStyle: widget.systemOverlayStyle ??
        //     ColorDefinition.kStatusBarBrightness(themeMode),
        automaticallyImplyLeading: widget.automaticallyImplyLeading);
  }
}
