import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jimmy_exchange/core/constants.dart';
import 'package:jimmy_exchange/core/enum.dart';
import 'package:jimmy_exchange/core/model/all_txn_history.dart';
import 'package:jimmy_exchange/core/model/crypto_txn_history.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/values_manager.dart';
import 'package:provider/provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

import '../../presentation/resources/image_manager.dart';
import '../../presentation/widgets/custom_snackbar.dart';
import '../model/giftcard_txn_history.dart';
import '../providers/txn_history_provider.dart';

double deviceHeight(BuildContext context) => MediaQuery.of(context).size.height;

double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

String enumToString(val) => val.toString().split(".").last;

String capitalizeFirstString(String? s) {
  if (s == null || s == '') return '';
  if (s.isEmpty) return '';
  return s.substring(0, 1).toUpperCase() + s.substring(1).toLowerCase();
}

recordError() {}

String obscureEmail(String email) {
  if (email.split("@").first.length > 3) {
    var hiddenEmail = "";
    for (int i = 0; i < email.split("").length; i++) {
      if (i > 2 && i < email.indexOf("@")) {
        hiddenEmail += "*";
      } else {
        hiddenEmail += email[i];
      }
    }
    return hiddenEmail;
  } else {
    return "${email.split("@").first}****";
  }
}

bool isSmallScreen(BuildContext context) {
  return deviceHeight(context) <= AppSize.kSmallScreenHeight;
}

Widget loadNetworkImage(String url,
    {double? height,
    double? width,
    double? strokeWidth,
    Color? strokeWidthColor,
    BoxFit? fit,
    String errorDefaultImage = ImageManager.kProfileFallBack,
    ImageType imageType = ImageType.link,
    File? file}) {
  bool isSvgImage = url.split(".").last.contains("svg");

  if (imageType == ImageType.file) {
    return Image.file(file!, height: height, width: width, fit: fit,
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
      return Image.asset(errorDefaultImage,
          width: width, height: height, fit: fit);
    });
  }

  if (isSvgImage) {
    return SvgPicture.network(
      url,
      height: height,
      width: width,
      fit: fit ?? BoxFit.contain,
      placeholderBuilder: (BuildContext? context) {
        return Center(
          child: CircularProgressIndicator(
            color: strokeWidthColor ?? ColorManager.kPrimaryBlack,
            strokeWidth: strokeWidth ?? 2,
          ),
        );
      },
    );
    //
  }

  return url.startsWith("assets")
      ? Image.asset(url, height: height, width: width, fit: fit)
      : url.trim().toLowerCase() == ("file:///") || url.isEmpty
          ? Image.asset(errorDefaultImage,
              height: height, width: width, fit: fit)
          : Image.network(url, height: height, width: width, fit: fit,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;

              return Center(
                child: CircularProgressIndicator(
                  color: strokeWidthColor ?? ColorManager.kPrimaryBlack,
                  strokeWidth: strokeWidth ?? 2,
                ),
              );
            }, errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
              return Image.asset(errorDefaultImage,
                  width: width, height: height, fit: fit);
            });
}

String truncateWithEllipsis(int cutoff, String myString,
    {int ellipsCount = 3}) {
  return (myString.length <= cutoff)
      ? myString
      : '${myString.substring(0, cutoff)}${generateDots(ellipsCount)}';
}

String generateDots(int len) {
  String res = "";
  for (int i = 0; i < len; i++) {
    res = "$res.";
  }
  return res;
}

Future<File?> selectImage(ImageSource imageSource) async {
  final XFile? pickedFile =
      await ImagePicker().pickImage(source: imageSource, imageQuality: 2);
  if (pickedFile == null) return null;
  return File(pickedFile.path);
}

String formatCurrency(num? value,
    {int decimalDigits = 2, bool short = false, String code = "NGN"}) {
  if (value == null) {
    return "-";
  }

  if (short) {
    return NumberFormat.compactCurrency(
            symbol: getCurrencySymbol(code), decimalDigits: decimalDigits)
        .format(value);
  } else {
    return NumberFormat.currency(
            decimalDigits: decimalDigits, symbol: getCurrencySymbol(code))
        .format(value);
  }
}

String formatNumber(num? value, {int decimalDigits = 2, bool short = false}) {
  if (value == null) return "--";

  NumberFormat formatter;
  if (short) {
    formatter = NumberFormat.compact();
  } else {
    formatter = NumberFormat.currency(decimalDigits: decimalDigits, symbol: "");
  }
  return formatter.format(value);
}

String formatNumberAlt(num? tbPerDiff,
    {int? decimalDigits, bool onlyDecimal = false}) {
  if (tbPerDiff == null || tbPerDiff.isNaN || tbPerDiff.isInfinite) {
    return "0.00";
  }
  int decimalCount = tbPerDiff.toString().contains(".")
      ? (tbPerDiff.toString().split(".")[1].length)
      : 2;

  if (onlyDecimal) {
    return NumberFormat.currency(
            decimalDigits:
                decimalDigits ?? (decimalCount > 2 ? decimalCount : 2),
            symbol: '',
            name: '')
        .format(tbPerDiff)
        .replaceAll(",", "");
  }

  return NumberFormat.currency(
          decimalDigits: decimalDigits ?? (decimalCount > 2 ? decimalCount : 2),
          symbol: '',
          name: '')
      .format(tbPerDiff);
}

