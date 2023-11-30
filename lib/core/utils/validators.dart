import 'utils.dart';

class Validator {
  static String? validateEmail(val) {
    if ((val ?? "").isEmpty) {
      return "Email is required";
    } else if ((val ?? "").contains("+") ||
        !RegExp(RegexExpression.kEmailValidator).hasMatch((val ?? "").trim())) {
      return "Enter a valid email address";
    }
    return null;
  }

  static String? validateField(
      {required String fieldName, required String? input}) {
    if ((input ?? "").isEmpty) {
      return "${capitalizeFirstString(fieldName.toLowerCase())} can't be empty";
    }
    return null;
  }

  static String? validateAmountField(
      {required String fieldName, required String? input}) {
    if ((input ?? "").isEmpty) {
      return "${capitalizeFirstString(fieldName.toLowerCase())} can't be empty";
    } else if (input!.length < 4) {
      return "Amount can't be less then 1000";
    } else {
      return null;
    }
  }

  static String? validateMobile(val) {
    if ((val ?? "").isEmpty) {
      return "Phone number can't be empty";
    } else if (val.length != 11) {
      return "Phone number should be 11 digit";
    }

    return null;
  }

  static String? validatePassword(String? val) {
    if (val == null || val.isEmpty) {
      return "Password can't be empty";
    } else if (!containsLowercase(val)) {
      return "Password should contain lowercase";
    } else if (!containsUppercase(val)) {
      return "Password should contain uppercase";
    } else if (!containNumber(val)) {
      return "Password should contain number";
    } else if (val.length < 12) {
      return "Minimum characters of 12 is required.";
    }

    return null;
  }

  static String? doesPasswordMatch(
      {required String? password,
      required String? confirmPassword,
      String? fieldName}) {
    if (password == confirmPassword) {
      return null;
    } else {
      return "${fieldName ?? "Passwords"} do not match";
    }
  }

  static bool containNumber(String str) {
    bool res = false;
    for (final String el in str.split('')) {
      if (isNumeric(el)) {
        res = true;
        break;
      }
    }

    return res;
  }

  static bool isNumeric(String s) {
    try {
      double.parse(s);
      return true;
    } catch (_) {
      return false;
    }
  }

  static bool containsLowercase(String str) => str.contains(RegExp(r'[a-z]'));

  static bool containsUppercase(String str) => str.contains(RegExp(r'[A-Z]'));

  static giftCardCodeformat(String arg) {
    if (arg.isEmpty) {
      throw "Please sumbit all required information";
    }
    Map<String, int> chars = {};
    arg.split('').forEach((el) {
      chars[el] = chars[el] == null ? 1 : chars[el]! + 1;
    });

    if (chars['|'] == null || chars['|'] != 1) {
      throw "Please submit all details in this format *code|pin*";
    }
  }
}

class RegexExpression {
  static const kEmailValidator =
      "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$";
}
