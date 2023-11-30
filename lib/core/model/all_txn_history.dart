class AllTxnHistory {
  final String? id;
  final String? type;
  final String? reference;
  final String? status;
  final String? trade_type;
  final num? amount;
  final num? rate;
  final num? review_rate;
  final num? payable_amount;
  final num? service_charge;
  final String? category_name;
  final String? category_icon;
  final String? created_at;
  final String? currency;
  final num? review_amount;

  AllTxnHistory({
    required this.id,
    required this.type,
    required this.reference,
    required this.status,
    required this.trade_type,
    required this.amount,
    required this.payable_amount,
    required this.category_name,
    required this.category_icon,
    required this.created_at,
    required this.currency,
    required this.rate,
    required this.review_rate,
    required this.service_charge,
    this.review_amount,
  });

  factory AllTxnHistory.fromMap(Map<String, dynamic> map) {
    return AllTxnHistory(
      id: map['id'],
      currency: map["currency"],
      type: map['type'],
      reference: map["reference"],
      status: map["status"],
      trade_type: map["trade_type"],
      amount: map["amount"],
      payable_amount: map["payable_amount"],
      category_name: map["category_name"],
      category_icon: map["category_icon"],
      created_at: map["created_at"],
      rate: map["rate"],
      review_rate: map["review_rate"],
      service_charge: map["service_charge"],
      review_amount: map["review_amount"],
    );
  }
}