DateTime? parseDate(String? date) {
  if (date == null) return null;
  DateTime? dateTime = DateTime.tryParse(date);
  if (dateTime == null) {
    try {
      //Fri, 03 Sep 2021 10:23:10 -0400
      DateFormat dateFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss");
      dateTime = dateFormat.parse(date);

      List<String> parts = date.split(" ");

      dateTime = DateTime.tryParse(
          dateTime.toIso8601String() + parts[parts.length - 1]);
    } catch (e) {
      // Try a different date format
      return DateFormat("yyyy/MM/dd").parse(date);
    }
  }
  return dateTime;
}

String getVerboseDateTimeRepresentationAlt(DateTime? dateTime) {
  if (dateTime == null) return "-";
  DateTime now = DateTime.now();
  DateTime localDateTime = dateTime.toLocal();

  if (localDateTime.day == now.day &&
      localDateTime.month == now.month &&
      localDateTime.year == now.year) {
    return "Today";
  }

  DateTime yesterday = now.subtract(const Duration(days: 1));
  if (localDateTime.day == yesterday.day &&
      localDateTime.month == now.month &&
      localDateTime.year == now.year) {
    return 'Yesterday';
  }

  if (now.difference(localDateTime).inDays < 4) {
    return DateFormat('EEEE').format(localDateTime);
  }

  return DateFormat('yMMMM').format(dateTime);
}

String? formatDateAlt(String date) {
  try {
    final f = DateFormat('yyyy/MM/dd hh:mm a');
    DateTime dateTime = DateTime.parse(date);
    return f.format(dateTime);
  } catch (_) {
    return null;
  }
}

String? getTimeFromDate(String date) {
  try {
    final f = DateFormat('hh:mm a');
    DateTime dateTime = DateTime.parse(date);
    return f.format(dateTime);
  } catch (_) {
    return null;
  }
}

String formatDateSlash(String? date) {
  try {
    return DateFormat("dd/MM/yyyy").format(parseDate(date)!);
  } catch (_) {
    return "--";
  }
}

String formatDateGetTime(String? date) {
  try {
    return DateFormat.jm().format(parseDate(date)!);
  } catch (_) {
    return "--";
  }
}

String formatDateDayAndMonthSlash(String? inputDateString) {
  try {
    DateTime inputDate = DateTime.parse(inputDateString!);
    // return DateFormat.jm().format(parseDate(date)!);
    String formattedDate = DateFormat('MM/dd').format(inputDate);
    return formattedDate;
  } catch (_) {
    return "--";
  }
}

/// return time in this format 12:45 AM
String formatTimeTwelveHours(String? inputDateString) {
  try {
    DateTime inputDate = DateTime.parse(inputDateString!);
    String formattedDate = DateFormat.jm().format(inputDate);
    return formattedDate;
  } catch (_) {
    return "--";
  }
}

String getCurrencySymbol(String currencyName, {bool useFullName = false}) {
  currencyName = (currencyName.trim().contains("-"))
      ? currencyName.split("-").last.toUpperCase()
      : currencyName.toUpperCase();
  String currencySymbol = '';
  String fullName = '';
  switch (currencyName) {
    case 'NGN':
    case 'NGA':
    case 'NG':
      fullName = "naira";
      currencySymbol = "\u20A6";
      break;
    case 'GBP':
      fullName = "pound";
      currencySymbol = NumberFormat().simpleCurrencySymbol("GBP");
      break;
    case 'EUR':
      fullName = "euro";
      currencySymbol = NumberFormat().simpleCurrencySymbol("EUR");
      break;
    case 'KES':
      fullName = "shilling";
      currencySymbol = NumberFormat().simpleCurrencySymbol("KES");
      break;
    case 'GHS':
      fullName = "cedi";
      currencySymbol = NumberFormat().simpleCurrencySymbol("GHS");
      break;
    case 'ZMW':
      fullName = "kwacha";
      currencySymbol = NumberFormat().simpleCurrencySymbol("ZMW");
      break;
    case 'UGX':
      fullName = "shilling";
      currencySymbol = NumberFormat().simpleCurrencySymbol("UGX");
      break;
    case 'RWF':
      fullName = "franc";
      currencySymbol = NumberFormat().simpleCurrencySymbol("RWF");
      break;
    case 'XOF':
      fullName = "franc";
      currencySymbol = NumberFormat().simpleCurrencySymbol("XOF");
      break;
    case 'TZS':
      fullName = "shilling";
      currencySymbol = NumberFormat().simpleCurrencySymbol("TZS");
      break;
    case 'USD':
    case 'US':
      fullName = 'dollar';
      currencySymbol = NumberFormat().simpleCurrencySymbol("USD");
      break;
    default:
      fullName = currencyName;
      currencySymbol = NumberFormat().simpleCurrencySymbol(currencyName);
      break;
  }

  return useFullName ? fullName : currencySymbol;
}

