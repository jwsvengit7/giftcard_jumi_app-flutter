import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:jimmy_exchange/core/providers/index.dart';
import 'package:provider/provider.dart';

import '../presentation/resources/routes_manager.dart';
import '../presentation/resources/theme_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyApp extends StatefulWidget {
  static void restartApp(BuildContext context) {
    try {
      context.findAncestorStateOfType<_MyAppState>()?.restartApp();
    } catch (e) {
      // manualReportCrash(error: e);
    }
  }

  MyApp._internal(); // private named constructor
  int appState = 0;
  static final MyApp instance =
      MyApp._internal(); // single instance -- singleton

  factory MyApp() => instance; // factory for the class instance

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key _key = UniqueKey();

  void restartApp() {
    if (mounted) setState(() => _key = UniqueKey());
  }

  @override
  void initState() {
    if (Platform.isAndroid && !kDebugMode) {
      InAppUpdate.checkForUpdate().then((value) {
        if (value.updateAvailability != UpdateAvailability.updateAvailable) {
          return;
        }
        InAppUpdate.performImmediateUpdate();
      }).catchError((_) {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      key: _key,
      providers: ProviderIndex.multiProviders(),
      child: ScreenUtilInit(
        designSize: const Size(428, 926),
        minTextAdapt: true,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: RouteGenerator.getRoute,
          initialRoute: RoutesManager.splashRoute,
          theme: getApplicationTheme(),
        ),
      ),
    );
  }
}
