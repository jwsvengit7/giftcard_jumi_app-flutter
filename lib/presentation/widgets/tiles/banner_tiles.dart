import 'package:flutter/material.dart';

import '../../../core/model/banner.dart';
import '../../../core/utils/utils.dart';
import '../../resources/color_manager.dart';
import '../popups/image_preview_popup.dart';
import '../popups/index.dart';

class BannerTiles extends StatelessWidget {
  final Banners banners;
  const BannerTiles({super.key, required this.banners});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        showDialogPopup(
            context, ImagePreviewPopupAlt(imageUrl: banners.preview_image),
            barrierDismissible: true,
            barrierColor: ColorManager.kBlack.withOpacity(.7));
      },
      child: Container(
        width: size.width * 0.7,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(6), bottomLeft: Radius.circular(6)),
          child: loadNetworkImage(banners.featured_image,
              fit: BoxFit.cover, height: 125),
        ),
      ),
    );
  }
}
