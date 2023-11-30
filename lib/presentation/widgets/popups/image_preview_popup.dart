import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/enum.dart';

import '../../../core/utils/utils.dart';
import '../../resources/color_manager.dart';
import '../../resources/image_manager.dart';

class ImagePreviewPopup extends StatefulWidget {
  final String imageUrl;
  final ImageType imageType;
  final File? file;

  const ImagePreviewPopup({
    Key? key,
    required this.imageUrl,
    this.imageType = ImageType.link,
    this.file,
  }) : super(key: key);

  @override
  _ImagePreviewPopupState createState() => _ImagePreviewPopupState();
}

class _ImagePreviewPopupState extends State<ImagePreviewPopup> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: ColorManager.kWhite,
      content: SizedBox(
        height: 450,
        width: MediaQuery.of(context).size.width,
        child: loadNetworkImage(
          widget.imageUrl,
          height: 450,
          width: 450,
          imageType: widget.imageType,
          file: widget.file,
        ),
      ),
    );
  }
}

class ImagePreviewPopupAlt extends StatefulWidget {
  final String imageUrl;

  const ImagePreviewPopupAlt({Key? key, required this.imageUrl})
      : super(key: key);

  @override
  _ImagePreviewPopupAltState createState() => _ImagePreviewPopupAltState();
}

class _ImagePreviewPopupAltState extends State<ImagePreviewPopupAlt> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: Colors.transparent,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Image.asset(
                  ImageManager.kCancel,
                  width: 24,
                  height: 24,
                ),
              ),
            ),
            const SizedBox(height: 5),
            loadNetworkImage(widget.imageUrl),
          ],
        ),
      ),
    );
  }
}
