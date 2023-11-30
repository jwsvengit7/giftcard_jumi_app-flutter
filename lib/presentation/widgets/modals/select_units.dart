import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';

class SelectUnits extends StatelessWidget {
  const SelectUnits({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 650.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Column(children: [
        Container(
          height: 5.h,
          width: 78.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              color: ColorManager.kBorder),
        ),
        Row(
          children: [
            Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: Image.asset(ImageManager.kArrowBack,
                            color: ColorManager.kPrimaryBlack,
                            width: 12,
                            height: 12),
                      ),
                    ),
                    Text('Select Units',
                        style: get16TextStyle()
                            .copyWith(fontWeight: FontWeight.w400)),
                  ],
                )),
          ],
        ),
        SizedBox(height: 10.h),
        Expanded(
            child: ListView.separated(
          itemBuilder: (context, index) {
            return GestureDetector(
               onTap: () {
                    Navigator.pop<int>(context, index + 1);
                  },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Text(
                  "${index + 1}",
                  style: get16TextStyle().copyWith(
                    color: ColorManager.kBlack,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            );
          },
          itemCount: 100,
          separatorBuilder: ((context, index) => Divider()),
        ))
      ]),
    );
  }
}
