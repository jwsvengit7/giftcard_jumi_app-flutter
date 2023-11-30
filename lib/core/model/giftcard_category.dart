import 'country.dart';

class GiftcardCategory {
  final String? id;
  final String? name;
  final String? icon;
  final String? sale_term;
  final String? sale_activated_at;
  final List<Country>? countries;

  GiftcardCategory({
    this.id,
    this.name,
    this.icon,
    this.sale_term,
    this.countries,
    this.sale_activated_at,
  });

  factory GiftcardCategory.fromMap(Map<String, dynamic> map) {
    return GiftcardCategory(
      id: map['id'],
      name: map['name'],
      icon: map['icon'],
      sale_term: map['sale_term'],
      countries: ((map["countries"] ?? []) as List)
          .map((e) => Country.fromMap(e))
          .toList(),
      sale_activated_at: map["sale_activated_at"],
    );
  }
}
