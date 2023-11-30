import 'package:flutter/material.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';

import '../../../core/model/country.dart';
import '../../resources/values_manager.dart';
import '../no_content.dart';

class SelectGiftcardCountry extends StatelessWidget {
  final Country? current;
  final List<Country> availableCountries;
  const SelectGiftcardCountry(
      {Key? key, this.current, required this.availableCountries})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Expanded(
            child: availableCountries.isEmpty
                ? const NoContent(
                    desc:
                        "An error occured while fetching gitcard country list, please contact support if this issue persist.",
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(top: 27),
                    addAutomaticKeepAlives: false,
                    shrinkWrap: true,
                    itemCount: availableCountries.length,
                    itemBuilder: (_, int i) {
                      Country item = availableCountries[i];
                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => Navigator.pop(context, item),
                        child: Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Color(0xffF0F0F0))),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.network(
                                  item.flagUrl ?? ImageManager.kSupportIcon,
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
                    separatorBuilder: (_, i) => const SizedBox(height: 10),
                  ),
          )
        ],
      ),
    );
  }
}
