import 'package:flutter/material.dart';

import '../resources/image_manager.dart';

class CustomLogo extends StatelessWidget {
  const CustomLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
          ImageManager.kLogoWhite,
        ))));
  }
}
