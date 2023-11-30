import 'package:jimmy_exchange/core/providers/txn_history_provider.dart';
import 'package:jimmy_exchange/core/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../core/providers/generic_provider.dart';
import 'referral_provider.dart';

class ProviderIndex {
  static List<SingleChildWidget> multiProviders() {
    return [
      ChangeNotifierProvider(create: (_) => GenericProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => TxnHistoryProvider()),
      ChangeNotifierProvider(create: (_) => ReferralProvider()),
    ];
  }
}
