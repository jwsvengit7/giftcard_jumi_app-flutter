import 'constants.dart';
import 'utils/utils.dart';

class InternetConnectionError implements Exception {
  String get message => Constants.kConnectionError;

  @override
  String toString() => Constants.kConnectionError;
}

class OtherErrors implements Exception {
  final dynamic message;

  OtherErrors([this.message]);

  @override
  String toString() {
    var msg = message.toString();

    if (message is FormatException) {
      return Constants.kServiceUnavailable;
    }
    if (msg.startsWith("Exception")) {
      return capitalizeFirstString(msg.replaceFirst("Exception:", "").trim());
    } else if (msg.contains(":")) {
      return capitalizeFirstString(msg.substring(msg.indexOf(":")).trim());
    }
    return capitalizeFirstString(message.toString().trim());
  }
}
