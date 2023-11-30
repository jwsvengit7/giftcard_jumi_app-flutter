import 'package:jimmy_exchange/presentation/resources/image_manager.dart';

class OnboardingContent {
  final String title;
  final String subtitle;
  final String imgUrl;

  OnboardingContent(
      {required this.title, required this.subtitle, required this.imgUrl});

  static List<OnboardingContent> data = [
    OnboardingContent(
      title: "Buy and Sell Giftcards at affordable rates.",
      subtitle:
          "Get the best rates to purchase and sell all giftcards Get the best rates to purchase and sell all giftcardsGet the best rates to purch",
      imgUrl: ImageManager.kOnboarding1,
    ),
    OnboardingContent(
      title: "Buy and Sell Crypto at affordable rates.",
      subtitle:
          "Get the best rates to purchase and sell all giftcards Get the best rates to purchase and sell all giftcardsGet the best rates to purch",
      imgUrl: ImageManager.kOnboarding2,
    ),
    OnboardingContent(
      title: "Trade at the best and most affordable rates",
      subtitle:
          "Get the best rates to purchase and sell all giftcards Get the best rates to purchase and sell all giftcardsGet the best rates to purch",
      imgUrl: ImageManager.kOnboarding3,
    )

    //
  ];
}
