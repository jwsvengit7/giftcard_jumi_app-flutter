import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jimmy_exchange/core/model/asset.dart';
import 'package:jimmy_exchange/core/model/banner.dart';
import 'package:jimmy_exchange/core/model/giftcard_product.dart';
import 'package:jimmy_exchange/core/model/network.dart';
import '../errors.dart';
import '../model/bank.dart';
import '../model/country.dart';
import '../model/currency.dart';
import '../model/giftcard_category.dart';
import '../services/http_request.dart';

class GenericHelper {
  ///
  static Future<List<Country>> getCountries({String? filterName}) async {
    bool doNotPaginate = true;
    http.Response res = await HttpRequest.get(
            "/countries?include=dialing_code&do_not_paginate=$doNotPaginate")
        .catchError((err) {
      throw OtherErrors(err);
    });

    Map decodedRes = json.decode(res.body);
    if (res.statusCode == 200) {
      return (decodedRes['data']['countries'] as List)
          .map((e) => Country.fromMap(e))
          .toList();
    } else {
      throw decodedRes["message"];
    }
  }

  static Future<List<Banners>> getBanners() async {
    http.Response res = await HttpRequest.get("/banners").catchError((err) {
      throw OtherErrors(err);
    });
    Map decodedRes = json.decode(res.body);
    if (res.statusCode == 200) {
      return (decodedRes['data']['banners'] as List)
          .map((e) => Banners.fromMap(e))
          .toList();
    } else {
      throw decodedRes["message"];
    }
  }

  /// Page is required if it isn't a filter process
  static Future<List<Bank>> getBankList(int page, {String? filterName}) async {
    String url = "/banks?page=$page";
    if (filterName != null) url = "/banks?filter[name]=$filterName";

    http.Response response = await HttpRequest.get(url).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      return (res['data']['banks']['data'] as List)
          .map((e) => Bank.fromMap(e))
          .toList();
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  /// ASSETS
  static Future<List<Asset>> getAssetList(String? param,
      {String? filterName}) async {
    String url = "/assets?per_page=50";
    if (filterName != null) {
      url = url + "&filter[code]=$filterName";
    }

    if (param != null) url += param;

    http.Response response = await HttpRequest.get(url).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode < 400) {
      return (res['data']['assets']['data'] as List)
          .map((e) => Asset.fromMap(e))
          .toList();
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  ///  NETWORk
  static Future<List<Network>> getNetwork(String asset_id,
      {String? filterName, String? param}) async {
    String url = "/networks?filter[asset_id]=$asset_id";
    if (filterName != null) {
      url = "/networks?filter[asset_id]=$asset_id&filter[name]=$filterName";
    }

    if (param != null) url += param;

    http.Response res = await HttpRequest.get(url).catchError((err) {
      throw OtherErrors(err);
    });

    try {
      Map decodedRes = json.decode(res.body);

      if (res.statusCode < 400) {
        List data = decodedRes["data"]["networks"]["data"];

        return data.map((e) => Network.fromMap(e)).toList();
      } else {
        throw decodedRes["message"];
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<GiftcardCategory>> getGiftcardCategories(String? filter,
      {required bool isSale}) async {
    String url = "/giftcard-categories?include=countries";

    // if (isSale) {
    //   url = "$url&filter[sale_activated]=1";
    // } else {
    //   url = "$url&filter[purchase_activated]=1";
    // }

    if (filter != null) url += filter;

    http.Response res = await HttpRequest.get(url).catchError((err) {
      throw OtherErrors(err);
    });

    try {
      Map decodedRes = json.decode(res.body);

      if (res.statusCode < 400) {
        List data = decodedRes["data"]["giftcard_categories"]["data"];

        return data.map((e) => GiftcardCategory.fromMap(e)).toList();
      } else {
        throw decodedRes["message"];
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<GiftcardProduct>> getGiftcardProducts(
    String? filter, {
    required String country_id,
    required String giftcard_category_id,
  }) async {
    String url =
        "/giftcard-products?include=giftcardCategory,country,currency&filter[country_id]=$country_id&filter[giftcard_category_id]=$giftcard_category_id";
    if (filter != null) url += filter;

    http.Response res = await HttpRequest.get(url).catchError((err) {
      throw OtherErrors(err);
    });

    try {
      Map decodedRes = json.decode(res.body);

      if (res.statusCode < 400) {
        List data = decodedRes["data"]["giftcard_products"]["data"];

        return data.map((e) => GiftcardProduct.fromMap(e)).toList();
      } else {
        throw decodedRes["message"];
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<Currency> getCurrency({String? code}) async {
    http.Response res = await HttpRequest.get(
            "/currencies?filter[code]=$code&fields[currencies]=id,name,code,exchange_rate_to_ngn")
        .catchError((err) {
      throw OtherErrors(err);
    });
    Map decodedRes = json.decode(res.body);
    if (res.statusCode == 200) {
      List res = (decodedRes['data']['currencies']["data"] as List);

      return Currency.fromMap(res[0]);
    } else {
      throw decodedRes["message"];
    }
  }

  static Future<String?> getCurrentAppVersion({String? platform}) async {
    http.Response res =
        await HttpRequest.get("/system-data/$platform").catchError((err) {
      throw OtherErrors(err);
    }).timeout(const Duration(seconds: 5), onTimeout: () {
      throw "Timeout Error";
    });
    Map decodedRes = json.decode(res.body);
    if (res.statusCode == 200) {
      return decodedRes['data']['system_data']["content"];
    } else {
      return null;
    }
  }
}
