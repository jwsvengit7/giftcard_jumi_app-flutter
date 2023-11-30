import 'package:jimmy_exchange/core/model/asset.dart';
import 'package:jimmy_exchange/core/model/network.dart';

class CryptoTxnHistory {
  final String? id;
  final String? network_id;
  final String? asset_id;
  final String? user_id;
  final String? user_bank_account_id;
  final String? reference;
  final String? wallet_address;
  final num? asset_amount;
  final num? rate;
  final num? service_charge;
  final String? status;
  final String? trade_type;
  final String? comment;
  final String? proof;
  final num? payable_amount;
  final String? review_note;
  final List<dynamic>? review_proof;
  final dynamic review_rate;
  final String? reviewed_by;
  final String? reviewed_at;
  final String? created_at;
  final String? updated_at;
  final String? deleted_at;
  final Network? network;
  final Asset? asset;
  final num? review_amount;

  CryptoTxnHistory({
    this.id,
    this.network_id,
    this.asset_id,
    this.user_id,
    this.user_bank_account_id,
    this.reference,
    this.wallet_address,
    this.asset_amount,
    this.rate,
    this.service_charge,
    this.status,
    this.trade_type,
    this.comment,
    this.proof,
    this.payable_amount,
    this.review_note,
    this.review_proof,
    this.review_rate,
    this.reviewed_by,
    this.reviewed_at,
    this.created_at,
    this.updated_at,
    this.deleted_at,
    this.network,
    this.asset,
    this.review_amount,
  });

  factory CryptoTxnHistory.fromMap(Map<String, dynamic> map) {
    return CryptoTxnHistory(
      id: map['id'],
      network_id: map["network_id"],
      asset_id: map["asset_id"],
      user_id: map["user_id"],
      user_bank_account_id: map["user_bank_account_id"],
      reference: map["reference"],
      wallet_address: map["wallet_address"],
      asset_amount: map["asset_amount"],
      rate: map['rate'],
      service_charge: map["service_charge"],
      status: map["status"],
      trade_type: map["trade_type"],
      comment: map["comment"],
      proof: map["proof"],
      payable_amount: map["payable_amount"],
      review_note: map["review_note"],
      review_proof: map["review_proof"],
      review_rate: map["review_rate"],
      reviewed_by: map["reviewed_by"],
      reviewed_at: map["reviewed_at"],
      created_at: map["created_at"],
      updated_at: map["updated_at"],
      deleted_at: map["deleted_at"],
      network: map['network'] != null ? Network.fromMap(map['network']) : null,
      asset: map["asset"] != null ? Asset.fromMap(map["asset"]) : null,
      review_amount: map["review_amount"],
    );
  }
}
