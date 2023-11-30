// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/model/saved_bank.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/shimmers/square_shimmer.dart';
import 'custom_indicator.dart';

class BankAccountSelector<T> extends StatefulWidget {
  final String name;

  const BankAccountSelector({Key? key, required this.name}) : super(key: key);

  @override
  State<BankAccountSelector> createState() => _BankAccountSelectorState();
}

class _BankAccountSelectorState<T> extends State<BankAccountSelector<T>> {
  ScrollController scrollController = ScrollController();
  bool fetchingData = false;
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

  List<SavedBank> dataList = [];

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

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  style: get16TextStyle().copyWith(fontWeight: FontWeight.w400),
                )
                //

                //
              ],
            ),
          ),
          Expanded(
            child: fetchingData
                ? ListView.separated(
                    padding: const EdgeInsets.only(top: 27),
                    separatorBuilder: ((context, index) =>
                        const SizedBox(height: 20)),
                    itemCount: 5,
                    itemBuilder: (_, int i) =>
                        const SquareShimmer(width: double.infinity, height: 50),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(top: 27),
                    controller: scrollController,
                    itemCount: dataList.length + 1,
                    itemBuilder: (_, int i) {
                      if (i < dataList.length) {
                        SavedBank current = dataList[i];

                        return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => Navigator.pop(context, current),
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 0.5,
                                  color: ColorManager.kTxnTileBorderColor,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        current.bank?.name ?? "",
                                        style: get16TextStyle().copyWith(
                                            color: ColorManager.kGray1,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        current.account_name ?? "",
                                        style: get16TextStyle().copyWith(
                                            color: ColorManager.kGray1,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("${current.account_number}"),
                                      const SizedBox(width: 10),
                                      buildCircularIndicator(false),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return GestureDetector(
                        child: Text("+ Add Bank"),
                      );
                    },
                    separatorBuilder: (_, i) => const SizedBox(height: 20),
                  ),
          ),
          isPaginatedloading
              ? const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: SquareShimmer(height: 40, width: double.infinity))
              : const SizedBox()
        ],
      ),
    );
  }
}
