import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/home_widgets/rate_item.dart';
import 'package:jimmy_exchange/presentation/widgets/rate_type.dart';

class CardAndCryptoRates extends StatefulWidget {
  const CardAndCryptoRates({super.key});

  @override
  State<CardAndCryptoRates> createState() => _CardAndCryptoRatesState();
}

class _CardAndCryptoRatesState extends State<CardAndCryptoRates> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 600 / MediaQuery.of(context).size.height,
        minChildSize: 0.3, // Minimum child size when fully collapsed
        maxChildSize: 0.7, // Maximum child size when fully expanded
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            padding: EdgeInsets.only(top: 10.h),
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: 5.h,
                  width: 78.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: ColorManager.kBorder),
                ),
                Expanded(child: CustomTab(scrollController: scrollController))
              ],
            ),
            
          );
        });
  }
}

class CustomTab extends StatefulWidget {
  const CustomTab({required this.scrollController, super.key});
  final ScrollController scrollController;
  @override
  State<CustomTab> createState() => _CustomTabState();
}

class _CustomTabState extends State<CustomTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Initialize the TabController with a length of 2 and vsync set to `this`
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 240.w),
                child: TabBar(
                  controller: _tabController,
                  labelPadding: EdgeInsets.zero,
                  padding: EdgeInsets.zero,

                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Tab(text: 'Card Rates'),
                    Tab(text: 'Crpto Rates'),
                  ],
                  indicatorColor: ColorManager.kPrimaryBlue, // Customize the indicator color
                  indicatorWeight: 2, // Customize the indicator weight
                  labelColor:
                      ColorManager.kPrimaryBlue, // Customize the selected tab text color
                  unselectedLabelColor:
                      ColorManager.kGreyscale500, // Customize the unselected tab text color
                  onTap: (index) {
                    // Handle tab selection by updating the current index
                    setState(() {});
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Divider(
                  height: 0,
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.h, right: 40.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RateTypeHeader(
                  image: ImageManager.kSellingArrow,
                  title: 'Selling',
                ),
                SizedBox(width: 50.w),
                RateTypeHeader(
                  image: ImageManager.kBuyingArrow,
                  title: 'Buying',
                )
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView.separated(
                  controller: widget.scrollController,
                  itemCount: 30,
                  itemBuilder: (BuildContext context, int index) {
                    return RateItem();
                  },
                  separatorBuilder: ((context, index) => Divider(
                        height: 0,
                      )),
                ),
                ListView.separated(
                  controller: widget.scrollController,
                  itemCount: 30,
                  itemBuilder: (BuildContext context, int index) {
                    return RateItem();
                  },
                  separatorBuilder: ((context, index) => Divider(
                        height: 0,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
