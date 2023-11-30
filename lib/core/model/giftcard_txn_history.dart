import 'package:jimmy_exchange/core/model/bank.dart';
import 'package:jimmy_exchange/core/model/giftcard_product.dart';

class GiftcardTxnHistory {
  final String? id;
  final String? giftcard_product_id;
  final String? bank_id;
  final String? user_id;
  final String? account_number;
  final String? account_name;
  final String? reference;
  final String? status;
  final String? trade_type;
  final String? card_type;
  final num? amount;
  final num? service_charge;
  final num? rate;
  final num? payable_amount;
  final String? comment;
  final String? review_note;
  final List<dynamic>? review_proof;
  final num? review_rate;
  final String? reviewed_by;
  final String? reviewed_at;
  final String? created_at;
  final String? updated_at;
  final String? deleted_at;
  final Bank? bank;
  final GiftcardProduct? giftcard_product;
  final List<GiftcardCard>? cards;
  final num children_count;
  final List<GiftcardTxnHistory> related_giftcards;
  final num? review_amount;

  GiftcardTxnHistory({
    this.id,
    this.giftcard_product_id,
    this.bank_id,
    this.user_id,
    this.account_number,
    this.account_name,
    this.reference,
    this.status,
    this.trade_type,
    this.card_type,
    this.amount,
    this.service_charge,
    this.rate,
    this.payable_amount,
    this.comment,
    this.review_note,
    this.review_proof,
    this.review_rate,
    this.reviewed_by,
    this.reviewed_at,
    this.created_at,
    this.updated_at,
    this.deleted_at,
    this.bank,
    this.giftcard_product,
    this.cards,
    required this.children_count,
    required this.related_giftcards,
    this.review_amount,
  });

  factory GiftcardTxnHistory.fromMap(Map<String, dynamic> map) {
    print(map["status"]);
    List<GiftcardTxnHistory> relatedGiftcard = [];
    return GiftcardTxnHistory(
      id: map['id'],
      giftcard_product_id: map["giftcard_product_id"],
      bank_id: map["bank_id"],
      user_id: map["user_id"],
      account_number: map["account_number"],
      account_name: map["account_name"],
      reference: map["reference"],
      status: map["status"],
      trade_type: map["trade_type"],
      card_type: map["card_type"],
      amount: map["amount"],
      service_charge: map["service_charge"],
      rate: map["rate"],
      payable_amount: map["payable_amount"],
      comment: map["comment"],
      review_note: map["review_note"],
      review_proof: map["review_proof"],
      review_rate: map["review_rate"],
      reviewed_by: map["reviewed_by"],
      reviewed_at: map["reviewed_at"],
      created_at: map["created_at"],
      updated_at: map["updated_at"],
      deleted_at: map["deleted_at"],
      bank: map["bank"] != null ? Bank.fromMap(map["bank"]) : null,
      giftcard_product: map["giftcard_product"] != null
          ? GiftcardProduct.fromMap(map["giftcard_product"])
          : null,
      cards: map["cards"] == null
          ? []
          : (map["cards"] as List).map((e) => GiftcardCard.fromMap(e)).toList(),
      children_count: map["children_count"] ?? 0,
      related_giftcards: map["related_giftcards"] ?? relatedGiftcard,
      review_amount: map["review_amount"],
    );
  }
}

class GiftcardCard {
  final dynamic uuid;
  final dynamic file_name;
  final dynamic mime_type;
  final String original_url;
  final dynamic size;

  GiftcardCard({
    required this.uuid,
    required this.file_name,
    required this.mime_type,
    required this.original_url,
    required this.size,
  });

  factory GiftcardCard.fromMap(Map<String, dynamic> map) {
    return GiftcardCard(
      file_name: map["file_name"],
      mime_type: map["mime_type"],
      original_url: map["original_url"] ?? "",
      size: map["size"],
      uuid: map["uuid"],
    );
  }
}
