import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:jimmy_exchange/core/constants.dart';
import 'package:jimmy_exchange/core/model/all_txn_history.dart';
import 'package:jimmy_exchange/presentation/resources/route_arg/crypto_arg.dart';

import '../errors.dart';
import '../model/asset_transaction.dart';
import '../model/crypto_txn_history.dart';
import '../model/giftcard_txn_history.dart';
import '../model/wallet_txn_history.dart';
import '../services/http_request.dart';

class TransactionHelper {
  static Future<(String, WalletTxnHistory)> requestWithdrawal(
      {required String user_bank_account_id,
      required String amount,
      required String transaction_pin}) async {
    http.Response response =
        await HttpRequest.post("/user/wallet-transactions/withdraw", {
      "user_bank_account_id": user_bank_account_id,
      "amount": amount,
      "transaction_pin": transaction_pin
    }).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode < 400) {
      ////
      var walletTxnHistory = res['data']['wallet_transaction'];
      String message = res["message"];
      WalletTxnHistory data = WalletTxnHistory.fromMap(walletTxnHistory);

      return (message, data);
    } else {
      throw res["message"] ?? " An error occurred. please try again.";
    }
  }

  /// CRYPTO
  static Future<CryptoBreakDown> getCryptoBreakdown(
      {required String trade_type,
      required String asset_id,
      required String asset_amount}) async {
    http.Response response = await HttpRequest.post(
      "/user/asset-transactions/breakdown",
      {
        "trade_type": trade_type,
        "asset_id": asset_id,
        "asset_amount": asset_amount
      },
    ).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode < 400) {
      return CryptoBreakDown.fromMap(res["data"]["breakdown"]);
    } else {
      throw res["message"] ?? " An error occurred. please try again.";
    }
  }

  static Future<AssetTransaction> createCryptoTxn({
    required String trade_type,
    required String asset_id,
    required String network_id,
    required String asset_amount,
    required String transaction_pin,
    required String comment,
    required String? wallet_address,
    required String? wallet_address_confirmation,
    required String? user_bank_account_id,
  }) async {
    Map<String, dynamic> body = {
      "trade_type": trade_type,
      "asset_id": asset_id,
      "network_id": network_id,
      "asset_amount": asset_amount,
      "comment": comment,
      "transaction_pin": transaction_pin
    };
    if (wallet_address != null) {
      body["wallet_address"] = wallet_address;
    }
    if (wallet_address_confirmation != null) {
      body["wallet_address_confirmation"] = wallet_address_confirmation;
    }
    if (user_bank_account_id != null) {
      body["user_bank_account_id"] = user_bank_account_id;
    }

    http.Response response =
        await HttpRequest.post("/user/asset-transactions", body)
            .catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode < 400) {
      return AssetTransaction.fromMap(res["data"]["asset_transaction"]);
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  static Future<String> uploadCryptoTransactionProof(String imageUrl,
      {required String assetTransactionId}) async {
    List<MultipartFile>? bodyFiles = [];

    http.StreamedResponse response = await HttpRequest.uploadFile(
      "/user/asset-transactions/$assetTransactionId/transfer",
      {"_method": "PATCH", "proof": imageUrl},
      method: "POST",
      bodyFiles: bodyFiles,
    ).catchError((err) {
      throw OtherErrors(err);
    });

    final respStr = await response.stream.bytesToString();

    if (response.statusCode == 413) throw "Image size is too large";
    var res = {};
    try {
      res = json.decode(respStr);
    } catch (_) {}

    if (response.statusCode < 400) {
      return res["message"];
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  static Future<Map<String, dynamic>> getCryptoStats() async {
    http.Response response =
        await HttpRequest.get("/user/asset-transactions/stats")
            .catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      return res["data"]["stats"][0];
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  static Future<List<CryptoTxnHistory>> getCryptoTxnHistory(
      String? urlQuery) async {
    http.Response response =
        await HttpRequest.get("/user/asset-transactions$urlQuery")
            .catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      List data = res["data"]["asset_transactions"]["data"];
      return data.map((e) => CryptoTxnHistory.fromMap(e)).toList();
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  static Future<CryptoTxnHistory> getCryptoTxnHistoryDetails(
      String? urlQuery) async {
    http.Response response =
        await HttpRequest.get("/user/asset-transactions$urlQuery")
            .catchError((err) {
      throw OtherErrors(err);
    });
    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      return CryptoTxnHistory.fromMap(res["data"]["asset_transaction"]);
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  static Future<List<WalletTxnHistory>> getWalletTxnHistory(
      String? urlQuery) async {
    if (urlQuery != null) {
      urlQuery = urlQuery.replaceAll("payable_amount", "amount");
    }

    http.Response response =
        await HttpRequest.get("/user/wallet-transactions$urlQuery")
            .catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode < 400) {
      List data = res["data"]["wallet_transactions"]["data"];
      return data.map((e) => WalletTxnHistory.fromMap(e)).toList();
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  static Future<WalletTxnHistory> getWalletTxnHistoryDetails(
      String? urlQuery) async {
    http.Response response =
        await HttpRequest.get("/user/wallet-transactions$urlQuery")
            .catchError((err) {
      throw OtherErrors(err);
    });
    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      return WalletTxnHistory.fromMap(res["data"]["wallet_transaction"]);
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  static Future<Map<String, dynamic>> getGiftcardBreakdown(
      String giftcard_product_id, String trade_type, String amount) async {
    http.Response response =
        await HttpRequest.post("/user/giftcards/breakdown", {
      "giftcard_product_id": giftcard_product_id,
      "trade_type": trade_type,
      "amount": amount
    }).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      return res["data"]["breakdown"];
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  static Future<String> createGiftcardSale({
    required String giftcard_product_id,
    required String user_bank_account_id,
    required String card_type,
    required String amount,
    required String quantity,
    required String comment,
    required String transaction_pin,
    required String upload_type,
    //
    required List<String> imgs,
    required List<String> virtualCode,
    required List<String> virtualPin,
  }) async {
    Map<String, dynamic> body = {
      "giftcard_product_id": giftcard_product_id,
      "user_bank_account_id": user_bank_account_id,
      "card_type": card_type,
      "amount": amount,
      "quantity": quantity,
      "comment": comment,
      "transaction_pin": transaction_pin,
      "upload_type": upload_type,
    };

    int count = 0;
    List<MultipartFile>? bodyFiles = [];

    if (upload_type == "media") {
      for (final String el in imgs) {
        body["cards[${count.toString()}]"] = el;
        count += 1;

        // IMPLEMENTATION DEPRECATED
        // http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        //     'cards[${count.toString()}]', el.path);
        // bodyFiles.add(multipartFile);
      }

      //
    } else {
      for (var i = 0; i < (int.tryParse(quantity) ?? 0); i++) {
        body["codes[${count.toString()}]"] = virtualCode[count];
        body["pins[${count.toString()}]"] = virtualPin[count];
        count += 1;
      }
    }

    String url = "/user/giftcards/sale";
    http.StreamedResponse res = await HttpRequest.uploadFile(url, body,
            bodyFiles: bodyFiles, method: 'POST')
        .catchError((err) {
      throw OtherErrors(err);
    });

    final respStr = await res.stream.bytesToString();
    Map decodedRes = json.decode(respStr);

    if (res.statusCode < 400) {
      return decodedRes["message"];
    } else {
      throw decodedRes["message"];
    }
  }

  static Future<List<GiftcardTxnHistory>> getGiftcardTxnHistory(
      String? urlQuery) async {
    http.Response response =
        await HttpRequest.get("/user/giftcards$urlQuery").catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      List data = res["data"]["giftcards"]["data"];
      return data.map((e) => GiftcardTxnHistory.fromMap(e)).toList();
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  static Future<Map<String, dynamic>> getGiftcardStats() async {
    http.Response response =
        await HttpRequest.get("/user/giftcards/stats").catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      return res["data"]["stats"][0];
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  static Future<GiftcardTxnHistory> getGiftcardTxnHistoryDetails(
      String? urlQuery) async {
    http.Response response =
        await HttpRequest.get("/user/giftcards$urlQuery").catchError((err) {
      throw OtherErrors(err);
    });
    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      var data = res["data"]["giftcard"];
      List<GiftcardTxnHistory> relatedGiftcard = [];
      (res["data"]["related_giftcards"] as List).forEach((item) {
        relatedGiftcard.add(GiftcardTxnHistory.fromMap(item));
      });

      data["related_giftcards"] = relatedGiftcard;
      return GiftcardTxnHistory.fromMap(data);
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  static Future<Map<String, dynamic>> getSystemData(String code) async {
    http.Response response =
        await HttpRequest.get("/system-data/$code").catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode < 400) {
      return res["data"]["system_data"];
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  static Future<List<AllTxnHistory>> getAllTxnHistory(String? urlQuery) async {
    String? type;

    if (urlQuery != null) {
      if (urlQuery.contains("type")) {
        type = urlQuery.split("filter[type]=").last;
        if (type == Constants.kCryptoTransaction) {
          type = Constants.kCryptoTxnTypeValue;
        }
      }
    }

    http.Response response =
        await HttpRequest.get("/user/transactions$urlQuery").catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode < 400) {
      List data = res["data"]["records"]["data"] ?? [];
      List<AllTxnHistory> result = [];

      if (type == null) {
        return data.map((e) => AllTxnHistory.fromMap(e)).toList();
      } else {
        for (int i = 0; i < data.length; i++) {
          try {
            var el = data[i];
            if (el["type"] == type) {
              result.add(AllTxnHistory.fromMap(el));
            }
          } catch (_) {}
        }
      }

      return result;
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  static Future<Map<String, dynamic>> getAllTxnStats() async {
    http.Response response =
        await HttpRequest.get("/user/transactions?page=1&per_page=2")
            .catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode < 400) {
      List data = res["data"]["stats"] ?? [];
      Map<String, dynamic> result = {
        "total_transactions_count": 0,
        "total_transactions_amount": 0,
      };
      for (int i = 0; i < data.length; i++) {
        try {
          var el = data[i];
          result["total_transactions_count"] =
              result["total_transactions_count"] +
                  el["total_transactions_count"];
          result["total_transactions_amount"] =
              result["total_transactions_amount"] +
                  el["total_transactions_amount"];
        } catch (_) {}
      }

      return result;
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }
}
