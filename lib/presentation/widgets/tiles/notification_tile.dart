import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/ellipse.dart';

import '../../../core/helpers/user_helper.dart';
import '../../../core/model/app_notification.dart';
import '../../resources/color_manager.dart';

class NotificationTile extends StatefulWidget {
  final AppNotification param;
  const NotificationTile({super.key, required this.param});

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  @override
  void initState() {
    if (widget.param.read_at == null) {
      UserHelper.readNotification(widget.param.id ?? "");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color mainColor = widget.param.read_at == null
        ? ColorManager.kSecBlue
        : ColorManager.kReadNotification;

    Color dateColor = widget.param.read_at == null
        ? ColorManager.kGray1
        : ColorManager.kReadNotificationDate;

    return Container(
      // margin: const EdgeInsets.only(bottom: 20),
      padding:
          EdgeInsets.only(top: 15.h, bottom: 15.h, left: 20.w, right: 30.w),
      decoration: BoxDecoration(
        color: ColorManager.kBorder,
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: ColorManager.kTxnTileBorderColor,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              widget.param.read_at != null
                  ? Image.asset("assets/icons/dashboard/success.png", width: 40)
                  : Image.asset("assets/icons/dashboard/failed.png", width: 40),
              Text(
                widget.param.data?["title"],
                style: get16TextStyle(
                  fontSize: 16.sp,
                ).copyWith(
                    fontWeight: FontWeight.w500, color: ColorManager.kGray9),
              ),
              const Spacer(),
              Text(
                formatDateDayAndMonthSlash(widget.param.updated_at),
                style: get12TextStyle(fontSize: 14.sp)
                    .copyWith(fontWeight: FontWeight.w300, color: mainColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.only(
              left: 45.w,
            ),
            child: Text(
              widget.param.data?["body"],
              style: get12TextStyle(fontSize: 14.sp)
                  .copyWith(fontWeight: FontWeight.w300, color: mainColor),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                formatDateSlash(widget.param.created_at),
                style: get12TextStyle().copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: dateColor,
                ),
              ),
              buildEllipse(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  color: ColorManager.kSecBlue),
              Text(
                formatDateGetTime(widget.param.created_at).toLowerCase(),
                style: get12TextStyle().copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: dateColor),
              ),
            ],
          )
        ],
      ),
    );
  }
}
