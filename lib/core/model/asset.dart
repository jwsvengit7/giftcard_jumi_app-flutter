class Asset {
  final String? id;
  final String? code;
  final String? name;
  final String? icon;
  final num? buy_rate;
  final num? sell_rate;
  final num? sell_min_amount;
  final num? sell_max_amount;
  final num? buy_min_amount;
  final num? buy_max_amount;

  Asset({
    this.id,
    this.code,
    this.name,
    this.icon,
    this.buy_rate,
    this.sell_rate,
    this.sell_min_amount,
    this.sell_max_amount,
    this.buy_min_amount,
    this.buy_max_amount,
  });

  factory Asset.fromMap(Map<String, dynamic> map) {
    return Asset(
      id: map['id'],
      name: map["name"],
      code: map["code"],
      buy_rate: map["buy_rate"],
      icon: map["icon"],
      sell_rate: map["sell_rate"],
      sell_min_amount: map["sell_min_amount"],
      sell_max_amount: map["sell_max_amount"],
      buy_min_amount: map["buy_min_amount"],
      buy_max_amount: map["buy_max_amount"],
    );
  }
}
