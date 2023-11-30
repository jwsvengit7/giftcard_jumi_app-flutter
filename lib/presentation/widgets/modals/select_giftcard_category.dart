import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_back_button.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';

import '../../../core/helpers/generic_helper.dart';
import '../../../core/model/giftcard_category.dart';
import '../../resources/values_manager.dart';
import '../custom_input_field.dart';
import '../giftcard.dart';
import '../no_content.dart';
import '../shimmers/square_shimmer.dart';

class SelectGiftcardCategory extends StatefulWidget {
  final bool isSale;
  final GiftcardCategory? current;
  const SelectGiftcardCategory(
      {Key? key, required this.current, required this.isSale})
      : super(key: key);

  @override
  State<SelectGiftcardCategory> createState() => _SelectGiftcardCategoryState();
}

class _SelectGiftcardCategoryState extends State<SelectGiftcardCategory> {
  bool fetching = false;
  TextEditingController searchController = TextEditingController();
  List<GiftcardCategory> filteredLst = [];
  List<GiftcardCategory> allLst = [];
  int current_page = 1;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() => fetching = true);
      await fetchHistory();
    });
    scrollController.addListener(pagination);
    super.initState();
  }

  ScrollController scrollController = ScrollController();
  bool paginatedLoading = false;

  void pagination() async {
    if ((scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !paginatedLoading)) {
      setState(() => paginatedLoading = true);
      fetchHistory();
    }
  }

  Future<void> fetchHistory() async {
    await GenericHelper.getGiftcardCategories("&page=$current_page",
            isSale: widget.isSale)
        .then((value) {
      if (value.isNotEmpty) {
        current_page = current_page + 1;

        allLst.addAll(value);
      }

      if (mounted) {
        setState(() {
          fetching = false;
          paginatedLoading = false;
        });
      }
    }).catchError((e) {
      recordError();
    });

    setState(() {
      fetching = false;
      paginatedLoading = false;
    });
  }

  Timer? timer;
  Future<void> startSearch(String arg) async {
    filteredLst.clear();
    if (arg.isEmpty) return;
    if (mounted) setState(() => fetching = true);
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 750), () async {
      filteredLst = await GenericHelper.getGiftcardCategories(
        "&filter[name]=$arg",
        isSale: widget.isSale,
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 80, bottom: 20),
                  child: Row(
                    children: [
                      CustomBackButton(),
                      Expanded(
                        child: Center(
                          child: Text('Category',
                              style: get20TextStyle(
                                  color: ColorManager.kBlack,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700)),
                        ),
                      )
                    ],
                  )),
              CustomInputField(
                hintText: "Search for Category",
                textEditingController: searchController,
                onChanged: (e) => startSearch(e),
                fillColor: ColorManager.kWhite,
                decoration: getSearchInputDecoration(
                  hintText: "Search Category",
                  hintTextStyle:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
                ),
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
                    : allLst.isEmpty
                        ? NoContent(
                            spacing: const SizedBox(height: 10),
                            desc:
                                "An error occured while fetching giftcard category list, please contact support if the issue persist.",
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
                                await fetchHistory();
                                if (mounted) {
                                  setState(() => fetching = false);
                                }
                              },
                              text: "Refresh",
                            ),
                          )
                        : Expanded(
                            child: GridView.builder(
                              padding:
                                  const EdgeInsets.only(top: 27, bottom: 37),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // 2 items per row
                                crossAxisSpacing: 10
                                    .w, // Add horizontal spacing between items
                                mainAxisSpacing:
                                    10.w, // Add vertical spacing between items
                              ),
                              controller: scrollController,
                              shrinkWrap: true,
                              itemCount: searchController.text.isNotEmpty
                                  ? filteredLst.length
                                  : allLst.length,
                              itemBuilder: (_, int i) {
                                GiftcardCategory item =
                                    searchController.text.isNotEmpty
                                        ? filteredLst[i]
                                        : allLst[i];
                                return buildGiftcardCategoryTile(
                                  current: item,
                                  onTap: () {
                                    return Navigator.pop(context, item);
                                  },
                                  selected: item.id == widget.current?.id,
                                );
                              },
                            ),
                          ),
              ),
              paginatedLoading
                  ? const Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: SquareShimmer(height: 50, width: double.infinity))
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
