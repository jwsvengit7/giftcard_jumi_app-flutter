// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_input_field.dart';

import '../../../core/model/giftcard_product.dart';
import '../custom_indicator.dart';
import '../shimmers/square_shimmer.dart';

class GiftcardProductSelector<T> extends StatefulWidget {
  final String name;
  final String hintText;

  const GiftcardProductSelector(
      {Key? key, required this.name, required this.hintText})
      : super(key: key);

  @override
  State<GiftcardProductSelector> createState() =>
      _GiftcardProductSelectorState();
}

class _GiftcardProductSelectorState<T>
    extends State<GiftcardProductSelector<T>> {
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool fetchingData = false;
  List<GiftcardProduct> searchedList = [];
  bool isPaginatedloading = false;

  void pagination() async {
    if ((scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !isPaginatedloading)) {
      // setState(() => isPaginatedloading = true);
      // await widget.paginateCall().then((value) {
      //   widget.dataList = value;
      // }).catchError((e) {});

      setState(() => isPaginatedloading = false);
    }
  }

  List<GiftcardProduct> dataList = [];

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      scrollController.addListener(pagination);
      // if (widget.loadOnfirstMount) setState(() => fetchingData = true);
      // await widget.initCall().then((val) {
      //   if (val.isEmpty) return;
      //   widget.dataList = val;
      // }).catchError((e) {});
      setState(() => fetchingData = false);
    });
    super.initState();
  }

  Timer? timer;
  Future<void> startSearch(String arg) async {
    searchedList.clear();
    if (arg.isEmpty) return;
    setState(() => fetchingData = true);
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 750), () async {
      // searchedList = await widget.searchCall(arg);
      fetchingData = false;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.white,
        height: 420,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 10),
              child: Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.arrow_back_ios, size: 15),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.name,
                    style:
                        get16TextStyle().copyWith(fontWeight: FontWeight.w400),
                  )
                  //

                  //
                ],
              ),
            ),
            CustomInputField(
              hintText: widget.hintText,
              textEditingController: searchController,
              onChanged: (value) {},
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 20, right: 5),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: Center(child: Icon(Icons.search_sharp)),
                ),
              ),
            ),
            Expanded(
              child: fetchingData
                  ? ListView.separated(
                      padding: const EdgeInsets.only(top: 27),
                      separatorBuilder: ((context, index) =>
                          const SizedBox(height: 20)),
                      itemCount: 5,
                      itemBuilder: (_, int i) => const SquareShimmer(
                          width: double.infinity, height: 50),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(top: 27),
                      controller: scrollController,
                      itemCount: searchController.text.trim().isEmpty
                          ? dataList.length
                          : searchedList.length,
                      itemBuilder: (_, int i) {
                        GiftcardProduct current =
                            searchController.text.trim().isEmpty
                                ? dataList[i]
                                : searchedList[i];

                        return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => Navigator.pop(context, current),
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 0.5,
                                      color: ColorManager.kTxnTileBorderColor)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      current.name ?? "",
                                      style: get16TextStyle().copyWith(
                                          color: ColorManager.kGray1,
                                          fontWeight: FontWeight.w400),
                                    )),
                                    buildCircularIndicator(false),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Expanded(
                                    //     flex: 1,
                                    //     child:
                                    //         Text("Rate: ${current.rate ?? 0}")),
                                    // Expanded(
                                    //     flex: 1,
                                    //     child: Text(
                                    //         "Minimum: ${current.minimum}")),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, i) => const SizedBox(height: 16),
                    ),
            ),
            isPaginatedloading
                ? const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: SquareShimmer(height: 40, width: double.infinity))
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
