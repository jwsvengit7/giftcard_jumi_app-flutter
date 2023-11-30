import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/core/helpers/user_helper.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_appbar.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_back_button.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_scaffold.dart';

import '../resources/color_manager.dart';
import '../resources/styles_manager.dart';
import '../widgets/no_content.dart';
import '../widgets/shimmers/square_shimmer.dart';
import '../widgets/tiles/notification_tile.dart';
import '../../core/model/app_notification.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  ScrollController scrollController = ScrollController();
  bool paginatedLoading = false;
  bool fetching = true;

  int all_txn_page = 1;
  List<AppNotification> transactionHistory = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchHistory();
    });
    scrollController.addListener(pagination);
    super.initState();
  }

  void pagination() async {
    if ((scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !paginatedLoading)) {
      setState(() => paginatedLoading = true);
      fetchHistory();
    }
  }

  //
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      color: ColorManager.kBackground,
      child: CustomScaffold(
        appBar: CustomAppBar(
          leading: CustomBackButton(),
          leadingWidth: 36.w,
          toolbarHeight: 60.h,
          backgroundColor: ColorManager.kBackground,
          title: Text("Notifications", style: get20TextStyle(fontSize: 20.sp)),
        ),
        backgroundColor: ColorManager.kBackground,
        body: Column(
          children: [
            fetching
                ? Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(top: 15),
                      separatorBuilder: ((context, index) =>
                          const SizedBox(height: 20)),
                      itemCount: 5,
                      itemBuilder: (_, int i) => const SquareShimmer(
                          width: double.infinity, height: 50),
                    ),
                  )
                : transactionHistory.isEmpty
                    ? const NoContent()
                    : Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 30),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6.r),
                            child: ListView.separated(
                              controller: scrollController,
                              //padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: transactionHistory.length,
                              itemBuilder: (context, index) {
                                AppNotification curr =
                                    transactionHistory[index];

                                return NotificationTile(param: curr);
                              },
                              separatorBuilder: (((context, index) => Divider(
                                    height: 0,
                                  ))),
                            ),
                          ),
                        ),
                      ),

            //
            // PAGINATING...
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

  Future<void> fetchHistory() async {
    // ADD QUERY FOR SEARCH AND FILTER IF AVAILABLE
    String query = "?per_page=100&page=$all_txn_page&sort=-created_at";

    await UserHelper.getNotifications(query).then((value) {
      if (value.isNotEmpty) {
        all_txn_page = all_txn_page + 1;
      }
      transactionHistory.addAll(value);

      if (mounted) {
        setState(() {
          fetching = false;
          paginatedLoading = false;
        });
      }
    }).catchError((err) {
      throw err.toString();
    });

    if (mounted) setState(() => paginatedLoading = false);
  }
}
