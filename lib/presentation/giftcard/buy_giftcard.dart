import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/model/giftcard_product.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_appbar.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_input_field.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_scaffold.dart';

import '../widgets/custom_bottom_sheet.dart';
import '../widgets/custom_indicator.dart';

import '../widgets/giftcard/giftcard_product_selector.dart';

class BuyGiftcardView extends StatefulWidget {
  const BuyGiftcardView({super.key});

  @override
  State<BuyGiftcardView> createState() => _BuyGiftcardViewState();
}

class _BuyGiftcardViewState extends State<BuyGiftcardView> {
  final TextEditingController controller1 = new TextEditingController();
  final TextEditingController controller2 = new TextEditingController();
  final TextEditingController controller3 = new TextEditingController();
  final TextEditingController controller4 = new TextEditingController();
  final TextEditingController controller5 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CustomScaffold(
        backgroundColor: ColorManager.kWhite,
        appBar: CustomAppBar(
          title: Text("Buy Giftcard", style: get20TextStyle()),
        ),
        body: ListView(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 47),
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                // GiftcardCategory? res = await showCustomBottomSheet(
                //     context: context,
                //     screen: const GiftcardCategorySelector(
                //         name: "Categories", hintText: "Search for Category"));

                // setState(() => selectedGiftcard = res);
                // if (res != null) {
                // setState(() {
                //   controller1.text = res.name;
                // });
                // }
              },
              child: IgnorePointer(
                child: CustomInputField(
                  textEditingController: controller1,
                  formHolderName: "Category",
                  hintText: "Select Category",
                  suffixIcon: buildDropDownSuffixIcon(),
                ),
              ),
            ),

            //
            const SizedBox(height: 24),
            CustomInputField(
              textEditingController: controller2,
              formHolderName: "Country",
              hintText: "Select Country",
              suffixIcon: buildDropDownSuffixIcon(),
            ),

            //
            const SizedBox(height: 24),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                GiftcardProduct? res = await showCustomBottomSheet(
                    context: context,
                    screen: const GiftcardProductSelector(
                        name: "Product", hintText: "Search for Product"));

                if (res != null) {
                  setState(() {
                    controller3.text = res.name ?? "";
                  });
                }
              },
              child: IgnorePointer(
                child: CustomInputField(
                  textEditingController: controller3,
                  formHolderName: "Product",
                  hintText: "Select Product",
                  suffixIcon: buildDropDownSuffixIcon(),
                ),
              ),
            ),

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: Text("Rate: --",
                        style: get14TextStyle().copyWith(
                            color: ColorManager.kFormHintText,
                            fontWeight: FontWeight.w400))),
                Expanded(
                    flex: 1,
                    child: Text("Minimum: --",
                        style: get14TextStyle().copyWith(
                            color: ColorManager.kFormHintText,
                            fontWeight: FontWeight.w400))),
              ],
            ),

            //
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Type"),
                      const SizedBox(height: 17),
                      Row(
                        children: [
                          buildCircularIndicator(true),
                          const SizedBox(width: 4),
                          const Text("Physical"),
                          const SizedBox(width: 23),
                          buildCircularIndicator(true),
                          const SizedBox(width: 4),
                          const Text("Virtual")
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Units"),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Image.asset(ImageManager.kSubstraction, width: 16.5),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("1"),
                          ),
                          Image.asset(
                            ImageManager.kAddition,
                            width: 16.5,
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),

            //
            const SizedBox(height: 24),
            CustomInputField(
              formHolderName: "Amount",
              textEditingController: controller4,
              hintText: "Enter Amount",
            ),

            //
            const SizedBox(height: 24),
            CustomInputField(
                textEditingController: controller5,
                formHolderName: "Comment",
                hintText: "Add Comment"),

            //
            Padding(
              padding: const EdgeInsets.only(top: 41, bottom: 47),
              child: CustomBtn(
                isActive: true,
                loading: false,
                text: "Next",
                onTap: () async {
                  // await showCustomBottomSheet(
                  //     context: context,
                  //     screen: const ConfirmGiftcardSell(name: "Confirm Buy"));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
