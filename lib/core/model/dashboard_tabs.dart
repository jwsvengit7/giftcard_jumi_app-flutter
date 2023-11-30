import 'package:jimmy_exchange/presentation/resources/image_manager.dart';

class DashboardTabs {
  final String name;
  final String activeUrl;
  final String inactiveUrl;
  final double height;
  final double width;

  DashboardTabs(
      {required this.name,
      required this.activeUrl,
      required this.inactiveUrl,
      required this.height,
      required this.width});

  static List<DashboardTabs> data = [
    DashboardTabs(
        name: "Home",
        activeUrl: ImageManager.kHomeActive,
        inactiveUrl: ImageManager.kHomeInActive,
        width: 35,
        height: 52),
    DashboardTabs(
        name: "Giftcard",
        activeUrl: ImageManager.kGiftCardActive,
        inactiveUrl: ImageManager.kGiftCardInActive,
        width: 55,
        height: 52),
    DashboardTabs(
        name: "Crypto",
        activeUrl: ImageManager.kCryptoActive,
        inactiveUrl: ImageManager.kCryptoInActive,
        width: 39,
        height: 53),
    DashboardTabs(
        name: "Wallet",
        activeUrl: ImageManager.kWalletActive,
        inactiveUrl: ImageManager.kWalletInActive,
        width: 37,
        height: 52),
    DashboardTabs(
        name: "Settings",
        activeUrl: ImageManager.kSettingActive,
        inactiveUrl: ImageManager.kSettingsInActive,
        width: 48,
        height: 53),
  ];
}
