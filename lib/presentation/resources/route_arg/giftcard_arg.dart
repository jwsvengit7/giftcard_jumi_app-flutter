import 'dart:io';
import 'package:jimmy_exchange/core/model/FundsWithdrawal.dart';
import 'package:jimmy_exchange/core/model/saved_bank.dart';

import '../../../core/model/country.dart';
import '../../../core/model/giftcard_category.dart';
import '../../../core/model/giftcard_product.dart';
// import '../../../core/model/saved_bank.dart';

class SellGiftCard2Arg {
  final GiftcardCategory giftCardCategory;
  final Country country;
  final GiftcardProduct giftCardProduct;
  final String card_type;
  final int quantity;
  final num amount;
  final num oneUnitPayable;
  final String comment;
  SavedBank? selectedBank;
  final FundsWithdrawal? fundsWithdrawal;

  // final SavedBank? savedBank;
  Map<String, dynamic>? breakdown;
  final List<File> giftCardFiles;

  SellGiftCard2Arg(
      {required this.giftCardCategory,
      required this.giftCardProduct,
      // required this.savedBank,
      required this.card_type,
      required this.country,
      required this.quantity,
      required this.amount,
      required this.comment,
      required this.giftCardFiles,
      required this.oneUnitPayable,
      this.breakdown,
      this.selectedBank,
      this.fundsWithdrawal});
}
