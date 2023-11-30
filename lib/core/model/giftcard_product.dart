import 'package:jimmy_exchange/core/model/country.dart';
import 'package:jimmy_exchange/core/model/giftcard_category.dart';

class GiftcardProduct {
  final String? id;
  final String? giftcard_category_id;
  final String? activated_at;
  final String? country_id;
  final String? currency_id;
  final String? name;
  final num? sell_rate;
  final num? sell_min_amount;
  final num? sell_max_amount;
  final GiftcardCategory? giftcard_category_alt;
  final Map<String, dynamic>? giftcard_category;
  final Country? country_alt;
  final Map<String, dynamic>? country;
  final Map<String, dynamic>? currency;

  GiftcardProduct({
    this.id,
    this.giftcard_category_id,
    this.country_id,
    this.currency_id,
    this.name,
    this.sell_rate,
    this.sell_min_amount,
    this.sell_max_amount,
    this.giftcard_category,
    this.giftcard_category_alt,
    this.country,
    this.country_alt,
    this.currency,
    this.activated_at,
  });

  factory GiftcardProduct.fromMap(Map<String, dynamic> map) {
    return GiftcardProduct(
      id: map['id'],
      giftcard_category_id: map['giftcard_category_id'],
      country_id: map["country_id"],
      currency_id: map["currency_id"],
      name: map['name'],
      sell_rate: map['sell_rate'],
      sell_min_amount: map['sell_min_amount'],
      sell_max_amount: map['sell_max_amount'],
      giftcard_category: map['giftcard_category'],
      giftcard_category_alt: map['giftcard_category'] != null
          ? GiftcardCategory.fromMap(map["giftcard_category"])
          : null,
      country: map["country"],
      country_alt:
          map["country"] != null ? Country.fromMap(map["country"]) : null,
      currency: map["currency"],
      activated_at: map["activated_at"],
    );
  }
}
