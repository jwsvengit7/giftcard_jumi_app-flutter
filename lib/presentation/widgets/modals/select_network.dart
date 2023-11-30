import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/model/network.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/crypto.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';

import '../../../core/helpers/generic_helper.dart';
import '../../../core/model/asset.dart';
import '../../resources/values_manager.dart';
import '../custom_input_field.dart';
import '../no_content.dart';
import '../shimmers/square_shimmer.dart';

class SelectNetwork extends StatefulWidget {
  final Network? current;
  final Asset asset;
  const SelectNetwork({Key? key, required this.current, required this.asset})
      : super(key: key);

  @override
  State<SelectNetwork> createState() => _SelectNetworkState();
}

class _SelectNetworkState extends State<SelectNetwork> {
  bool fetching = false;
  TextEditingController searchController = TextEditingController();
  List<Network> filteredLst = [];
  List<Network> allLst = [];

  ScrollController scrollController = ScrollController();

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
    await GenericHelper.getNetwork(widget.asset.id ?? "",
            param: "&page=$current_page")
        .then((val) {
      if (val.isNotEmpty) {
        current_page = current_page + 1;
        allLst.addAll(val);
      }
    }).catchError((_) {});

    fetching = false;
    paginatedLoading = false;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  //

  //

  Timer? timer;
  Future<void> startSearch(String arg) async {
    filteredLst.clear();
    if (arg.isEmpty) return;
    if (mounted) setState(() => fetching = true);
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 750), () async {
      filteredLst = await GenericHelper.getNetwork(widget.asset.id ?? "",
          filterName: arg);
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    Text('Select Network',
                        style: get16TextStyle()
                            .copyWith(fontWeight: FontWeight.w400))
                  ],
                )),
            CustomInputField(
              hintText: "Search for Network",
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
                      ? NoContent(
                          spacing: const SizedBox(height: 10),
                          desc:
                              "An error occured while fetching network list, please contact support if this issue persist.",
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
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: (1 / .1),
                            mainAxisSpacing: 24,
                          ),
                          padding: const EdgeInsets.only(top: 27),
                          controller: scrollController,
                          addAutomaticKeepAlives: false,
                          shrinkWrap: true,
                          itemCount: searchController.text.isNotEmpty
                              ? filteredLst.length
                              : allLst.length,
                          itemBuilder: (_, int i) {
                            Network item = searchController.text.isNotEmpty
                                ? filteredLst[i]
                                : allLst[i];
                            return buildNetworkTile(
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
