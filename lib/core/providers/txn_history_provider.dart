import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/helpers/transaction_helper.dart';
import '../model/all_txn_history.dart';
import '../model/crypto_txn_history.dart';
import '../model/giftcard_txn_history.dart';
import '../model/wallet_txn_history.dart';

class TxnHistoryProvider with ChangeNotifier {
  // CryptoTxnHistory
  List<CryptoTxnHistory> _cryptoTxnHistory = [];
  List<CryptoTxnHistory> _cryptoTxnSaleHistory = [];
  List<CryptoTxnHistory> _cryptoTxnBuyHistory = [];

  List<CryptoTxnHistory> get cryptoTxnHistory => _cryptoTxnHistory;
  List<CryptoTxnHistory> get cryptoTxnSaleHistory => _cryptoTxnSaleHistory;
  List<CryptoTxnHistory> get cryptoTxnBuyHistory => _cryptoTxnBuyHistory;
  Future<void> updateCryptoTxnHistory() async {
    await TransactionHelper.getCryptoTxnHistory(
      "?include=network,asset&page=1&per_page=10",
    ).then((value) {
      _cryptoTxnHistory = value;
      _cryptoTxnSaleHistory = [];
      _cryptoTxnBuyHistory = [];
      for (final CryptoTxnHistory e in value) {
        if (e.trade_type?.toLowerCase() == "buy") {
          _cryptoTxnBuyHistory.add(e);
        } else {
          _cryptoTxnSaleHistory.add(e);
        }
      }

      notifyListeners();
    }).catchError((e) {
      // recordError();
    });
  }

  Map<String, dynamic> _cryptoStats = {};
  Future<void> updateCryptoStat() async {
    await TransactionHelper.getCryptoStats().then((value) {
      _cryptoStats = value;
      notifyListeners();
    }).catchError((e) {
      // print("error $e");
      // recordError();
    });
  }

  num getCryptoPartailAndApprovedBuyCount() {
    num toalApproved =
        _cryptoStats["total_approved_buy_count"] ?? num.parse("0");
    num toalPartial =
        _cryptoStats["total_partially_approved_buy_count"] ?? num.parse("0");
    return toalApproved + toalPartial;
  }

  num getCryptoPartailAndApprovedBuyAmount() {
    num toalApproved =
        _cryptoStats["total_approved_buy_amount"] ?? num.parse("0");
    num toalPartial =
        _cryptoStats["total_partially_approved_buy_amount"] ?? num.parse("0");
    return toalApproved + toalPartial;
  }

  num getCryptoPartailAndApprovedSoldCount() {
    num toalApproved =
        _cryptoStats["total_approved_sell_count"] ?? num.parse("0");
    num toalPartial =
        _cryptoStats["total_partially_approved_sell_count"] ?? num.parse("0");
    return toalApproved + toalPartial;
  }

  num getCryptoPartailAndApprovedSoldAmount() {
    num toalApproved =
        _cryptoStats["total_approved_sell_amount"] ?? num.parse("0");
    num toalPartial =
        _cryptoStats["total_partially_approved_sell_amount"] ?? num.parse("0");
    return toalApproved + toalPartial;
  }

  //
  //

  ///
  /// Wallet Transaction History
  List<WalletTxnHistory> _walletTxnHistory = [];
  List<WalletTxnHistory> get walletTxnHistory => _walletTxnHistory;
  Future<void> updateWalletTxnHistory() async {
    await TransactionHelper.getWalletTxnHistory(
            "?include=bank&page=1&per_page=100")
        .then((value) {
      _walletTxnHistory = value;
      notifyListeners();
    }).catchError((e) {
      // recordError();
    });
  }

  // Giftcard transaction
  List<GiftcardTxnHistory> _giftcardTxnHistory = [];
  List<GiftcardTxnHistory> _giftcardTxnSaleHistory = [];
  List<GiftcardTxnHistory> _giftcardTxnBuyHistory = [];

  List<GiftcardTxnHistory> get giftcardTxnHistory => _giftcardTxnHistory;
  List<GiftcardTxnHistory> get giftcardTxnSaleHistory =>
      _giftcardTxnSaleHistory;
  List<GiftcardTxnHistory> get giftcardTxnBuyHistory => _giftcardTxnBuyHistory;
  Future<void> updateGiftcardTxnHistory() async {
    await TransactionHelper.getGiftcardTxnHistory(
      "?include=bank,giftcardProduct&page=1&per_page=10",
    ).then((value) {
      _giftcardTxnHistory = value;
      _giftcardTxnSaleHistory = [];
      _giftcardTxnBuyHistory = [];
      for (final GiftcardTxnHistory e in value) {
        if (e.trade_type?.toLowerCase() == "buy") {
          _giftcardTxnBuyHistory.add(e);
        } else {
          _giftcardTxnSaleHistory.add(e);
        }
      }

      notifyListeners();
    }).catchError((e) {
      // recordError();
    });
  }

  Map<String, dynamic> _giftcardStats = {};
  Future<void> updateGiftcardStats() async {
    await TransactionHelper.getGiftcardStats().then((value) {
      _giftcardStats = value;
      notifyListeners();
    }).catchError((e) {});
  }

  num getGiftCardPartailAndApprovedBuyCount() {
    num toalApproved =
        _giftcardStats["total_approved_buy_count"] ?? num.parse("0");
    num toalPartial =
        _giftcardStats["total_partially_approved_buy_count"] ?? num.parse("0");
    return toalApproved + toalPartial;
  }

  num getGiftCardPartailAndApprovedBuyAmount() {
    num toalApproved =
        _giftcardStats["total_approved_buy_amount"] ?? num.parse("0");
    num toalPartial =
        _giftcardStats["total_partially_approved_buy_amount"] ?? num.parse("0");
    return toalApproved + toalPartial;
  }

  num getGiftCardPartailAndApprovedSoldCount() {
    num toalApproved =
        _giftcardStats["total_approved_sell_count"] ?? num.parse("0");
    num toalPartial =
        _giftcardStats["total_partially_approved_sell_count"] ?? num.parse("0");
    return toalApproved + toalPartial;
  }

  num getGiftCardPartailAndApprovedSoldAmount() {
    num toalApproved =
        _giftcardStats["total_approved_sell_amount"] ?? num.parse("0");
    num toalPartial = _giftcardStats["total_partially_approved_sell_amount"] ??
        num.parse("0");
    return toalApproved + toalPartial;
  }

  // All Transactions
  List<AllTxnHistory> _allTxnHistory = [];
  List<AllTxnHistory> get allTxnHistory => _allTxnHistory;
  Future<void> updateAllTxnHistory() async {
    await TransactionHelper.getAllTxnHistory("?page=1&per_page=5")
        .then((value) {
      _allTxnHistory = value;
      notifyListeners();
    }).catchError((e) {
      // recordError();
    });
  }

  Map<String, dynamic> _allTxnStats = {};
  // Map<String, dynamic> get allTxnStats => _allTxnStats;
  Future<void> updateAllTxnStats() async {
    await TransactionHelper.getAllTxnStats().then((value) {
      _allTxnStats = value;
      notifyListeners();
    }).catchError((e) {
      // print("error $e");
      // recordError();
    });
  }

  num getTotalTxnCount() {
    return _allTxnStats["total_transactions_count"] ?? num.parse("0");
  }

  num getTotalTxnAmount() {
    return _allTxnStats["total_transactions_amount"] ?? num.parse("0");
  }
}
