import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/model/referral.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';

class ReferralTile extends StatelessWidget {
  final Referral param;

  const ReferralTile({super.key, required this.param});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: const EdgeInsets.only(top: 5, bottom: 9),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.5,
              color: ColorManager.kTxnTileBorderColor,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: loadNetworkImage(param.referred.avatar),
              ),
            ),
            SizedBox(width: isSmallScreen(context) ? 8 : 16),

            //
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    param.referred.firstname + " " + param.referred.lastname,
                    style: get16TextStyle().copyWith(
                      fontWeight: FontWeight.w400,
                      color: ColorManager.kGray1,
                    ),
                  ),

                  //
                  const SizedBox(height: 5),
                  Text(
                    obscureEmail(param.referred.email),
                    style: get16TextStyle().copyWith(
                        fontWeight: FontWeight.w400,
                        color: ColorManager.kTextColor),
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: 6),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                // color: getStatusColor("approved"),
                color: getStatusColor(param.paid ? "approved" : "pending"),
              ),
              child: Text(
                param.paid ? "Completed" : "Pending",
                style: get12TextStyle(
                  color:
                      getStatusTextColor(param.paid ? "approved" : "pending"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
