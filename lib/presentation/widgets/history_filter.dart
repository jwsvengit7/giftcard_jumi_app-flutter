import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:jimmy_exchange/core/constants.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/resources/color_manager.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:jimmy_exchange/presentation/resources/styles_manager.dart';
import 'package:jimmy_exchange/presentation/widgets/custom_input_field.dart';
import '../../core/enum.dart';

class HistoryFilter extends StatefulWidget {
  const HistoryFilter({Key? key, this.displayTypeFilter = false})
      : super(key: key);
  final bool? displayTypeFilter;

  @override
  State<HistoryFilter> createState() => _HistoryFilterState();
}

class _HistoryFilterState<T> extends State<HistoryFilter> {
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  final TextEditingController fromAmountController = TextEditingController();
  final TextEditingController toAmountController = TextEditingController();

  late DateTimeRange dateRange = DateTimeRange(
    start: DateTime(initialDate.year, initialDate.month, initialDate.day - 31),
    end: DateTime(initialDate.year, initialDate.month, initialDate.day),
  );
  DateTime initialDate = DateTime.now();

  String? transactionFilterSelected;
  String? typeFilterSelected;
  String? statusFilterSelected;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          color: ColorManager.kWhite,
          height: 770.h,
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.only(left: 17, right: 17, top: 17),
            children: [
              Row(
                children: [
                  Expanded(child: SizedBox()),
                  Container(
                    width: 78.w,
                    height: 1.h,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: ColorManager.kBorder, width: 3.w)),
                  ),
                  Expanded(child: SizedBox()),
                ],
              ),
              buildSpacer(),
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Filters',
                  style: get18TextStyle().copyWith(
                      fontWeight: FontWeight.w800,
                      color: ColorManager.kBlack,
                      fontSize: 18.sp),
                ),
              ),
              buildSpacer(),
              FilterOptionHeader(
                title: 'Transactions',
              ),
              SizedBox(height: 15.h),
              FilterByTransaction(onTap: (transaction) {
                transactionFilterSelected = transaction;
              }),
              buildSpacer(),
              FilterOptionHeader(
                title: 'Type',
              ),
              SizedBox(height: 15.h),
              FilterByType(onTap: (Type) {
                typeFilterSelected = Type;
              }),
              buildSpacer(),
              FilterOptionHeader(
                title: 'Status',
              ),
              SizedBox(height: 15.h),
              FilterByStatus(onTap: (Status) {
                statusFilterSelected = Status;
              }),
              buildSpacer(),
              FilterOptionHeader(
                title: 'Time Frame',
              ),
              SizedBox(height: 15.h),
              Container(
                height: 58,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: ColorManager.kWhite,
                    border: Border.all(color: ColorManager.kGray12)),
                child: BuildDateRangePicker(
                  onTap: () => pickDateRange(),
                  value:
                      '${formatDateRange(dateRange.start)} - ${formatDateRange(dateRange.end)}',
                ),
              ),
              buildSpacer(),
              FilterOptionHeader(
                title: 'Amount Range (In Naira)',
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  Expanded(
                    child: CustomInputField(
                      textEditingController: fromAmountController,
                      hintText: 'From',
                      textInputType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "->",
                      style: get12TextStyle().copyWith(
                        color: ColorManager.kBlack2,
                      ),
                    ),
                  ),
                  Expanded(
                    child: CustomInputField(
                      textEditingController: toAmountController,
                      hintText: 'To',
                      textInputType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              BuildApplyButton(onTap: () {
                Navigator.pop(context, generateQuery());
              }),
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom > 0 ? 400 : 50,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSpacer() => SizedBox(height: 35.h);

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );
    dateRange = newDateRange ?? dateRange;
    if (newDateRange == null) return;
    dateRange = newDateRange;
    setState(() {});
  }

  //THE NEW API MIST BE PROVIDED TO PROVERLY COMPOSE THE FUNCTION
  // ////// /
  // //
  // //
  String? generateQuery() {
    String? param;

    /// Date Range
    String from = DateFormat("yyyy-MM-dd").format(dateRange.start);
    String to = DateFormat("yyyy-MM-dd").format(dateRange.end);
    param = "filter[creation_date]=$from,$to";

    /// Amount Range
    if (toAmountController.text.isNotEmpty &&
        fromAmountController.text.isNotEmpty) {
      String q1 =
          "filter[payable_amount]=${fromAmountController.text},${toAmountController.text}";
      param = "$param&$q1";
    }

    ///NOTE::: TYPE MUST ALWAYS BE LAST FILTER ADDED
    if (transactionFilterSelected != null &&
        typeFilterSelected != null &&
        statusFilterSelected != null) {
      String q1 = "filter[type]=${transactionFilterSelected}";
      String q2 = "filter[type]=${typeFilterSelected}";
      String q3 = "filter[type]=${statusFilterSelected}";
      param = "$param&$q1";
    }

    return param;
  }

  String calculateDateTime(int days) {
    DateTime dateTime = DateTime.now().subtract(Duration(days: days));
    String date = DateFormat("d MMM y").format(dateTime);

    return "(from $date to now)";
  }

  String formatDateRange(DateTime dateTime) {
    return DateFormat("d MMM y").format(dateTime);
  }
}

