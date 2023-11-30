import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/model/giftcard_category.dart';
import 'package:jimmy_exchange/core/model/network.dart';
import '../helpers/generic_helper.dart';
import '../model/asset.dart';
import '../model/bank.dart';
import '../model/banner.dart';
import '../model/country.dart';
import '../utils/utils.dart';

class GenericProvider with ChangeNotifier {
  // Giftcard categories
  // List<GiftcardCategories> _giftcardCategories = [];
  // List<GiftcardCategories> get giftcardCategories => _giftcardCategories;
  // Future<List<GiftcardCategories>> updateGiftCardCategories() async {
  //   return await GenericHelper.getGiftCardCategories().then((value) {
  //     _giftcardCategories = value;
  //     notifyListeners();
  //     return _giftcardCategories;
  //   }).catchError((e) {
  //     recordError();
  //     throw "e";
  //   });
  // }

  // Countries
  List<Country> _countries = [];
  List<Country> get countries => _countries;
  Future<List<Country>> updateCountries() async {
    return await GenericHelper.getCountries().then((value) {
      _countries = value;
      notifyListeners();
      return _countries;
    }).catchError((e) {
      recordError();
      return ([] as List<Country>);
    });
  }

  // Countries
  List<Banners> _banners = [];
  List<Banners> get banners => _banners;
  Future<List<Banners>> updateBanners() async {
    return await GenericHelper.getBanners().then((value) {
      _banners = value;
      notifyListeners();
      return _banners;
    }).catchError((e) {
      recordError();
      return ([] as List<Banners>);
    });
  }

  // Banks
  final List<Bank> _banks = [];
  List<Bank> get banks => _banks;
  int _page = 1;
  Future<void> updateBankList() async {
    await GenericHelper.getBankList(_page).then((value) {
      if (value.isEmpty) return;
      _banks.addAll(value);
      _page += 1;
      notifyListeners();
    }).catchError((e) {
      recordError();
    });
    //
  }

  // Currencies
  // List<Currencies> _currencies = [];
  // List<Currencies> get currencies => _currencies;
  // Future<List<Currencies>> updateCurrencies() async {
  //   return await GenericHelper.getCurrencies().then((value) {
  //     if (value.isEmpty) return ([] as List<Currencies>);
  //     _currencies = value;
  //     notifyListeners();
  //     return _currencies;
  //   }).catchError((e) {
  //     recordError();
  //     return ([] as List<Currencies>);
  //   });
  //   //
  // }

  // Networks
  List<Network> _networks = [];
  List<Network> get networks => _networks;
  Future<List<Network>> updateNetworks(String asset_id) async {
    _networks = [];
    return await GenericHelper.getNetwork(asset_id).then((value) {
      if (value.isEmpty) return value;
      _networks = value;
      notifyListeners();
      return _networks;
    }).catchError((e) {
      recordError();
      return ([] as List<Network>);
    });
  }

  // Assets
  List<Asset> _assets = [];
  List<Asset> get assets => _assets;
  Future<void> updateAssetList() async {
    await GenericHelper.getAssetList(null).then((value) {
      if (value.isEmpty) return;
      _assets = value;
    }).catchError((e) {
      recordError();
    });
    notifyListeners();
    //
  }

  // Giftcard category
  List<GiftcardCategory> _giftcardCategory = [];
  List<GiftcardCategory> get giftcardCategory => _giftcardCategory;
  Future<List<GiftcardCategory>> updateGiftcardCategory(bool isSale) async {
    _giftcardCategory = [];
    return await GenericHelper.getGiftcardCategories(null, isSale: isSale)
        .then((value) {
      _giftcardCategory = value;
      notifyListeners();
      return _giftcardCategory;
    }).catchError((e) {
      recordError();
      return ([] as List<GiftcardCategory>);
    });
  }
}
