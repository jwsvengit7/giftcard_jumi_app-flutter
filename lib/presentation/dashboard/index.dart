import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/helpers/user_helper.dart';
import 'package:jimmy_exchange/presentation/dashboard/crypto_tab.dart';
import 'package:jimmy_exchange/presentation/dashboard/giftcard_tab.dart';
import 'package:jimmy_exchange/presentation/dashboard/home_tab.dart';
import 'package:jimmy_exchange/presentation/dashboard/settings_tab.dart';
import 'package:jimmy_exchange/presentation/dashboard/wallet_tab.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/settings/security/transaction_pin/setup_transaction_pin.dart';
import 'package:provider/provider.dart';

import '../../core/model/dashboard_tabs.dart';
import '../../core/model/user.dart';
import '../../core/providers/txn_history_provider.dart';
import '../../core/providers/user_provider.dart';
import '../widgets/custom_scaffold.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _currentPage = 0;

  final List<DashboardTabs> pages = DashboardTabs.data;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      loadBasicInfo();
      setFcmToken();
    });
    super.initState();
  }

  Future<void> loadBasicInfo() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    TxnHistoryProvider txnHistoryProvider =
        Provider.of<TxnHistoryProvider>(context, listen: false);
    userProvider.updateProfileInformation();
    txnHistoryProvider.updateCryptoTxnHistory();
    txnHistoryProvider.updateGiftcardTxnHistory();
  }

  Future<void> setFcmToken() async {
    String deviceToken = await getDeviceToken();
    // debugPrint("###### PRINT DEVICE TOKEN TO USE FOR PUSH NOTIFCIATION ######");
    // debugPrint(deviceToken);
    // debugPrint("############################################################");

    // listen for user to click on notification
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {

    // });

    UserHelper.updateFcmToken(deviceToken).catchError((_) {});
  }

  Future getDeviceToken() async {
    //request user permission for push notification
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    String? deviceToken = await messaging.getToken();
    return (deviceToken == null) ? "" : deviceToken;
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    User user = userProvider.user ?? User(wallet_balance: 0);

    return (user.transaction_pin_set == false)
        ? const SetupTransactionPinView()
        : CustomScaffold(
            backgroundColor: ColorManager.kWhite,
            body: AnimatedContainer(
              duration: const Duration(milliseconds: 850),
              child: buildCurrentPage(),
            ),
            bottomSheet: Container(
              color: Colors.white,
              // padding: const EdgeInsets.only(top: 12, bottom: ),
              height:
                  Platform.isIOS && MediaQuery.of(context).size.height <= 740
                      ? 70
                      : Platform.isIOS
                          ? 75
                          : 70,
              // height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: pages.map((e) {
                  int _page = pages.indexOf(e);
                  return GestureDetector(
                    onTap: () {
                      if (_page == _currentPage) return;
                      setState(() => _currentPage = _page);
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Column(
                      children: [
                        Image.asset(
                            _currentPage == _page ? e.activeUrl : e.inactiveUrl,
                            width: e.width,
                            height: e.height),
                        // Text(e.text),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          );
  }

  Widget buildCurrentPage() {
    if (_currentPage == 0) {
      return const HomeTab();
    } else if (_currentPage == 1) {
      return const GiftCardTab();
    } else if (_currentPage == 2) {
      return const CryptoTab();
    } else if (_currentPage == 3) {
      return const WalletTab();
    } else if (_currentPage == 4) {
      return const SettingsTab();
    }
    return const SizedBox();
  }
}