class FilterByStatus extends StatefulWidget {
  final Function(String) onTap;

  const FilterByStatus({super.key, required this.onTap});

  @override
  State<FilterByStatus> createState() => _FilterByStatusState();
}

class _FilterByStatusState extends State<FilterByStatus> {
  Status status = Status.All;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BuildFilterOptionsButton(
          onTap: () {
            widget.onTap(Constants.kAllStatus);
            status = Status.All;
            setState(() {});
          },
          isActive: status == Status.All ? true : false,
          title: 'All',
        ),
        BuildFilterOptionsButton(
          onTap: () {
            widget.onTap(Constants.kSuccessStatus);
            status = Status.Success;
            setState(() {});
          },
          isActive: status == Status.Success ? true : false,
          title: 'Success',
        ),
        BuildFilterOptionsButton(
          onTap: () {
            widget.onTap(Constants.kFailedStatus);
            status = Status.Failed;
            setState(() {});
          },
          isActive: status == Status.Failed ? true : false,
          title: 'Failed',
        ),
      ],
    );
  }
}

class FilterByType extends StatefulWidget {
  final Function(String) onTap;

  const FilterByType({super.key, required this.onTap});

  @override
  State<FilterByType> createState() => _FilterByTypeState();
}

class _FilterByTypeState extends State<FilterByType> {
  Type type = Type.All;

  @required
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BuildFilterOptionsButton(
          onTap: () {
            widget.onTap(Constants.kAllType);
            type = Type.All;
            setState(() {});
          },
          isActive: type == Type.All ? true : false,
          title: 'All',
        ),
        BuildFilterOptionsButton(
          onTap: () {
            widget.onTap(Constants.kBuyType);
            type = Type.Buy;
            setState(() {});
          },
          isActive: type == Type.Buy ? true : false,
          title: 'Buy',
        ),
        BuildFilterOptionsButton(
          onTap: () {
            widget.onTap(Constants.kSellType);
            type = Type.Sell;
            setState(() {});
          },
          isActive: type == Type.Sell ? true : false,
          title: 'Sell',
        ),
      ],
    );
  }
}

class FilterByTransaction extends StatefulWidget {
  final Function(String) onTap;

  FilterByTransaction({super.key, required this.onTap});

  @override
  State<FilterByTransaction> createState() => _FilterByTransactionState();
}

class _FilterByTransactionState extends State<FilterByTransaction> {
  Transactions transactions = Transactions.All;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BuildFilterOptionsButton(
          onTap: () {
            transactions = Transactions.All;
            widget.onTap(Constants.kAllTransaction);
            setState(() {});
          },
          isActive: transactions == Transactions.All ? true : false,
          isTransaction: true,
          title: 'All',
        ),
        BuildFilterOptionsButton(
          onTap: () {
            transactions = Transactions.GiftCard;
            widget.onTap(Constants.kGiftCardTransaction);
            setState(() {});
          },
          isActive: transactions == Transactions.GiftCard ? true : false,
          isTransaction: true,
          title: 'GiftCard',
        ),
        BuildFilterOptionsButton(
          onTap: () {
            transactions = Transactions.Crypto;
            widget.onTap(Constants.kCryptoTransaction);
            setState(() {});
          },
          isActive: transactions == Transactions.Crypto ? true : false,
          isTransaction: true,
          title: 'Crypto',
        ),
        BuildFilterOptionsButton(
          onTap: () {
            transactions = Transactions.Wallet;
            widget.onTap(Constants.kWalletTransaction);
            setState(() {});
          },
          isActive: transactions == Transactions.Wallet ? true : false,
          isTransaction: true,
          title: 'Wallet',
        )
      ],
    );
  }
}

class BuildFilterOptionsButton extends StatelessWidget {
  const BuildFilterOptionsButton(
      {super.key,
      required this.onTap,
      required this.title,
      required this.isActive,
      this.isTransaction = false});

  final Function()? onTap;
  final String title;
  final bool isActive;
  final bool isTransaction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap ?? () {},
      child: Container(
          alignment: Alignment.center,
          height: 50.h,
          width: isTransaction ? 92.w : 125.w,
          // horizontal: 86.w,
          decoration: BoxDecoration(
              color: isActive == true
                  ? ColorManager.kActiveButton
                  : ColorManager.kWhite,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(
                color: isActive == true
                    ? ColorManager.kGray3
                    : ColorManager.kActiveBorder,
              )),
          child: Text(
            title,
            style: get16TextStyle().copyWith(
                color: ColorManager.kPrimaryBlue,
                fontWeight: FontWeight.w600,
                fontSize: 16.sp),
          )),
    );
  }
}