Future<List<File>?> selectMultipleImages(ImageSource imageSource) async {
  // final List<XFile?> pickedFile =await ImagePicker.pickImaag
  final List<XFile>? pickedFile =
      await ImagePicker().pickMultiImage(imageQuality: 25);
  if (pickedFile == null) return null;
  return pickedFile.map((el) => File(el.path)).toList();
}

Future<void> updateTxnHistory(BuildContext context) async {
  TxnHistoryProvider txnHistoryProvider =
      Provider.of<TxnHistoryProvider>(context, listen: false);
  await txnHistoryProvider.updateAllTxnHistory();
}

Color getStatusColor(String status) {
  String ls = status.toLowerCase();
  return ls == "approved" || ls == "partially_approved"
      ? ColorManager.kSuccessBg
      : ls == "declined"
          ? ColorManager.kErrorBg
          : ColorManager.kUsernameBgColor.withOpacity(0.2);
}

Color getStatusTextColor(String status) {
  String ls = status.toLowerCase();
  return ls == "approved" || ls == "partially_approved"
      ? ColorManager.kSuccess
      : ls == "declined"
          ? ColorManager.kError
          : ColorManager.kYellow;
}

num? calPreviousPartialAmountForGiftcardTxn(GiftcardTxnHistory txn) {
  num amount = txn.amount ?? 0;
  num rate = txn.rate ?? 0;
  num service_charge = txn.service_charge ?? 0;
  return (amount * rate) - ((amount * rate) * (service_charge / 100));
}

num? calPreviousPartialAmountForCryptoTxn(CryptoTxnHistory txn) {
  num amount = txn.asset_amount ?? 0;
  num rate = txn.rate ?? 0;
  num service_charge = txn.service_charge ?? 0;
  return (amount * rate) - ((amount * rate) * (service_charge / 100));
}

num? calPreviousPartialAmountForAllTxn(AllTxnHistory txn) {
  num amount = txn.amount ?? 0;
  num rate = txn.rate ?? 0;
  num service_charge = txn.service_charge ?? 0;
  return (amount * rate) - ((amount * rate) * (service_charge / 100));
}

bool isLatestVersion(String currentVersion, String updateVersion) {
  List<String> currentSeries = currentVersion.split('.');
  List<String> updateSeries = updateVersion.split('.');

  int n = 3 - currentSeries.length;
  for (int i = 0; i < n; i++) currentSeries.add("0");

  n = 3 - updateSeries.length;
  for (int i = 0; i < n; i++) updateSeries.add("0");

  bool isLatest = false;
  if ((int.tryParse(currentSeries[0]) ?? 0) >
          (int.tryParse(updateSeries[0]) ?? 0) ||
      (int.tryParse(currentSeries[0]) == int.tryParse(updateSeries[0]) &&
          (int.tryParse(currentSeries[1]) ?? 0) >
              (int.tryParse(updateSeries[1]) ?? 0)) ||
      (int.tryParse(currentSeries[0]) == int.tryParse(updateSeries[0]) &&
          int.tryParse(currentSeries[1]) == int.tryParse(updateSeries[1]) &&
          (int.tryParse(currentSeries[2]) ?? -1) >=
              (int.tryParse(updateSeries[2]) ?? 0))) {
    isLatest = true;
  }
  return isLatest;
}

Future<List<String>> uploadImagesToCloudinary(List<File> images) async {
  final cloudinary = CloudinaryPublic(
      Constants.kCLOUDINARY_CLOUD_NAME, Constants.kCLOUDINARY_UPLOAD_PRESET,
      cache: false);

  List<CloudinaryResponse> uploadedImagesResponse =
      await cloudinary.multiUpload(
    images
        .map((image) async => CloudinaryFile.fromFile(image.path,
            resourceType: CloudinaryResourceType.Image))
        .toList(),
  );
  return uploadedImagesResponse.map((e) => e.secureUrl).toList();
}

Future<String> uploadImageToCloudinary(File image) async {
  final cloudinary = CloudinaryPublic(
      Constants.kCLOUDINARY_CLOUD_NAME, Constants.kCLOUDINARY_UPLOAD_PRESET,
      cache: false);

  CloudinaryResponse response = await cloudinary.uploadFile(
    CloudinaryFile.fromFile(image.path,
        resourceType: CloudinaryResourceType.Image),
  );
  return response.secureUrl;
}

Future<void> copyToClipboard(BuildContext context, String text,
    {String? successMsg}) async {
  await Clipboard.setData(ClipboardData(text: "$text")).then((_) {
    showCustomSnackBar(
      context: context,
      text: successMsg ?? "Text copied to clipboard successfully.",
      type: NotificationType.success,
    );
  });
}

extension TitleCaseStringExtension on String {
  String toTitleCase() {
    return this.split(' ').map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      } else {
        return '';
      }
    }).join(' ');
  }
}