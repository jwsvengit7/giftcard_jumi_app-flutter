import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/model/onboarding_content.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/routes_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/resources/values_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_scaffold.dart';

import '../widgets/spacer.dart';
import '../widgets/custom_indicator.dart';

class IntroView extends StatefulWidget {
  const IntroView({super.key});

  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  final PageController _pageController = PageController();

  List<OnboardingContent> list = OnboardingContent.data;
  int indicator = 0;
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(milliseconds: 2500), (Timer timer) {
      if (indicator < 2) {
        indicator++;
      } else {
        indicator = 0;
      }

      _pageController.animateToPage(
        indicator,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  Widget _itemIndicator(int indicator) {
    Widget? widget;
    if (indicator != list.length) {
      widget = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(list.length, (index) {
            return index == indicator
                ? buildCustomIndicator(true)
                : buildCustomIndicator(false);
          }));
    }
    return widget ?? const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return CustomScaffold(
      backgroundColor: ColorManager.kBackground,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
        controller: _scrollController,
        children: [
          Container(
            margin: EdgeInsets.only(top: isSmallScreen(context) ? 50 : 130),
            height: 600,
            child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Image.asset(list[index].imgUrl, width: 300)),
                      SizedBox(height: size.height * .035),
                      _itemIndicator(index),
                      SizedBox(height: size.height * .05),
                      Column(
                        children: [
                          Text(
                            list[index].title,
                            style: get32TextStyle(),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 9),
                          Text(
                            list[index].subtitle,
                            style: get16TextStyle().copyWith(
                                fontWeight: FontWeight.w400,
                                height: 1.35,
                                color: ColorManager.kTextColor),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  );
                }),
          ),

          // //
          const SizedBox(height: 28),
          CustomBtn(
            isActive: true,
            loading: false,
            text: "Create a Free Account",
            onTap: () {
              Navigator.popAndPushNamed(context, RoutesManager.signupRoute);
            },
          ),
          const SizedBox(height: 42),
        ],
      ),
      bottomSheet: Container(
        color: ColorManager.kBackground,
        height: 42,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?",
                    style: get16TextStyle().copyWith(
                        color: ColorManager.kGrayB3,
                        fontWeight: FontWeight.w400)),
                const SizedBox(width: 6),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Text(
                    "Login Here",
                    style: get16TextStyle().copyWith(
                      decoration: TextDecoration.underline,
                      color: ColorManager.kNavyBlue,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, RoutesManager.loginRoute);
                  },
                ),
              ],
            ),
            const BottomSpacer(height: 20),
          ],
        ),
      ),
    );
  }
}
