import '../../../core/model/asset_transaction.dart';
import 'crypto_arg.dart';

class SellCryptoDetailsArg {
  final Future<AssetTransaction> Function(String transaction_pin)
      createTransaction;
  final CryptoSaleArg cryptoSaleArg;

  SellCryptoDetailsArg(
      {required this.createTransaction, required this.cryptoSaleArg});
}

class ConfirmCryptoTxnArg {
  final Future<AssetTransaction> Function(String transaction_pin)
      createTransaction;
  final String trade_type;

  ConfirmCryptoTxnArg({
    required this.createTransaction,
    required this.trade_type,
  });
}
