import '../../presentation/resources/route_arg/giftcard_arg.dart';

class BuyAndSaleGiftCardViewParams {
  BuyAndSaleGiftCardViewParams(
      {required this.giftCardList, required this.isGiftCardSale});
  final List<SellGiftCard2Arg> giftCardList;
  final bool isGiftCardSale;
}
