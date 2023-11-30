import 'package:jimmy_exchange/core/model/country.dart';

class User {
  final String? id;
  final String? country_id;
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? email_verified_at;
  final String? username;
  final String? avatar;
  final String? phone_number;
  final num wallet_balance;
  final String? two_fa_activated_at;
  final bool? transaction_pin_set;
  final String? transaction_pin_activated_at;
  final String? blocked_at;
  final String? created_at;
  final String? updated_at;
  final String? deleted_at;
  final String? deleted_reason;
  final Country? country;
  final String? transaction_pin;
  final String? ref_code;

  User({
    this.id,
    this.country_id,
    this.firstname,
    this.lastname,
    this.email,
    this.email_verified_at,
    this.username,
    this.avatar,
    this.phone_number,
    required this.wallet_balance,
    this.two_fa_activated_at,
    this.transaction_pin_set,
    this.transaction_pin_activated_at,
    this.blocked_at,
    this.created_at,
    this.updated_at,
    this.deleted_at,
    this.deleted_reason,
    this.country,
    this.transaction_pin,
    this.ref_code,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map["id"],
      country_id: map["country_id"],
      firstname: map["firstname"],
      lastname: map["lastname"],
      email: map["email"],
      email_verified_at: map["email_verified_at"],
      username: map["username"],
      avatar: "${map["avatar"]}?v=${DateTime.now().millisecondsSinceEpoch}",
      phone_number: map["phone_number"],
      wallet_balance: map["wallet_balance"] ?? 0,
      two_fa_activated_at: map["two_fa_activated_at"],
      transaction_pin_set: map["transaction_pin_set"],
      transaction_pin_activated_at: map["transaction_pin_activated_at"],
      blocked_at: map["blocked_at"],
      created_at: map["created_at"],
      updated_at: map["updated_at"],
      deleted_at: map["deleted_at"],
      deleted_reason: map["deleted_reason"],
      country: map["country"] != null ? Country.fromMap(map['country']) : null,
      transaction_pin: map["transaction_pin"],
      ref_code: map["ref_code"],
    );
  }
}
