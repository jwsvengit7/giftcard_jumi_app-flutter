class Currency {
  final String? id;
  final String? name;
  final String? code;
  final num? exchange_rate_to_ngn;

  Currency({this.id, this.name, this.code, this.exchange_rate_to_ngn});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'exchange_rate_to_ngn': exchange_rate_to_ngn,
    };
  }

  factory Currency.fromMap(Map<String, dynamic> map) {
    return Currency(
      id: map['id'],
      name: map['name'],
      code: map['code'],
      exchange_rate_to_ngn: map['exchange_rate_to_ngn'],
    );
  }

  @override
  String toString() => toMap()['name'];
}
