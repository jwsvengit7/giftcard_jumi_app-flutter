import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';

class RateItem extends StatelessWidget {
  const RateItem({this.imageUrl, super.key});
  final String? imageUrl;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Row(
        children: [
          CardLogo(),
          SizedBox(width: 20.w),
         
          NameOfCard(
            cardName: "Germany Amazon",
          ),
          SizedBox(width: 50.w),
          BuyAndSellPrices(
            price: "N54,000",
          ),
          SizedBox(
            width: 50.w,
          ),
          BuyAndSellPrices(
            price: "N54,000",
          ),
        ],
      ),
    );
  }
}

class CardLogo extends StatelessWidget {
  const CardLogo({this.imageUrl, super.key});
  final String? imageUrl;
  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Colors.lightBlueAccent),
        child: Icon(Icons.broken_image),
      );
    } else {
      return Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: Image.network(
                  imageUrl!,
                ).image,
                fit: BoxFit.cover),
          ));
    }
  }
}

class NameOfCard extends StatelessWidget {
  const NameOfCard({required this.cardName, super.key});
  final String cardName;
  @override
  Widget build(BuildContext context) {
    return Text(
      cardName,
      style: get16TextStyle(
        color: ColorManager.kGray9.withOpacity(0.7),
        fontWeight: FontWeight.w400,
        fontSize: 14.sp,
      ).copyWith(decoration: TextDecoration.none),
    );
  }
}

class BuyAndSellPrices extends StatelessWidget {
  const BuyAndSellPrices({required this.price, super.key});
  final String price;
  @override
  Widget build(BuildContext context) {
    return Text(
      price,
      style: get16TextStyle(
        color: ColorManager.kGray9.withOpacity(0.9),
        fontWeight: FontWeight.w500,
        fontSize: 14.sp,
      ).copyWith(decoration: TextDecoration.none),
    );
  }
}
