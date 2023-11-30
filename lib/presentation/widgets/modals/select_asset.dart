import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/model/asset.dart';
import 'package:jimmy_exchange/presentation/resources/values_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/no_content.dart';

import '../../../core/helpers/generic_helper.dart';
import '../../resources/color_manager.dart';
import '../../resources/image_manager.dart';
import '../../resources/styles_manager.dart';
import '../crypto.dart';
import '../custom_input_field.dart';
import '../shimmers/square_shimmer.dart';

class SelectAsset extends StatefulWidget {
  const SelectAsset({
    Key? key,
    this.current,
  }) : super(key: key);

  final Asset? current;

  @override
  State<SelectAsset> createState() => _SearchAssetState();
}

class _SearchAssetState extends State<SelectAsset> {
  bool fetching = false;
  TextEditingController searchController = TextEditingController();
  List<Asset> filteredLst = [];
  List<Asset> allLst = [];
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() => fetching = true);
      await fetchHistory();
    });
    scrollController.addListener(pagination);
    super.initState();
  }

  int current_page = 1;
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
    await GenericHelper.getAssetList("&page=$current_page").then((val) {
      if (val.isNotEmpty) {
        current_page = current_page + 1;
        allLst.addAll(val);
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
      filteredLst = await GenericHelper.getAssetList(null, filterName: arg);
      fetching = false;
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
        height: AppSize.get650ModalHeight(context),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 20),
              child: Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: Image.asset(ImageManager.kArrowBack,
                          color: ColorManager.kPrimaryBlack,
                          width: 12,
                          height: 12),
                    ),
                  ),
                  Text('Select Asset',
                      style: get16TextStyle()
                          .copyWith(fontWeight: FontWeight.w400))
                ],
              ),
            ),
            CustomInputField(
              hintText: "Search",
              textEditingController: searchController,
              onChanged: (e) => startSearch(e),
              decoration: getSearchInputDecoration(),
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
                      ? const NoContent(
                          desc:
                              "There's currently no assets for these selection")
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: (1 / .1),
                            mainAxisSpacing: 24,
                          ),
                          padding: const EdgeInsets.only(top: 27),
                          controller: scrollController,
                          itemCount: searchController.text.isNotEmpty
                              ? filteredLst.length
                              : allLst.length,
                          itemBuilder: (_, int i) {
                            Asset item = searchController.text.isNotEmpty
                                ? filteredLst[i]
                                : allLst[i];
                            return buildAssetTile(
                              current: item,
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
    );
  }
}
