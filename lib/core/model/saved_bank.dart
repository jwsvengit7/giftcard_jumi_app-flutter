import 'package:jimmy_exchange/core/model/bank.dart';

class SavedBank {
  final String? id;
  final String? bank_id;
  final String? user_id;
  final String? account_number;
  final String? account_name;
  final String? created_at;
  final String? updated_at;
  final String? deleted_at;
  final Bank? bank;

  SavedBank(
      {this.id,
      this.bank_id,
      this.user_id,
      this.account_number,
      this.account_name,
      this.created_at,
      this.updated_at,
      this.deleted_at,
      this.bank});

  factory SavedBank.fromMap(Map<String, dynamic> map) {
    return SavedBank(
      id: map['id'],
      account_name: map['account_name'],
      account_number: map['account_number'],
      bank: Bank.fromMap(map['bank']),
      bank_id: map['bank_id'],
      created_at: map['created_at'],
      deleted_at: map['created_at'],
      updated_at: map['updated_at'],
      user_id: map['user_id'],
    );
  }
}
