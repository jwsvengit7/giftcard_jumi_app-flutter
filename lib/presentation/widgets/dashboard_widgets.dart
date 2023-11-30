import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/presentation/widgets/circular_avatar.dart';
import 'package:provider/provider.dart';

import '../../core/providers/user_provider.dart';
import '../resources/image_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/styles_manager.dart';

class DashboardTitleBar extends StatefulWidget {
  final String name;
  final Widget? leadingWidget;

  const DashboardTitleBar({super.key, required this.name, this.leadingWidget});

  @override
  State<DashboardTitleBar> createState() => _DashboardTitleBarState();
}

class _DashboardTitleBarState extends State<DashboardTitleBar> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      userProvider.checkUnreadNotification().catchError((_) {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        widget.leadingWidget ?? CircularAvatar(size:30.r),
        Text(widget.name, style: get28TextStyle(fontSize: 20.sp)),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            await Navigator.pushNamed(context, RoutesManager.notificationRoute);
            userProvider.checkUnreadNotification().catchError((_) {});
          },
          child: Image.asset(
              userProvider.unreadNotificationAvailable
                  ? ImageManager.kNotification
                  : ImageManager.kReadNotification,
              width: 24.w,
              height: 24.w),
        )
      ],
    );
  }
}
