import 'package:jimmy_exchange/core/model/bank.dart';

class WalletTxnHistory {
  String? id;
  String? userType;
  String? userId;
  String? causerType;
  String? bankId;
  String? accountNumber;
  String? accountName;
  String? causerId;
  String? service;
  String? type;
  String? status;
  int? amount;
  dynamic comment;
  String? summary;
  dynamic adminNote;
  dynamic receipt;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  final Bank? bank;

  WalletTxnHistory({
    this.id,
    this.userType,
    this.userId,
    this.causerType,
    this.bankId,
    this.accountNumber,
    this.accountName,
    this.causerId,
    this.service,
    this.type,
    this.status,
    this.amount,
    this.comment,
    this.summary,
    this.adminNote,
    this.receipt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.bank,
  });

  factory WalletTxnHistory.fromMap(Map<String, dynamic> json) {
    return WalletTxnHistory(
      id: json["id"],
      userType: json["user_type"],
      userId: json["user_id"],
      causerType: json["causer_type"],
      bankId: json["bank_id"],
      accountNumber: json["account_number"],
      accountName: json["account_name"],
      causerId: json["causer_id"],
      service: json["service"],
      type: json["type"],
      status: json["status"],
      amount: json["amount"],
      comment: json["comment"],
      summary: json["summary"],
      adminNote: json["admin_note"],
      receipt: json["receipt"],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      bank: json['bank'] != null ? Bank.fromMap(json['bank']) : null,
    );
  }
}
