import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../app/app.dart';
import '../errors.dart';
import '../model/user.dart';
import '../providers/user_provider.dart';
import '../services/http_request.dart';
import '../services/secure_storage.dart';

class AuthHelper {
  static SecureStorage? _prefs;

  static Future<void> _saveLoginCred(Map res, String password,
      {String? social_token, String? channel}) async {
    _prefs ??= await SecureStorage.getInstance();
    await _prefs!.setString(
      "authCred",
      json.encode(
        {
          "token": res['data']['token'],
          "user": res['data']['user'],
          "pass_cred": password,
          "social_token": social_token,
          "channel": channel
        },
      ),
    );
  }

  /// return an object containing a map of the [User] and [Token] data if successful otherwise throw error.
  static Future<Map<String, dynamic>> signUp({
    required String countryId,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String username,
    required String phoneNumber,
    String? ref,
  }) async {
    Map<String, dynamic> _body = {
      "country_id": countryId,
      "firstname": firstName,
      "lastname": lastName,
      "email": email,
      "password": password,
      "password_confirmation": password,
      "username": username,
      "phone_number": phoneNumber,
    };

    if ((ref ?? "").trim().isNotEmpty) {
      _body["ref"] = ref;
    }

    http.Response response = await HttpRequest.post("/user/register", _body,
            enableDefaultHeaders: false)
        .catchError((err) {
      throw OtherErrors(err);
    });
    Map res = json.decode(response.body);

    if (response.statusCode < 400) {
      return {
        "user": User.fromMap(res['data']['user']),
        "token": res['data']['token'],
      };
    } else {
      throw res['message'];
    }
  }

