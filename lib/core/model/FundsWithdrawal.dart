import 'package:jimmy_exchange/core/model/saved_bank.dart';

class FundsWithdrawal {
  String? selectedAmount;
  String? transactionPin;
  SavedBank? savedBank;
  bool? isWallet;

  FundsWithdrawal(
      {this.selectedAmount,
      this.transactionPin,
      this.savedBank,
      this.isWallet});
}
