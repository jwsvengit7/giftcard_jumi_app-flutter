import 'package:jimmy_exchange/core/model/country.dart';
import 'package:jimmy_exchange/core/model/giftcard_category.dart';
import 'package:jimmy_exchange/core/model/giftcard_product.dart';

class SelectGiftCardProduct {
  const SelectGiftCardProduct(
      {this.giftCardCategory, this.current, this.country});
  final GiftcardProduct? current;
  final GiftcardCategory? giftCardCategory;
  final Country? country;
}
