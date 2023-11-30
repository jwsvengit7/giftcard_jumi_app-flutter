import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/model/FundsWithdrawal.dart';
import 'package:jimmy_exchange/core/model/giftcard_category.dart';
import 'package:jimmy_exchange/core/model/giftcard_product.dart';
import 'package:jimmy_exchange/core/model/saved_bank.dart';
import 'package:jimmy_exchange/core/model/select_giftcard_product_model.dart';
import 'package:jimmy_exchange/presentation/dashboard/index.dart';
import 'package:jimmy_exchange/presentation/giftcard/sell/sell_giftcard_1.dart';
import 'package:jimmy_exchange/presentation/intro/intro_view.dart';
import 'package:jimmy_exchange/presentation/login/login_view.dart';
import 'package:jimmy_exchange/presentation/resources/route_arg/giftcard_arg.dart';
import 'package:jimmy_exchange/presentation/resources/route_arg/otp_verification_arg.dart';
import 'package:jimmy_exchange/presentation/resources/route_arg/sell_crypto_details_arg.dart';
import 'package:jimmy_exchange/presentation/sign_up/otp_verification_view.dart';
import 'package:jimmy_exchange/presentation/wallet/withdraw/ConfirmFundsWithdrawalDetails.dart';
import 'package:jimmy_exchange/presentation/widgets/giftcard/confrim_giftcard_sell.dart';
import 'package:jimmy_exchange/presentation/widgets/modals/enter_transaction_pin.dart';
import 'package:jimmy_exchange/presentation/widgets/modals/select_giftcard_category.dart';
import 'package:jimmy_exchange/presentation/widgets/modals/select_product_category.dart';
import 'package:jimmy_exchange/presentation/widgets/modals/select_saved_bank.dart';
import 'package:jimmy_exchange/presentation/widgets/popups/success_failed_popup.dart';

import '../../core/model/buy_and_sell_giftcard_view_model.dart';
import '../../core/model/giftcard_txn_history.dart';
import '../../core/model/wallet_txn_history.dart';
import '../all_transactions/all_txn_history.dart';
import '../banner/banner_view.dart';
import '../crypto/buy/buy_crypto.dart';
import '../crypto/crypto_txn_history.dart';
import '../crypto/crypto_txn_history_details.dart';
import '../crypto/sell/sell_crypto.dart';
import '../giftcard/buy_giftcard.dart';
import '../giftcard/giftcard_txn_history.dart';
import '../giftcard/giftcard_txn_history_details.dart';
import '../giftcard/giftcard_unit_list.dart';
import '../giftcard/sell/sell_giftcard_2.dart';
import '../login/two_fa_view.dart';
import '../notification/notification_view.dart';
import '../password_reset/password_reset_1.dart';
import '../password_reset/password_reset_2.dart';
import '../password_reset/password_reset_3.dart';
import '../password_reset/password_reset_status.dart';
import '../referrals/referral_history.dart';
import '../referrals/referrals.dart';
import '../settings/account/account_info_view.dart';
import '../settings/bank/add_bank_view.dart';
import '../settings/bank/bank_information_view.dart';
import '../settings/bank/remove_bank_view.dart';
import '../settings/security/change_password/change_password_view.dart';
import '../settings/security/security_view.dart';
import '../settings/security/transaction_pin/change_transaction_pin.dart';
import '../settings/security/transaction_pin/reset_transaction_pin.dart';
import '../settings/support_center/index.dart';
import '../sign_up/sign_up_view.dart';
import '../splash/app_update_view.dart';
import '../splash/splash_view.dart';
import '../wallet/wallet_txn_history.dart';
import '../wallet/wallet_txn_history_details.dart';
import '../wallet/withdraw/withdraw_fund.dart';
import '../widgets/crypto/confirm_crypto_txn.dart';
import '../widgets/crypto/sell_crypto_details.dart';
import '../widgets/custom/custom_page_route.dart';
import 'route_arg/two_fa_arg copy.dart';
import 'route_arg/two_fa_arg.dart';

class RoutesManager {
  static const String splashRoute = "/";
  static const String appUpdateView = "/appUpdateView";
  static const String introRoute = "/introRoute";
  static const String loginRoute = "/loginRoute";
  static const String twoFARoute = "/twoFARoute";

  static const String signupRoute = "/signupRoute";
  static const String otpVerificationRoute = "/otpVerificationRoute";
  static const String passwordReset1Route = "/passwordReset1Route";
  static const String passwordReset2Route = "/passwordReset2Route";
  static const String passwordReset3Route = "/passwordReset3Route";
  static const String passwordResetStatusRoute = "/passwordResetStatusRoute";

  //
  static const String dashboardRoute = "/dashboardRoute";
  static const String notificationRoute = "/notificationRoute";

