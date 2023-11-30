import 'package:flutter/material.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_appbar.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_scaffold.dart';
import 'package:provider/provider.dart';

import '../../core/providers/generic_provider.dart';
import '../resources/color_manager.dart';
import '../resources/styles_manager.dart';
import '../widgets/tiles/banner_tiles.dart';

class BannerView extends StatefulWidget {
  const BannerView({super.key});

  @override
  State<BannerView> createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await updateBanners();
    });

    super.initState();
  }

  Future<void> updateBanners() async {
    try {
      GenericProvider genericProvider =
          Provider.of<GenericProvider>(context, listen: false);
      genericProvider.updateBanners();
    } catch (_) {}
  }

  //
  @override
  Widget build(BuildContext context) {
    GenericProvider genericProvider = Provider.of<GenericProvider>(context);
    Size size = MediaQuery.of(context).size;

    return CustomScaffold(
      appBar: CustomAppBar(
        elevation: 0,
        scrolledUnderElevation: 1.4,
        backgroundColor: ColorManager.kBackground,
        title: Text("Banners", style: get20TextStyle()),
      ),
      backgroundColor: ColorManager.kBackground,
      body: RefreshIndicator(
        onRefresh: updateBanners,
        color: ColorManager.kPrimaryBlack,
        child: ListView.separated(
          padding: const EdgeInsets.only(top: 21, left: 16, right: 16),
          // controller: scrollController,
          itemCount: genericProvider.banners.length,
          itemBuilder: (ctx, index) {
            return BannerTiles(banners: genericProvider.banners[index]);
          },
          separatorBuilder: (ctx, index) => SizedBox(height: 24),
        ),
      ),
    );
  }
}