  static Future<String> resendOtp({required String token}) async {
    http.Response response = await HttpRequest.post("/user/email/resend", {},
        enableDefaultHeaders: false,
        addHeaders: {"Authorization": "Bearer $token"}).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = {};
    try {
      res = json.decode(response.body);
    } catch (_) {}

    if (response.statusCode == 200) {
      return res['message'];
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  static Future<Map<String, dynamic>> signIn(
      {required String email,
      required String password,
      String? channel,
      String? social_token}) async {
    try {
      // BODY
      Map<String, dynamic> _body = {};
      if (social_token == null) {
        _body = {"email": email, "password": password};
      } else {
        _body = {"channel": channel ?? "google", "user_token": social_token};
      }

      //URL
      String url = "/user/login";
      if (social_token != null) {
        url = "/user/social-auth";
      }

      http.Response response = await HttpRequest.post(url, _body,
          enableDefaultHeaders: false,
          addHeaders: {"Accept": "application/json"}).catchError((err) {
        throw OtherErrors(err);
      });

      Map res = json.decode(response.body);

      if (response.statusCode < 400) {
        await _saveLoginCred(res, password,
            social_token: social_token, channel: channel);

        return {
          "user": User.fromMap(res['data']['user']),
          "requires_two_fa": res['data']['requires_two_fa']
        };
      }
      throw res['message'];
    } catch (e) {
      rethrow;
    }
  }

  // This endpoint verifies the users email
  static Future<String> verifyEmail(
      {required String code, required String token}) async {
    http.Response response = await HttpRequest.post(
        "/user/email/verify", {"code": code},
        enableDefaultHeaders: false,
        addHeaders: {"Authorization": "Bearer $token"}).catchError((err) {
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

  static Future<String> toggleTwoFAStatus() async {
    http.Response response =
        await HttpRequest.post("/user/profile/two-fa", {}).catchError((err) {
      throw OtherErrors(err);
    });

    Map decodedRes = {};
    try {
      decodedRes = json.decode(response.body);
    } catch (_) {}
    if (response.statusCode < 400) {
      return decodedRes['message'];
    } else {
      throw decodedRes["message"] ?? " An error occurred. please try again.";
    }
  }

  static Future<String> resendTwoFaCode() async {
    http.Response response =
        await HttpRequest.post("/user/resend-two-fa", {}).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = {};
    try {
      res = json.decode(response.body);
    } catch (_) {}

    if (response.statusCode == 200) {
      return res['message'];
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  static Future<String> completeTwoFa(
      {required String code, required String password}) async {
    http.Response response =
        await HttpRequest.post("/user/verify-two-fa", {"code": code})
            .catchError((err) {
      throw OtherErrors(err);
    });

    Map res = {};
    try {
      res = json.decode(response.body);
    } catch (_) {}

    if (response.statusCode == 200) {
      await _saveLoginCred(res, password);
      return res['message'];
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  //This API call does not work for now
  static Future<String> toggleTransactionPin() async {
    http.Response response =
        await HttpRequest.post("/user/profile/transaction-pin", {})
            .catchError((err) {
      throw OtherErrors(err);
    });

    Map decodedRes = {};
    try {
      decodedRes = json.decode(response.body);
    } catch (_) {}
    if (response.statusCode < 400) {
      return decodedRes['message'];
    } else {
      throw decodedRes["message"] ?? " An error occurred. please try again.";
    }
  }

  static Future<String> requestPasswordResetCode(String email) async {
    http.Response response =
        await HttpRequest.post("/user/password/forgot", {"email": email})
            .catchError((err) {
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

  static Future<String> validateResetCode(
      {required String email, required String code}) async {
    http.Response response = await HttpRequest.post(
            "/user/password/verify", {"email": email, "code": code})
        .catchError((err) {
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

  static Future<String> completeResetPassword(
      {required String email,
      required String code,
      required String password}) async {
    Map<String, dynamic> _body = {
      "email": email,
      "code": code,
      "password": password,
      "password_confirmation": password,
    };

    http.Response response =
        await HttpRequest.post("/user/password/reset", _body).catchError((err) {
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

  static Future<void> logout(BuildContext context,
      {bool deactivateTokenAndRestart = false}) async {
    await (await SecureStorage.getInstance()).clearMemory();
    await HttpRequest.clearMemory();
    Provider.of<UserProvider>(context, listen: false).updateUserCred(null);

    if (deactivateTokenAndRestart) {
      HttpRequest.post("/user/logout", {}).catchError((err) {
        throw OtherErrors(err);
      });
      MyApp.restartApp(context);
    }
  }

  static Future<String> updateTransactionPin(
      {String? old_pin,
      required String new_pin,
      required String new_pin_confirmation}) async {
    Map<String, dynamic> body = {
      "new_pin": new_pin,
      "new_pin_confirmation": new_pin_confirmation,
      "_method": "PATCH"
    };

    if (old_pin != null) {
      body["old_pin"] = old_pin;
    }

    http.Response response =
        await HttpRequest.post("/user/transaction-pin", body).catchError((err) {
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

  // static Future<String> toggleTransactionPin() async {
  //   http.Response response =
  //       await HttpRequest.patch("/user/transaction-pin/activation", {})
  //           .catchError((err) {
  //     throw OtherErrors(err);
  //   });

  //   Map res = {};
  //   try {
  //     res = json.decode(response.body);
  //   } catch (_) {}

  //   if (response.statusCode < 400) {
  //     return res['message'];
  //   } else {
  //     throw res["message"] ?? " An error occured. please try again.";
  //   }
  // }

  static Future<String> requestTransactionPinResetCode() async {
    http.Response response =
        await HttpRequest.post("/user/transaction-pin/forgot", {})
            .catchError((err) {
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

  static Future<String> recoverTransactionPin(
      {required String code,
      required String new_pin,
      required String new_pin_confirmation}) async {
    http.Response response =
        await HttpRequest.post("/user/transaction-pin/reset", {
      "code": code,
      "pin": new_pin,
      "pin_confirmation": new_pin_confirmation,
    }).catchError((err) {
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

  static Future<String> deleteAccount() async {
    Map<String, dynamic> body = {"reason": "NA", "_method": "DELETE"};
    await Future.delayed(Duration(milliseconds: 500));
    http.Response response =
        await HttpRequest.post("/user/profile", body).catchError((err) {
      throw OtherErrors(err);
    });
    Map res = {};
    try {
      res = json.decode(response.body);
    } catch (_) {}

    if (response.statusCode < 400) {
      return "";
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }
}