  //
  static const String buyGiftcardRoute = "/buyGiftcardRoute";
  static const String sellGiftcard1Route = "/sellGiftcard1Route";
  static const String sellGiftcard2Route = "/sellGiftcard2Route";
  static const String giftcardTxnHistoryView = "/giftcardTxnHistoryView";
  static const String giftcardTxnHistoryDetailsView =
      "/giftcardTxnHistoryDetailsView";
  static const String giftcardUnitListView = "/giftcardUnitListView";
  static const String giftCardCategories = "/giftCardCategories";
  static const String giftCardProducts = "/giftCardProducts";
  static const String selectBankAccount = "/selectBankAccount";
  static const String confirmCardSale = "/confirmCardSale";
  static const String confirmYourWithdrawalDetail =
      "/confirmYourWithdrawalDetail";

  //
  static const String buyCryptoRoute = "/buyCryptoRoute";
  static const String confirmCryptoTxn = "/confirmCryptoTxn";
  static const String sellCryptoView = "/sellCryptoView";
  static const String sellCryptoDetailsView = "/sellCryptoDetailsView";
  static const String cryptoTxnHistoryView = "/cryptoTxnHistoryView";
  static const String cryptoTxnHistoryDetails = "/cryptoTxnHistoryDetails";

  // SETTINGS
  static const String accountInfoRoute = "/accountInfoRoute";
  static const String bankInformationRoute = "/bankInformationRoute";
  static const String addBankRoute = "/addBankRoute";
  static const String supportRoute = "/supportRoute";
  static const String removeBankRoute = "/removeBankRoute";
  static const String securityRoute = "/securityRoute";
  static const String changePasswordRoute = "/changePasswordRoute";

  // static const String setupTransactionPinView = "/setupTransactionPinView";
  static const String changeTransactionPinView = "/changeTransactionPinView";
  static const String recoverTransactionPinView = "/recoverTransactionPinView";

  // WALLET
  static const String withdrawFundRoute = "/withdrawFundRoute";
  static const String walletTxnHistoryDetails = "/walletTxnHistoryDetails";
  static const String walletTxnHistoryView = "/walletTxnHistoryView";

  // ALL TRANSACTION
  static const String allTxnHistoryView = "/allTxnHistoryView";
  static const String bannerView = "/bannerView";

  // Referrals
  static const String referralsView = "/referralsView";
  static const String referralHistoryView = "/referralHistoryView";

  //Transaction Pin
  static const String transactionPin = "/transactionPin";

  static const String transactionStatus = "/transactionStatus";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesManager.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case RoutesManager.appUpdateView:
        return MaterialPageRoute(builder: (_) => const AppUpdateView());
      case RoutesManager.introRoute:
        return MaterialPageRoute(builder: (_) => const IntroView());
      case RoutesManager.loginRoute:
        return DirectionPageRoute(
            settings: settings,
            direction: AxisDirection.up,
            child: const LoginView());
      case RoutesManager.twoFARoute:
        return MaterialPageRoute(
            builder: (_) => TwoFAView(param: settings.arguments as TwoFaArg));
      case RoutesManager.signupRoute:
        return DirectionPageRoute(
            settings: settings,
            direction: AxisDirection.up,
            child: const SignUpView());

      case RoutesManager.otpVerificationRoute:
        return MaterialPageRoute(
            builder: (_) => OtpVerificationView(
                param: settings.arguments as OtpVerificationArg));
      case RoutesManager.passwordReset1Route:
        return MaterialPageRoute(builder: (_) => const PasswordReset1View());
      case RoutesManager.passwordReset2Route:
        return MaterialPageRoute(
            builder: (_) =>
                PasswordReset2View(email: settings.arguments as String));
      case RoutesManager.passwordReset3Route:
        return MaterialPageRoute(
            builder: (_) => PasswordReset3View(
                param: settings.arguments as PasswordReset3Arg));
      case RoutesManager.passwordResetStatusRoute:
        return MaterialPageRoute(
            builder: (_) => const PasswordResetStatusView());

      //
      case RoutesManager.dashboardRoute:
        return MaterialPageRoute(builder: (_) => const DashboardView());
      case RoutesManager.notificationRoute:
        return MaterialPageRoute(builder: (_) => const NotificationView());

      //
      case RoutesManager.sellGiftcard1Route:
        return MaterialPageRoute(
            builder: (_) => SellGiftcard1View(
                params: settings.arguments as BuyAndSaleGiftCardViewParams));
      case RoutesManager.buyGiftcardRoute:
        return MaterialPageRoute(builder: (_) => const BuyGiftcardView());
      case RoutesManager.sellGiftcard2Route:
        return MaterialPageRoute(
            builder: (_) => SellGiftcard2View(
                param: settings.arguments as List<SellGiftCard2Arg>));
      case RoutesManager.giftcardTxnHistoryView:
        return MaterialPageRoute(
            builder: (_) => const GiftcardTxnHistoryView());
      case RoutesManager.giftcardTxnHistoryDetailsView:
        return MaterialPageRoute(
            builder: (_) => GiftcardTxnHistoryDetailsView(
                reference: settings.arguments as String));
      case RoutesManager.giftcardUnitListView:
        return MaterialPageRoute(
            builder: (_) => GiftcardUnitListView(
                param: settings.arguments as GiftcardTxnHistory));

