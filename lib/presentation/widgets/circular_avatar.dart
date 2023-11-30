import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/core/model/user.dart';
import 'package:jimmy_exchange/core/providers/user_provider.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:provider/provider.dart';

class CircularAvatar extends StatelessWidget {
  const CircularAvatar({this.size, super.key});
  final double? size;
  @override
  Widget build(BuildContext context) {
    User user =
        Provider.of<UserProvider>(context).user ?? User(wallet_balance: 0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: loadNetworkImage(
        user.avatar ?? "",
        width: size ?? 48.w,
        height: size ?? 48.w,
        errorDefaultImage: ImageManager.kProfileFallBack,
        fit: BoxFit.fill,
      ),
    );
  }
}
