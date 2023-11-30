import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/model/saved_bank.dart';
import '../../core/utils/utils.dart';
import '../resources/color_manager.dart';
import '../resources/styles_manager.dart';

Widget buildBankTile(SavedBank current, Function onTap, {Widget? pointer}) {
  return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap(),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                truncateWithEllipsis(30, current.account_name ?? "").toTitleCase(),
                style: get16TextStyle().copyWith(
                  color: ColorManager.kGray9,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              BankNameNumberCapsule(
                current: current,
              )
            ],
          ),
          const Spacer(),
          Icon(Icons.arrow_forward_ios,size: 24,)
        ],
      ));
}



Widget buildBankCard(SavedBank current, Function onTap) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () => onTap(),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: ColorManager.kFormBg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                truncateWithEllipsis(15, current.bank?.name ?? ""),
                style: get16TextStyle().copyWith(
                  color: ColorManager.kBlack,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                truncateWithEllipsis(17, current.account_name ?? ""),
                style: get16TextStyle().copyWith(
                  color: ColorManager.kFormHintText,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Text(
            "${current.account_number}",
            style: get16TextStyle().copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ),
  );
}

class BankNameNumberCapsule extends StatelessWidget {
  const BankNameNumberCapsule({super.key, required this.current});

  final SavedBank current;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.r),
          border:
              Border.all(color: ColorManager.kPrimaryBlue.withOpacity(0.15)),
          color: ColorManager.kUpdateBackground),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            truncateWithEllipsis(15, current.bank?.name ?? ""),
            style: get16TextStyle().copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: ColorManager.kPrimaryBlue),
          ),
          SizedBox(
            child: VerticalDivider(
              color: ColorManager.kEllipseBg,
            ),
            height: 20.h,
          ),
          Text(
            "${current.account_number}",
            style: get16TextStyle().copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: ColorManager.kPrimaryBlue),
          ),
        ],
      ),
    );
  }
}
