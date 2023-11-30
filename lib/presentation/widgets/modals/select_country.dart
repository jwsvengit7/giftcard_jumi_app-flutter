import 'package:flutter/material.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_btn.dart';
import 'package:provider/provider.dart';

import '../../../core/model/country.dart';
import '../../../core/providers/generic_provider.dart';
import '../../resources/values_manager.dart';
import '../custom_input_field.dart';
import '../no_content.dart';
import '../shimmers/square_shimmer.dart';

class SelectCountry extends StatefulWidget {
  const SelectCountry({Key? key}) : super(key: key);

  @override
  State<SelectCountry> createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {
  bool fetchingBanks = false;
  TextEditingController searchController = TextEditingController();
  List<Country> filteredCountries = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      GenericProvider genericProvider =
          Provider.of<GenericProvider>(context, listen: false);
      print(genericProvider.updateCountries());
      if (genericProvider.countries.isEmpty) {
        if (mounted) setState(() => fetchingBanks = true);
        await genericProvider
            .updateCountries()
            .then((data) {})
            .catchError((error) {});
        if (mounted) setState(() => fetchingBanks = false);
      }
    });
    super.initState();
  }

  void startSearch(String arg, List<Country> lst) {
    try {
      filteredCountries = lst
          .where((el) =>
              (el.name?.toLowerCase() ?? "").contains(arg.toLowerCase()))
          .toList();
    } catch (e) {
      searchController.text = "";
      filteredCountries = [];
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    GenericProvider genericProvider =
        Provider.of<GenericProvider>(context, listen: false);

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
                            width: 16,
                            height: 16),
                      ),
                    ),
                    Text('Select Country',
                        style: get16TextStyle()
                            .copyWith(fontWeight: FontWeight.w400))
                  ],
                )),
            CustomInputField(
              hintText: "Search",
              textEditingController: searchController,
              onChanged: (e) => startSearch(e, genericProvider.countries),
              decoration: getSearchInputDecoration(),
            ),
            Expanded(
              child: fetchingBanks
                  ? ListView.separated(
                      padding: const EdgeInsets.only(top: 27),
                      separatorBuilder: ((context, index) =>
                          const SizedBox(height: 20)),
                      itemCount: 5,
                      itemBuilder: (_, int i) => const SquareShimmer(
                          width: double.infinity, height: 50),
                    )
                  : genericProvider.countries.isEmpty
                      ? NoContent(
                          desc:
                              "An error occured while fetching country list, please contact support if this issue persist.",
                          btn: CustomBtn(
                              isActive: true,
                              loading: false,
                              width: 120,
                              padding: const EdgeInsets.symmetric(
                                  vertical: AppPadding.p14),
                              onTap: () async {
                                if (mounted) {
                                  setState(() => fetchingBanks = true);
                                }
                                await genericProvider
                                    .updateCountries()
                                    .then((_) {})
                                    .catchError((_) {});
                                if (mounted) {
                                  setState(() => fetchingBanks = false);
                                }
                              },
                              text: "Refresh"),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(top: 27),
                          addAutomaticKeepAlives: false,
                          shrinkWrap: true,
                          itemCount: searchController.text.isNotEmpty
                              ? filteredCountries.length
                              : genericProvider.countries.length,
                          itemBuilder: (_, int i) {
                            Country item = searchController.text.isNotEmpty
                                ? filteredCountries[i]
                                : genericProvider.countries[i];
                            return GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => Navigator.pop(context, item),
                              child: Container(
                                  margin: const EdgeInsets.only(bottom: 4),
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color(0xffF0F0F0))),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.network(
                                        item.flagUrl ??
                                            ImageManager.kSupportIcon,
                                        width: 25,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          item.name ?? "",
                                          overflow: TextOverflow.ellipsis,
                                          style: get16TextStyle().copyWith(
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            );
                          },
                          separatorBuilder: (_, i) =>
                              const SizedBox(height: 10),
                        ),
            )
          ],
        ),
      ),
    );
  }
}
