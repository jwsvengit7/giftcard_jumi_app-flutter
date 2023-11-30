class Country {
  final String? id;
  final String? name;
  final String? alpha2Code;
  final String? alpha3Code;
  final String? flagUrl;
  final String? dialing_code;
  final Map<String, dynamic>? pivot;
  Country({
    this.id,
    this.name,
    this.alpha2Code,
    this.alpha3Code,
    this.flagUrl,
    this.dialing_code,
    this.pivot,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'alpha2_code': alpha2Code,
      'alpha3_code': alpha3Code,
      'flagUrl': flagUrl,
      'dialing_code': dialing_code,
      'pivot': pivot
    };
  }

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      id: map['id'],
      name: map['name'],
      alpha2Code: map['alpha2_code'],
      alpha3Code: map['alpha3_code'],
      flagUrl: map['flag_url'],
      dialing_code: map['dialing_code'],
      pivot: map["pivot"],
    );
  }

  @override
  String toString() => toMap()['name'];
}
