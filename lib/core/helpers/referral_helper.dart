import 'dart:convert';
import 'package:http/http.dart' as http;
import '../errors.dart';
import '../model/referral.dart';
import '../services/http_request.dart';

class ReferralHelper {
  static Future<Map<String, dynamic>> getReferralsWithMeta(
      String? urlQuery) async {
    http.Response response =
        await HttpRequest.get("/user/referrals$urlQuery").catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      List data = res["data"]["referrals"]["data"];
      List<Referral> referral = data.map((e) => Referral.fromMap(e)).toList();

      return {
        "referral": referral,
        "meta": {
          "total_referrals": res["data"]["total_referrals"],
          "total_trade": res["data"]["total_trade"],
          "total_reward": res["data"]["total_reward"],
        }
      };
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  static Future<List<Referral>> getReferrals(String? urlQuery) async {
    http.Response response =
        await HttpRequest.get("/user/referrals$urlQuery").catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      List data = res["data"]["referrals"]["data"];
      return data.map((e) => Referral.fromMap(e)).toList();
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  // static Future<CryptoTxnHistory> getCryptoTxnHistoryDetails(
  //     String? urlQuery) async {
  //   http.Response response =
  //       await HttpRequest.get("/user/asset-transactions$urlQuery")
  //           .catchError((err) {
  //     throw OtherErrors(err);
  //   });
  //   Map res = json.decode(response.body);
  //   if (response.statusCode < 400) {
  //     return CryptoTxnHistory.fromMap(res["data"]["asset_transaction"]);
  //   } else {
  //     throw res["message"] ?? " An error occured. please try again.";
  //   }
  // }

  // static Future<List<WalletTxnHistory>> getWalletTxnHistory(
  //     String? urlQuery) async {
  //   if (urlQuery != null) {
  //     urlQuery = urlQuery.replaceAll("payable_amount", "amount");
  //   }

  //   http.Response response =
  //       await HttpRequest.get("/user/wallet-transactions$urlQuery")
  //           .catchError((err) {
  //     throw OtherErrors(err);
  //   });

  //   Map res = json.decode(response.body);

  //   if (response.statusCode < 400) {
  //     List data = res["data"]["wallet_transactions"]["data"];
  //     return data.map((e) => WalletTxnHistory.fromMap(e)).toList();
  //   } else {
  //     throw res["message"] ?? " An error occured. please try again.";
  //   }
  // }

  // static Future<WalletTxnHistory> getWalletTxnHistoryDetails(
  //     String? urlQuery) async {
  //   http.Response response =
  //       await HttpRequest.get("/user/wallet-transactions$urlQuery")
  //           .catchError((err) {
  //     throw OtherErrors(err);
  //   });
  //   Map res = json.decode(response.body);
  //   if (response.statusCode < 400) {
  //     return WalletTxnHistory.fromMap(res["data"]["wallet_transaction"]);
  //   } else {
  //     throw res["message"] ?? " An error occured. please try again.";
  //   }
  // }

  // static Future<Map<String, dynamic>> getGiftcardBreakdown(
  //     String giftcard_product_id, String trade_type, String amount) async {
  //   http.Response response =
  //       await HttpRequest.post("/user/giftcards/breakdown", {
  //     "giftcard_product_id": giftcard_product_id,
  //     "trade_type": trade_type,
  //     "amount": amount
  //   }).catchError((err) {
  //     throw OtherErrors(err);
  //   });

  //   Map res = json.decode(response.body);
  //   if (response.statusCode < 400) {
  //     return res["data"]["breakdown"];
  //   } else {
  //     throw res["message"] ?? " An error occured. please try again.";
  //   }
  // }

  // static Future<String> createGiftcardSale({
  //   required String giftcard_product_id,
  //   required String user_bank_account_id,
  //   required String card_type,
  //   required String amount,
  //   required String quantity,
  //   required String comment,
  //   required String transaction_pin,
  //   required String upload_type,
  //   //
  //   required List<String> imgs,
  //   required List<String> virtualCode,
  //   required List<String> virtualPin,
  // }) async {
  //   Map<String, dynamic> body = {
  //     "giftcard_product_id": giftcard_product_id,
  //     "user_bank_account_id": user_bank_account_id,
  //     "card_type": card_type,
  //     "amount": amount,
  //     "quantity": quantity,
  //     "comment": comment,
  //     "transaction_pin": transaction_pin,
  //     "upload_type": upload_type,
  //   };

  //   int count = 0;
  //   List<MultipartFile>? bodyFiles = [];

  //   if (upload_type == "media") {
  //     for (final String el in imgs) {
  //       body["cards[${count.toString()}]"] = el;
  //       count += 1;

  //       // IMPLEMENTATION DEPRECATED
  //       // http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
  //       //     'cards[${count.toString()}]', el.path);
  //       // bodyFiles.add(multipartFile);
  //     }

  //     //
  //   } else {
  //     for (var i = 0; i < (int.tryParse(quantity) ?? 0); i++) {
  //       body["codes[${count.toString()}]"] = virtualCode[count];
  //       body["pins[${count.toString()}]"] = virtualPin[count];
  //       count += 1;
  //     }
  //   }

  //   String url = "/user/giftcards/sale";
  //   http.StreamedResponse res = await HttpRequest.uploadFile(url, body,
  //           bodyFiles: bodyFiles, method: 'POST')
  //       .catchError((err) {
  //     throw OtherErrors(err);
  //   });

  //   final respStr = await res.stream.bytesToString();
  //   Map decodedRes = json.decode(respStr);

  //   if (res.statusCode < 400) {
  //     return decodedRes["message"];
  //   } else {
  //     throw decodedRes["message"];
  //   }
  // }

  // static Future<List<GiftcardTxnHistory>> getGiftcardTxnHistory(
  //     String? urlQuery) async {
  //   http.Response response =
  //       await HttpRequest.get("/user/giftcards$urlQuery").catchError((err) {
  //     throw OtherErrors(err);
  //   });

  //   Map res = json.decode(response.body);
  //   if (response.statusCode < 400) {
  //     List data = res["data"]["giftcards"]["data"];
  //     return data.map((e) => GiftcardTxnHistory.fromMap(e)).toList();
  //   } else {
  //     throw res["message"] ?? " An error occured. please try again.";
  //   }
  // }

  // static Future<Map<String, dynamic>> getGiftcardStats() async {
  //   http.Response response =
  //       await HttpRequest.get("/user/giftcards/stats").catchError((err) {
  //     throw OtherErrors(err);
  //   });

  //   Map res = json.decode(response.body);
  //   if (response.statusCode < 400) {
  //     return res["data"]["stats"][0];
  //   } else {
  //     throw res["message"] ?? " An error occured. please try again.";
  //   }
  // }

  // static Future<GiftcardTxnHistory> getGiftcardTxnHistoryDetails(
  //     String? urlQuery) async {
  //   http.Response response =
  //       await HttpRequest.get("/user/giftcards$urlQuery").catchError((err) {
  //     throw OtherErrors(err);
  //   });
  //   Map res = json.decode(response.body);
  //   if (response.statusCode < 400) {
  //     var data = res["data"]["giftcard"];
  //     List<GiftcardTxnHistory> relatedGiftcard = [];
  //     (res["data"]["related_giftcards"] as List).forEach((item) {
  //       relatedGiftcard.add(GiftcardTxnHistory.fromMap(item));
  //     });

  //     data["related_giftcards"] = relatedGiftcard;
  //     return GiftcardTxnHistory.fromMap(data);
  //   } else {
  //     throw res["message"] ?? " An error occured. please try again.";
  //   }
  // }

  // static Future<Map<String, dynamic>> getSystemData(String code) async {
  //   http.Response response =
  //       await HttpRequest.get("/system-data/$code").catchError((err) {
  //     throw OtherErrors(err);
  //   });

  //   Map res = json.decode(response.body);

  //   if (response.statusCode < 400) {
  //     return res["data"]["system_data"];
  //   } else {
  //     throw res["message"] ?? " An error occured. please try again.";
  //   }
  // }

  // static Future<List<AllTxnHistory>> getAllTxnHistory(String? urlQuery) async {
  //   String? type;

  //   if (urlQuery != null) {
  //     if (urlQuery.contains("type")) {
  //       type = urlQuery.split("filter[type]=").last;
  //       if (type == Constants.kCryptoTxnTypeValueAlt) {
  //         type = Constants.kCryptoTxnTypeValue;
  //       }
  //     }
  //   }

  //   http.Response response =
  //       await HttpRequest.get("/user/transactions$urlQuery").catchError((err) {
  //     throw OtherErrors(err);
  //   });

  //   Map res = json.decode(response.body);

  //   if (response.statusCode < 400) {
  //     List data = res["data"]["records"]["data"] ?? [];
  //     List<AllTxnHistory> result = [];

  //     if (type == null) {
  //       return data.map((e) => AllTxnHistory.fromMap(e)).toList();
  //     } else {
  //       for (int i = 0; i < data.length; i++) {
  //         try {
  //           var el = data[i];
  //           if (el["type"] == type) {
  //             result.add(AllTxnHistory.fromMap(el));
  //           }
  //         } catch (_) {}
  //       }
  //     }

  //     return result;
  //   } else {
  //     throw res["message"] ?? " An error occured. please try again.";
  //   }
  // }

  // static Future<Map<String, dynamic>> getAllTxnStats() async {
  //   http.Response response =
  //       await HttpRequest.get("/user/transactions?page=1&per_page=2")
  //           .catchError((err) {
  //     throw OtherErrors(err);
  //   });

  //   Map res = json.decode(response.body);

  //   if (response.statusCode < 400) {
  //     List data = res["data"]["stats"] ?? [];
  //     Map<String, dynamic> result = {
  //       "total_transactions_count": 0,
  //       "total_transactions_amount": 0,
  //     };
  //     for (int i = 0; i < data.length; i++) {
  //       try {
  //         var el = data[i];
  //         result["total_transactions_count"] =
  //             result["total_transactions_count"] +
  //                 el["total_transactions_count"];
  //         result["total_transactions_amount"] =
  //             result["total_transactions_amount"] +
  //                 el["total_transactions_amount"];
  //       } catch (_) {}
  //     }

  //     return result;
  //   } else {
  //     throw res["message"] ?? " An error occured. please try again.";
  //   }
  // }
}