      //
      case RoutesManager.buyCryptoRoute:
        return MaterialPageRoute(builder: (_) => const BuyCryptoView());
      case RoutesManager.sellCryptoView:
        return MaterialPageRoute(builder: (_) => const SellCryptoView());
      case RoutesManager.sellCryptoDetailsView:
        return MaterialPageRoute(
            builder: (_) => SellCryptoDetailsView(
                param: settings.arguments as SellCryptoDetailsArg));
      case RoutesManager.cryptoTxnHistoryView:
        return MaterialPageRoute(builder: (_) => const CryptoTxnHistoryView());
      case RoutesManager.cryptoTxnHistoryDetails:
        return MaterialPageRoute(
            builder: (_) => CryptoTxnHistoryDetails(
                reference: settings.arguments as String));
      case RoutesManager.confirmCryptoTxn:
        return MaterialPageRoute(
            builder: (_) => ConfirmCryptoTxn(
                param: settings.arguments as ConfirmCryptoTxnArg));

      //SETTINGS
      case RoutesManager.bankInformationRoute:
        return MaterialPageRoute(builder: (_) => const BankInformationView());
      case RoutesManager.addBankRoute:
        return MaterialPageRoute(builder: (_) => const AddBankView());
      case RoutesManager.removeBankRoute:
        return MaterialPageRoute(
            builder: (_) =>
                RemoveBankView(param: settings.arguments as SavedBank));
      case RoutesManager.securityRoute:
        return MaterialPageRoute(builder: (_) => const SecurityView());
      case RoutesManager.supportRoute:
        return MaterialPageRoute(builder: (_) => const SupportView());
      case RoutesManager.changePasswordRoute:
        return MaterialPageRoute(builder: (_) => const ChangePasswordView());
      case RoutesManager.accountInfoRoute:
        return MaterialPageRoute(builder: (_) => const AccountInfoView());
      // case RoutesManager.setupTransactionPinView:
      //   return MaterialPageRoute(
      //       builder: (_) => const SetupTransactionPinView());
      case RoutesManager.changeTransactionPinView:
        return MaterialPageRoute(
            builder: (_) => const ChangeTransactionPinView());
      case RoutesManager.recoverTransactionPinView:
        return MaterialPageRoute(
            builder: (_) => const RecoverTransactionPinView());

      //Wallet
      case RoutesManager.withdrawFundRoute:
        return MaterialPageRoute(builder: (_) => const WithdrawFundView());
      case RoutesManager.walletTxnHistoryView:
        return MaterialPageRoute(builder: (_) => const WalletTxnHistoryView());
      case RoutesManager.walletTxnHistoryDetails:
        return MaterialPageRoute(
            builder: (_) => WalletTxnHistoryDetails(
                param: settings.arguments as WalletTxnHistory));

      case RoutesManager.allTxnHistoryView:
        return MaterialPageRoute(builder: (_) => const AllTxnHistoryView());

      case RoutesManager.bannerView:
        return MaterialPageRoute(builder: (_) => const BannerView());

      case RoutesManager.referralsView:
        return MaterialPageRoute(builder: (_) => const ReferralsView());
      case RoutesManager.referralHistoryView:
        return MaterialPageRoute(builder: (_) => const ReferralHistoryView());
      case RoutesManager.giftCardCategories:
        return MaterialPageRoute<GiftcardCategory?>(
            builder: (_) => SelectGiftcardCategory(
                  current: settings.arguments as GiftcardCategory?,
                  isSale: true,
                ));
      case RoutesManager.giftCardProducts:
        return MaterialPageRoute<GiftcardProduct?>(builder: (_) {
          final SelectGiftCardProduct selectGiftCardProduct =
              settings.arguments as SelectGiftCardProduct;
          return SelectGiftcardProduct(
            current: selectGiftCardProduct.current,
            country: selectGiftCardProduct.country,
            giftcardCategory: selectGiftCardProduct.giftCardCategory,
          );
        });

      case RoutesManager.selectBankAccount:
        return MaterialPageRoute(builder: (_) {
          return SelectSavedBank(
            arg: settings.arguments as List<SellGiftCard2Arg>?,
          );
        });

      case RoutesManager.confirmCardSale:
        return MaterialPageRoute(builder: (_) {
          return ConfirmGiftCardSell(
            name: "Confirm Your Sale Details",
            arg: settings.arguments as List<SellGiftCard2Arg>,
          );
        });

      case RoutesManager.confirmYourWithdrawalDetail:
        return MaterialPageRoute(builder: (_) {
          return ConfirmFundsWithdrawalDetails(
              name: 'Confirm your Withdrawal Details',
              params: settings.arguments as FundsWithdrawal
              // name: "Confirm Your Withdrawal Detail ",

              );
        });

      case RoutesManager.transactionPin:
        return MaterialPageRoute<String>(builder: (_) {
          return EnterTransactionPin();
        });
      case RoutesManager.transactionStatus:
        return MaterialPageRoute<String>(builder: (_) {
          return SuccessFailedPopup(
            isSuccess: settings.arguments as bool,
          );
        });
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text("404")),
        body: const Center(
          child: Text("404 Page Not Found"),
        ),
      ),
    );
  }
}
