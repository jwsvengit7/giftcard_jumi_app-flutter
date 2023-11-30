import 'package:jimmy_exchange/core/model/asset.dart';
import 'package:jimmy_exchange/core/model/network.dart';
import 'package:jimmy_exchange/core/model/saved_bank.dart';

class CryptoBuyArg {
  final Network network;
  final Asset asset;
  final String units;
  final String comment;
  final String wallet_address;
  final CryptoBreakDown breakDown;
  final String? amount;
  final num? rate;

  CryptoBuyArg({
    required this.network,
    required this.asset,
    required this.units,
    required this.comment,
    required this.wallet_address,
    required this.breakDown,
    required this.amount,
    required this.rate,
  });
}

class CryptoBreakDown {
  final num rate;
  final num service_charge;
  final num payable_amount;

  CryptoBreakDown({
    required this.rate,
    required this.service_charge,
    required this.payable_amount,
  });

  factory CryptoBreakDown.fromMap(Map<String, dynamic> map) {
    return CryptoBreakDown(
      rate: map['rate'] ?? 0,
      service_charge: map["service_charge"] ?? 0,
      payable_amount: map["payable_amount"] ?? 0,
    );
  }
}

class CryptoSaleArg {
  final SavedBank savedBank;
  final Network network;
  final Asset asset;
  final String units;
  final String comment;
  final CryptoBreakDown breakDown;
  final String? amount;
  final num? rate;
  final num? usd_exchange_rate_to_ngn;

  CryptoSaleArg({
    required this.savedBank,
    required this.network,
    required this.asset,
    required this.units,
    required this.comment,
    required this.breakDown,
    required this.amount,
    required this.rate,
    required this.usd_exchange_rate_to_ngn,
  });
}
