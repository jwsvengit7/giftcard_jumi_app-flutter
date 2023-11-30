// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jimmy_exchange/core/helpers/generic_helper.dart';
import 'package:jimmy_exchange/core/model/user.dart';
import 'package:jimmy_exchange/core/providers/user_provider.dart';
import 'package:jimmy_exchange/core/utils/utils.dart';
import 'package:jimmy_exchange/presentation/resources/image_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../core/services/secure_storage.dart';
import '../resources/color_manager.dart';
import '../resources/routes_manager.dart';
import '../widgets/custom_scaffold.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAuth();
    });
    super.initState();
  }

  Future<void> checkAuth() async {
    var platform = "";

    if (Platform.isAndroid) {
      platform = "ANDVU";
    } else if (Platform.isIOS) {
      platform = "IOSVU";
    }

    String? updateVersion =
        await GenericHelper.getCurrentAppVersion(platform: platform)
            .catchError((_) => null);

    if (updateVersion != null) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      if (!isLatestVersion(packageInfo.version, updateVersion)) {
        await Navigator.pushNamed(context, RoutesManager.appUpdateView);
      }
    }

    var authCred = await SecureStorage.getInstance()
        .then((pref) => pref.getString("authCred"))
        .catchError((_) => null);

    if (authCred == null) {
      //  Navigator.popAndPushNamed(context, RoutesManager.introRoute);
      Navigator.popAndPushNamed(context, RoutesManager.loginRoute);
    } else {
      User user = User.fromMap(json.decode(authCred)['user']);
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      userProvider.updateUserCred(user);
      Navigator.popAndPushNamed(context, RoutesManager.loginRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Color.fromRGBO(242, 247, 255, 1),
      body: Center(
        child: Image.asset(ImageManager.kLogoWhite, width: 120),
      ),
    );
  }
}
