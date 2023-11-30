import 'package:flutter/material.dart';

class ColorManager {
  // Main
  static Color kNavyBlue = HexColor.fromHex("#1F2249");
  static Color kNavyBlue2 = HexColor.fromHex("#CEDCF2");
  static Color kSecBlue = HexColor.fromHex("#1F2349");
  static Color kBlack = HexColor.fromHex("#000000");
  static Color kWhite = HexColor.fromHex("#FFFFFF");
  static Color kPrimaryBlack = HexColor.fromHex("#13111F");
  static Color kPrimaryBlue = HexColor.fromHex("#0346A7");
  static Color kPrimaryBlueAccent = HexColor.fromHex("#94C0FF");


  //
  static Color kBackground = HexColor.fromHex("#F5F5F5");
  static Color kBackgroundLight = HexColor.fromHex("#E6E6E6");
  static Color kBackgroundAlt = HexColor.fromHex("#F9F9F9");
  static Color kGray1 = HexColor.fromHex("#333333");
  static Color kGray2 = HexColor.fromHex("#707F98");
  static Color kGray3 = HexColor.fromHex("#D6DAE1");
  static Color kGray4 = HexColor.fromHex("#C8CED7");
  static Color kGrayB3 = HexColor.fromHex("#B3B3B3");
  static Color kGray8 = HexColor.fromHex("#252A33");
  static Color kGray9 = HexColor.fromHex("#12151A");
  static Color kGray11 = HexColor.fromHex("#FAFAFA");
  static Color kGray10 = HexColor.fromHex("#ECEEF1");
  static Color kGray12 = HexColor.fromHex("#EFF1F4");
  static Color kGray13 = HexColor.fromHex("#6B7280");

  static Color kYellow = HexColor.fromHex("#FBC740");
  static Color kError = HexColor.fromHex("#FF5656");
  static Color kSuccessBg = HexColor.fromHex("#DCFFEB");
  static Color kSuccess = HexColor.fromHex("#219653");
  static Color kErrorBg = HexColor.fromHex("#FFDEDE");
  static Color kGrayAlt = HexColor.fromHex("#9D9D9D");
  static Color kGreyscale500 = HexColor.fromHex("#6B7280");
  static Color kPlutoSemiDark = HexColor.fromHex("#272C34");
  static Color kEllipseBg = HexColor.fromHex("#D9D9D9");
  static Color kTxnTileBorderColor = HexColor.fromHex("#DADADA");
  static Color kSuccessBg2 = HexColor.fromHex("#6FCF97");

  //
  static Color kTextColor = HexColor.fromHex("#797979");
  static Color kFormBg = HexColor.fromHex("FFFFFF");
  static Color kFormBorder = HexColor.fromHex("D6DAE1");
  static Color kActiveBorder = HexColor.fromHex("#D7E3F5");
  static Color kActiveButton = HexColor.fromHex("#EDF3FD");
  static Color kFormHintText = HexColor.fromHex("#AFAFAF");
  static Color kUsernameBgColor = HexColor.fromHex("#FFEAB4");
  static Color kSettingsItemBg = HexColor.fromHex("#FAFAFF");
  static Color kLogoutBgColor = HexColor.fromHex("#FFF1F1");
  static Color kLogoutTextColor = HexColor.fromHex("#F75555");
  static Color kCryptoTab1 = HexColor.fromHex("#EBDCFF");
  static Color kCryptoTab2 = HexColor.fromHex("#E7FFC2");
  static Color kGiftcardTab1 = HexColor.fromHex("#FFF3C5");
  static Color kGiftcardTab2 = HexColor.fromHex("#EEEFFF");
  static Color kBlack2 = HexColor.fromHex("#111827");
  static Color kGreyscale50 = HexColor.fromHex("#F9FAFB");
  static Color kReadNotification = HexColor.fromHex("#6C6C6C");
  static Color kReadNotificationDate = HexColor.fromHex("#DDDDDD");
  static Color kFilterBg = HexColor.fromHex("#F4F5FF");
  static Color kNoteColor = HexColor.fromHex("#FFFAE4");
  static Color kNoteTextColor = HexColor.fromHex("#828282");
  static Color kAccountDeletion = HexColor.fromHex("#EB5757");
  static Color kReferralBoxBg = HexColor.fromHex("#FFFAEC");
  static Color kUpdateBackground = HexColor.fromHex("#F2F7FF");
  static Color kTextGray = HexColor.fromHex("#252A33");
  static Color kGray7 = HexColor.fromHex("#4A5566");
  static Color kBorder = HexColor.fromHex("#E3E6EB");
  static Color kTextBlack2 = HexColor.fromHex("#303244");
  static Color kSavedBank = HexColor.fromHex("#E3E6EB4D");
  static Color kSecurityDividerGrey = HexColor.fromHex("##E9E9E9");
  static Color kOrange = HexColor.fromHex("#F7931A");
  static Color kCategoryOrange = HexColor.fromHex("#F79F1A");
 

  static Color getWalletStatusColor(String status) =>
      status.toLowerCase() == "completed"
          ? ColorManager.kSuccess
          : status.toLowerCase() == "declined"
              ? ColorManager.kError
              : ColorManager.kYellow;
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF$hexColorString"; // 8 char with opacity 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
