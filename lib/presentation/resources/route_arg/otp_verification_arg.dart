import '../../../core/enum.dart';
import '../../../core/model/user.dart';

class OtpVerificationArg {
  final User user;
  final String token;
  final OtpType otpType;

  OtpVerificationArg(
      {required this.user, required this.token, required this.otpType});
}
