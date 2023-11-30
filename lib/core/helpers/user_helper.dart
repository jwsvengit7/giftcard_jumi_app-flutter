import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:jimmy_exchange/core/model/saved_bank.dart';
import '../errors.dart';
import '../model/app_notification.dart';
import '../services/http_request.dart';
import '../model/user.dart';

class UserHelper {
  static Future<String> updateProfile({
    String? username,
    String? firstname,
    String? lastname,
    String? country_id,
    String? email,
    String? phone_number,
  }) async {
    Map<String, dynamic> _body = {};

    if (username != null) {
      _body['username'] = username;
    }
    if (firstname != null) {
      _body['firstname'] = firstname;
    }
    if (lastname != null) {
      _body['lastname'] = lastname;
    }
    if (country_id != null) {
      _body['country_id'] = country_id;
    }
    if (email != null) {
      _body['email'] = email;
    }
    if (phone_number != null) {
      _body['phone_number'] = phone_number;
    }

    http.Response response =
        await HttpRequest.patch("/user/profile", _body).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = {};
    try {
      res = json.decode(response.body);
    } catch (_) {}

    if (response.statusCode < 400) {
      return res['message'];
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  static Future<User> getProfileInformation() async {
    http.Response response = await HttpRequest.get("/user").catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      User user = User.fromMap(res['data']['user']);
      return user;
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  static Future<String> updateProfileAvatar(File file) async {
    http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath('avatar', file.path);
    http.StreamedResponse response = await HttpRequest.uploadFile(
      "/user/profile",
      {"_method": "PATCH"},
      method: "POST",
      bodyFiles: [multipartFile],
    ).catchError((err) {
      throw OtherErrors(err);
    });

    final respStr = await response.stream.bytesToString();

    if (response.statusCode == 413) throw "Image size is too large";
    Map res = json.decode(respStr);

    if (response.statusCode < 400) {
      return res["message"];
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  // Saved Banks
  static Future<List<SavedBank>> getSavedBanks() async {
    //?filter[trashed]=with
    http.Response response =
        await HttpRequest.get("/user/bank-accounts?filter[trashed]=with")
            .catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode < 400) {
      List<SavedBank> result = [];
      for (final Map<String, dynamic> el
          in (res['data']['bank_accounts'] as List)) {
        if (el['deleted_at'] == null) {
          result.add(SavedBank.fromMap(el));
        }
      }

      return result;
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  static Future<String> verifySavedBank(
      {required String bank_id, required String account_number}) async {
    http.Response response = await HttpRequest.post(
            "/user/bank-accounts/verify",
            {"account_number": account_number, "bank_id": bank_id})
        .catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode < 400) {
      return res["data"]["bank_account"]["account_name"];
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  static Future<String> storeSavedBank(
      {required String bank_id, required String account_number}) async {
    http.Response response = await HttpRequest.post("/user/bank-accounts", {
      "account_number": account_number,
      "bank_id": bank_id
    }).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode < 400) {
      return res['message'];
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  static Future<String> deleteSavedBank(String bankAccountId) async {
    http.Response response =
        await HttpRequest.delete("/user/bank-accounts/$bankAccountId")
            .catchError((err) {
      throw OtherErrors(err);
    });

    Map res = {};
    try {
      res = json.decode(response.body);
    } catch (_) {}

    if (response.statusCode < 400) {
      return res['message'] ?? "Success";
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  static Future<String> changePassword({
    required String old_password,
    required String new_password,
    required String new_password_confirmation,
  }) async {
    http.Response response = await HttpRequest.post("/user/profile/password", {
      "old_password": old_password,
      "new_password": new_password,
      "new_password_confirmation": new_password_confirmation
    }).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode < 400) {
      return res["message"];
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  // //
  static Future<List<AppNotification>> getNotifications(
      String? urlQuery) async {
    http.Response response =
        await HttpRequest.get("/user/notifications$urlQuery").catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode < 400) {
      return (res["data"]["notifications"]["data"] as List)
          .map((e) => AppNotification.fromMap(e))
          .toList();
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  static Future readNotification(String id) async {
    // http.Response response =
    await HttpRequest.post("/user/notifications/read", {"notifications[1]": id})
        .catchError((err) {
      throw OtherErrors(err);
    });

    // Map res = json.decode(response.body);

    // if (response.statusCode  400) {
    //   re
    // } else {
    //   throw res["message"] ?? " An error occured. please try again.";
    // }
  }

  static Future<String> updateFcmToken(String fcm_token) async {
    Map<String, dynamic> _body = {"fcm_token": fcm_token, "_method": "PATCH"};

    http.Response response =
        await HttpRequest.post("/user/profile", _body).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = {};
    try {
      res = json.decode(response.body);
    } catch (_) {}

    if (response.statusCode < 400) {
      return res['message'];
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }
}
