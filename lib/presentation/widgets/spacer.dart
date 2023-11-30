import 'package:flutter/material.dart';
import '../../core/utils/utils.dart';

class BottomSpacer extends StatelessWidget {
  final double? height;
  const BottomSpacer({Key? key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(height: height ?? size.height * .024);
  }
}

class DashboardTabTopSpacer extends StatelessWidget {
  const DashboardTabTopSpacer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: isSmallScreen(context) ? 55 : 75);
  }
}

class SettingsPageTopSpacer extends StatelessWidget {
  const SettingsPageTopSpacer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: isSmallScreen(context) ? 15 : 60);
  }
}