class BuildApplyButton extends StatelessWidget {
  const BuildApplyButton({
    super.key,
    required this.onTap,
  });

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 149.w,
        height: 51.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorManager.kPrimaryBlue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Apply',
          style: get16TextStyle().copyWith(
            fontWeight: FontWeight.w500,
            color: ColorManager.kWhite,
          ),
        ),
      ),
    );
  }
}

class BuildDateRangePicker extends StatelessWidget {
  const BuildDateRangePicker(
      {super.key, required this.onTap, required this.value});

  final Function onTap;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap(),
      child: Container(
        width: 149.w,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: get16TextStyle().copyWith(
                fontWeight: FontWeight.w400,
                color: ColorManager.kGray7,
              ),
            ),
            Image.asset(ImageManager.kDatePicker, width: 20, height: 20),
          ],
        ),
      ),
    );
  }
}

class FilterOptionHeader extends StatelessWidget {
  const FilterOptionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: get16TextStyle()
          .copyWith(fontWeight: FontWeight.w400, color: ColorManager.kGray1),
    );
  }
}

class HistoryFilterCard extends StatelessWidget {
  final String filterQueryParam;
  final Function onClear;

  const HistoryFilterCard(
      {super.key, required this.filterQueryParam, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return buildHistoryFilterCard(filterQueryParam, onClear);
  }

  Widget buildCover({required Widget child}) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 8, right: 25),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
      decoration: BoxDecoration(
        color: ColorManager.kFilterBg,
        borderRadius: BorderRadius.circular(50),
      ),
      child: child,
    );
  }

  Widget buildHistoryFilterCard(String filterQueryParam, Function onClear) {
    if (filterQueryParam.contains("creation_date")) {
      //
      String val = filterQueryParam
          .split("filter[creation_date]")
          .last
          .replaceAll("=", "");

      String from =
          DateFormat("d MMM y").format(DateTime.parse(val.split(",").first));
      String to =
          DateFormat("d MMM y").format(DateTime.parse(val.split(",").last));

      return buildCover(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              ImageManager.kDatePicker,
              width: 14,
              height: 14,
              color: ColorManager.kBlack,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                "$from - $to",
                style: get12TextStyle().copyWith(
                  fontWeight: FontWeight.w500,
                  color: ColorManager.kSecBlue,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => onClear(filterQueryParam),
              behavior: HitTestBehavior.translucent,
              child: Image.asset(ImageManager.kStar, width: 10),
            )
          ],
        ),
      );

      //
    }

    if (filterQueryParam.contains("payable_amount")) {
      String val = filterQueryParam
          .split("filter[payable_amount]")
          .last
          .replaceAll("=", "");

      String from = val.split(",").first;
      String to = val.split(",").last;

      //
      return buildCover(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(ImageManager.kAmountRange,
                width: 14, height: 14, color: ColorManager.kBlack),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                "$from - $to",
                style: get12TextStyle().copyWith(
                  fontWeight: FontWeight.w500,
                  color: ColorManager.kSecBlue,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => onClear(filterQueryParam),
              behavior: HitTestBehavior.translucent,
              child: Image.asset(ImageManager.kStar, width: 10),
            )
          ],
        ),
      );
    }

    if (filterQueryParam.contains("type")) {
      String val =
          filterQueryParam.split("filter[type]").last.replaceAll("=", "");
      return buildCover(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(ImageManager.kAmountRange,
                width: 14, height: 14, color: ColorManager.kBlack),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                capitalizeFirstString(val),
                style: get12TextStyle().copyWith(
                  fontWeight: FontWeight.w500,
                  color: ColorManager.kSecBlue,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => onClear(filterQueryParam),
              behavior: HitTestBehavior.translucent,
              child: Image.asset(ImageManager.kStar, width: 10),
            )
          ],
        ),
      );

      //
    }

    if (filterQueryParam.contains("paid")) {
      String val =
          filterQueryParam.split("filter[paid]").last.replaceAll("=", "");
      return buildCover(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(ImageManager.kAmountRange,
                width: 14, height: 14, color: ColorManager.kBlack),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                capitalizeFirstString(val == "True" ? "Completed" : "Pending"),
                style: get12TextStyle().copyWith(
                  fontWeight: FontWeight.w500,
                  color: ColorManager.kSecBlue,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => onClear(filterQueryParam),
              behavior: HitTestBehavior.translucent,
              child: Image.asset(ImageManager.kStar, width: 10),
            )
          ],
        ),
      );
    }
    return const SizedBox();
  }
}
