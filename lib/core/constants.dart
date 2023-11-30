import 'package:flutter/foundation.dart';

class Constants {
  // TODO:: uncomment
  static const String kBaseurl = kReleaseMode
      ? "https://prod-api.ksbtech.com.ng/api"
      : "https://test.ksbtech.com.ng/api";

  static const kCLOUDINARY_CLOUD_NAME = "ksbtech";
  static const kCLOUDINARY_UPLOAD_PRESET = "ksbadmin";

  static const String serverError = "A server error occured, please try again.";
  static const kConnectionError =
      "Connection could not be established. Please check internet connection";
  static const kServiceUnavailable =
      "Service currently unavailable. Please try again later";
  static const kWhatsAppContact = "https://wa.me/2348109203065";
  static const kEmail = "hello@ksbtech.com.ng";
  static const kPhoneNo = "+2348109203065";
  static const kPrivacyPolicy = "https://ksbtech.com.ng/privacy-policy";
  static const kTermsAndConditions = "https://ksbtech.com.ng/terms";
  static const kFAQ = "https://ksbtech.com.ng/";

  static const kNigeriaName = "Nigeria";

  static const kCryptoTxnTypeValue = "asset_transaction";

  static const kAllTransaction = "alltransaction";
  static const kCryptoTransaction = "crypto";
  static const kGiftCardTransaction = "giftcard";
  static const kWalletTransaction = "wallet";

  static const kAllType = "alltype";
  static const kBuyType = "buy";
  static const kSellType = "sell";

  static const kAllStatus = "allStatus";
  static const kSuccessStatus = "success";
  static const kCompletedStatus = "completed";
  static const kTransferred = "transferred";
  static const kFailedStatus = "failed";

  static const kPartiallyApprovedStatus = "partially_approved";
  static const kPending = "pending";
  static const kDeclinedStatus = "declined";

  static const kGoogleChannel = "google";
  static const kAppleChannel = "apple";

  static const kUSDCode = "USD";
}
