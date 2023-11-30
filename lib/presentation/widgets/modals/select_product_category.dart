import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/core/model/country.dart';
import 'package:jimmy_exchange/core/model/giftcard_product.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_back_button.dart';

import '../../../core/helpers/generic_helper.dart';
import '../../../core/model/giftcard_category.dart';
import '../../resources/values_manager.dart';
import '../custom_btn.dart';
import '../custom_input_field.dart';
import '../giftcard.dart';
import '../no_content.dart';
import '../shimmers/square_shimmer.dart';

class SelectGiftcardProduct extends StatefulWidget {
  final GiftcardProduct? current;
  final GiftcardCategory? giftcardCategory;
  final Country? country;
  const SelectGiftcardProduct(
      {Key? key,
      required this.current,
      required this.giftcardCategory,
      required this.country})
      : super(key: key);

  @override
  State<SelectGiftcardProduct> createState() => _SelectGiftcardProductState();
}

class _SelectGiftcardProductState extends State<SelectGiftcardProduct> {
  bool fetching = false;
  TextEditingController searchController = TextEditingController();
  List<GiftcardProduct> filteredLst = [];
  List<GiftcardProduct> products = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() => fetching = true);
      await fetchProducts();
    });
    scrollController.addListener(pagination);
    super.initState();
  }

  int current_page = 1;
  bool paginatedLoading = false;
  ScrollController scrollController = ScrollController();

  void pagination() async {
    if ((scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !paginatedLoading)) {
      setState(() => paginatedLoading = true);
      fetchProducts();
    }
  }

  Future<void> fetchProducts() async {
    if (mounted) setState(() => fetching = true);
    await GenericHelper.getGiftcardProducts(
      "&page=$current_page",
      country_id: widget.country?.id ?? "",
      giftcard_category_id: widget.giftcardCategory?.id ?? "",
    ).then((val) {
      if (val.isNotEmpty) {
        current_page = current_page + 1;
        products.addAll(val);
      }
    }).catchError((_) {});

    fetching = false;
    paginatedLoading = false;
    if (mounted) setState(() {});
  }

  Timer? timer;
  Future<void> startSearch(String arg) async {
    filteredLst.clear();
    if (arg.isEmpty) return;
    if (mounted) setState(() => fetching = true);
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 750), () async {
      filteredLst = await GenericHelper.getGiftcardProducts(
        "&filter[name]=$arg",
        country_id: widget.country?.id ?? "",
        giftcard_category_id: widget.giftcardCategory?.id ?? "",
      );
      fetching = false;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                  padding:  EdgeInsets.only(top: 60.h, bottom: 20),
                  child: Row(
                    children: [
                      CustomBackButton(),
                      SizedBox(width: 120.w),
                      Text('Products',
                          style: get16TextStyle(
                                  color: ColorManager.kBlack, fontSize: 20.sp)
                              .copyWith(fontWeight: FontWeight.w700))
                    ],
                  )),
              CustomInputField(
                hintText: "Search for Products",
                textEditingController: searchController,
                onChanged: (e) => startSearch(e),
                decoration: getSearchInputDecoration(hintText:"Search Products"),
              ),
              Expanded(
                child: fetching
                    ? ListView.separated(
                        padding: const EdgeInsets.only(top: 27),
                        separatorBuilder: ((context, index) =>
                            const SizedBox(height: 20)),
                        itemCount: 5,
                        itemBuilder: (_, int i) => const SquareShimmer(
                            width: double.infinity, height: 50),
                      )
                    : getCurrentData().isEmpty
                        ? NoContent(
                            spacing: SizedBox(height: 10),
                            desc:
                                "An error occured while fetching giftcard product category list, please contact support if the issue persist.",
                            btn: CustomBtn(
                              isActive: true,
                              loading: false,
                              width: 120,
                              padding: const EdgeInsets.symmetric(
                                  vertical: AppPadding.p14),
                              onTap: () async {
                                if (mounted) {
                                  setState(() => fetching = true);
                                }
                                await fetchProducts();
                                if (mounted) {
                                  setState(() => fetching = false);
                                }
                              },
                              text: "Refresh",
                            ),
                          )
                        : ListView.separated(
                          controller: scrollController,
                          separatorBuilder: (context, index) =>
                              const Divider(height:0),
                          padding: const EdgeInsets.only(top: 27),
                          addAutomaticKeepAlives: false,
                          shrinkWrap: true,
                          itemCount: getCurrentData().length,
                          itemBuilder: (_, int index) {
                            GiftcardProduct item = getCurrentData()[index];
                            return buildGiftcardProductTile(
                              current: item,
                              isFirst: index == 0
                                  ? true
                                  : index == getCurrentData().length -1
                                      ? false
                                      : null,
                              onTap: () => Navigator.pop(context, item),
                              selected: item.id == widget.current?.id,
                            );
                          },
                        ),
              ),
              paginatedLoading
                  ? const Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: SquareShimmer(height: 50, width: double.infinity))
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  List<GiftcardProduct> getCurrentData() {
    return searchController.text.isNotEmpty ? filteredLst : products;
  }
}
