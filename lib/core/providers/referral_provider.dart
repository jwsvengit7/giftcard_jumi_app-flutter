import 'package:flutter/material.dart';
import '../helpers/referral_helper.dart';
import '../model/referral.dart';

class ReferralProvider with ChangeNotifier {
  // Referrals
  List<Referral> _referrals = [];
  Map<String, dynamic> _referralsMeta = {};

  List<Referral> get referrals => _referrals;
  num get total_referrals =>
      num.tryParse(_referralsMeta["total_referrals"].toString()) ??
      num.parse("0");
  num get total_trade =>
      num.tryParse(_referralsMeta["total_trade"].toString()) ?? num.parse("0");
  num get total_reward =>
      num.tryParse(_referralsMeta["total_reward"].toString()) ?? num.parse("0");

  Future<void> updateReferrals() async {
    await ReferralHelper.getReferralsWithMeta("?include=referred")
        .then((value) {
      _referrals = value["referral"];
      _referralsMeta = value["meta"];
      notifyListeners();
    }).catchError((e) {
      // recordError();
    });
  }
}
