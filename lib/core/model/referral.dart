class Referral {
  final String id;
  final String referee_id;
  final String referred_id;
  final String amount;
  final bool paid;
  final String created_at;
  final String updated_at;
  final Referred referred;

  Referral({
    required this.id,
    required this.referee_id,
    required this.referred_id,
    required this.amount,
    required this.paid,
    required this.created_at,
    required this.updated_at,
    required this.referred,
  });

  factory Referral.fromMap(Map<String, dynamic> map) {
    return Referral(
      id: map['id'] ?? "",
      referee_id: map['referee_id'] ?? "",
      referred_id: map['referred_id'] ?? "",
      amount: map['amount'] ?? "",
      paid: map['paid'] ?? false,
      created_at: map['created_at'] ?? "",
      updated_at: map['updated_at'] ?? "",
      referred: Referred.fromMap(map["referred"]),
    );
  }
}

class Referred {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final String avatar;

  Referred({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.avatar,
  });

  factory Referred.fromMap(Map<String, dynamic> map) {
    return Referred(
      id: map["id"] ?? "",
      firstname: map["firstname"] ?? "",
      lastname: map["lastname"] ?? "",
      email: map["email"] ?? "",
      avatar: map["avatar"] ?? "",
    );
  }
}
