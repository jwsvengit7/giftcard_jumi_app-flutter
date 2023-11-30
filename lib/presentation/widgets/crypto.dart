import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/model/network.dart';

import '../../core/model/asset.dart';
import '../../core/utils/utils.dart';
import '../resources/color_manager.dart';
import '../resources/styles_manager.dart';
import 'custom_indicator.dart';

Widget buildNetworkTile(
    {required Network current,
    required Function onTap,
    required bool selected}) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () => onTap(),
    child: Row(
      children: [
        buildCircularIndicator(selected),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            current.name ?? "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: get16TextStyle().copyWith(
              color: ColorManager.kBlack,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildAssetTile(
    {required Asset current, required Function onTap, required bool selected}) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () => onTap(),
    child: Row(
      children: [
        buildCircularIndicator(selected),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: loadNetworkImage(current.icon ?? "", width: 25),
        ),
        Text(
          truncateWithEllipsis(6, current.code ?? ""),
          style: get16TextStyle().copyWith(
            color: ColorManager.kBlack,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}
