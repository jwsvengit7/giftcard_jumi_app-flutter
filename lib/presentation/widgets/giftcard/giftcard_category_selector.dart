// // ignore_for_file: must_be_immutable

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:ksb_tech/presentation/resources/styles_manager.dart';
// import 'package:ksb_tech/presentation/widgets/custom_input_field.dart';

// import '../../../core/model/giftcard_category.dart';
// import '../shimmers/square_shimmer.dart';

// class GiftcardCategorySelector<T> extends StatefulWidget {
//   final String name;
//   final String hintText;

//   const GiftcardCategorySelector(
//       {Key? key, required this.name, required this.hintText})
//       : super(key: key);

//   @override
//   State<GiftcardCategorySelector> createState() =>
//       _GiftcardCategorySelectorState();
// }

// class _GiftcardCategorySelectorState<T>
//     extends State<GiftcardCategorySelector<T>> {
//   TextEditingController searchController = TextEditingController();
//   ScrollController scrollController = ScrollController();
//   bool fetchingData = false;
//   List<GiftcardCategory> searchedList = [];
//   bool isPaginatedloading = false;

//   void pagination() async {
//     if ((scrollController.position.pixels ==
//             scrollController.position.maxScrollExtent &&
//         !isPaginatedloading)) {
//       // setState(() => isPaginatedloading = true);
//       // await widget.paginateCall().then((value) {
//       //   widget.dataList = value;
//       // }).catchError((e) {});

//       setState(() => isPaginatedloading = false);
//     }
//   }

//   List<GiftcardCategory> dataList = GiftcardCategory.data;

//   @override
//   void dispose() {
//     scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       scrollController.addListener(pagination);
//       // if (widget.loadOnfirstMount) setState(() => fetchingData = true);
//       // await widget.initCall().then((val) {
//       //   if (val.isEmpty) return;
//       //   widget.dataList = val;
//       // }).catchError((e) {});
//       setState(() => fetchingData = false);
//     });
//     super.initState();
//   }

//   Timer? timer;
//   Future<void> startSearch(String arg) async {
//     searchedList.clear();
//     if (arg.isEmpty) return;
//     setState(() => fetchingData = true);
//     timer?.cancel();
//     timer = Timer(const Duration(milliseconds: 750), () async {
//       // searchedList = await widget.searchCall(arg);
//       fetchingData = false;
//       if (mounted) setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         color: Colors.white,
//         height: 650,
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 24, bottom: 10),
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     behavior: HitTestBehavior.translucent,
//                     onTap: () => Navigator.pop(context),
//                     child: const Padding(
//                       padding: EdgeInsets.all(5),
//                       child: Icon(Icons.arrow_back_ios, size: 15),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     widget.name,
//                     style:
//                         get16TextStyle().copyWith(fontWeight: FontWeight.w400),
//                   )
//                   //

//                   //
//                 ],
//               ),
//             ),
//             CustomInputField(
//               hintText: widget.hintText,
//               textEditingController: searchController,
//               // onChanged: (e) => startSearch(e),
//               onChanged: (value) {},
//               prefixIcon: const Padding(
//                 padding: const EdgeInsets.only(left: 20, right: 5),
//                 child: SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: Center(child: Icon(Icons.search_sharp)),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: fetchingData
//                   ? ListView.separated(
//                       padding: const EdgeInsets.only(top: 27),
//                       separatorBuilder: ((context, index) =>
//                           const SizedBox(height: 20)),
//                       itemCount: 5,
//                       itemBuilder: (_, int i) => const SquareShimmer(
//                           width: double.infinity, height: 50),
//                     )
//                   : ListView.separated(
//                       padding: const EdgeInsets.only(top: 27),
//                       controller: scrollController,
//                       itemCount: searchController.text.trim().isEmpty
//                           ? dataList.length
//                           : searchedList.length,
//                       itemBuilder: (_, int i) {
//                         GiftcardCategory current =
//                             searchController.text.trim().isEmpty
//                                 ? dataList[i]
//                                 : searchedList[i];

//                         return GestureDetector(
//                           behavior: HitTestBehavior.translucent,
//                           onTap: () => Navigator.pop(context, current),
//                           child: Row(
//                             children: [
//                               Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(50),
//                                 ),
//                                 child: Image.asset(current.imgUrl,
//                                     width: 32, height: 32),
//                               ),
//                               const SizedBox(width: 16),
//                               Expanded(
//                                 child: Text(current.name,
//                                     style: get16TextStyle()
//                                         .copyWith(fontWeight: FontWeight.w400)),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                       separatorBuilder: (_, i) => const SizedBox(height: 24),
//                     ),
//             ),
//             isPaginatedloading
//                 ? const Padding(
//                     padding: EdgeInsets.only(bottom: 20),
//                     child: SquareShimmer(height: 40, width: double.infinity))
//                 : const SizedBox()
//           ],
//         ),
//       ),
//     );
//   }
// }
