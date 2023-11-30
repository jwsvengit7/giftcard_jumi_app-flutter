import 'package:flutter/material.dart';
import '../helpers/user_helper.dart';
import '../model/saved_bank.dart';
import '../model/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  User? get user => _user;
  void updateUserCred(User? el) {
    _user = el;
    notifyListeners();
  }

  Future<void> updateProfileInformation() async {
    try {
      User res = await UserHelper.getProfileInformation();
      _user = res;
      notifyListeners();
    } catch (e) {
      debugPrint("An error occured ::$e");
    }
  }

  // Saved Banks
  List<SavedBank> _savedBanks = [];
  List<SavedBank> get savedBanks => _savedBanks;
  Future<void> updateAddedBanks() async {
    await UserHelper.getSavedBanks().then((value) {
      _savedBanks = value;
      notifyListeners();
    }).catchError((e) {
      debugPrint("error $e");
      // recordError();
    });
  }

  // Notification
  bool _unreadNotificationAvailable = false;
  bool get unreadNotificationAvailable => _unreadNotificationAvailable;
  Future<void> checkUnreadNotification() async {
    String query = "?per_page=10&page=1&filter[read]=0";
    await UserHelper.getNotifications(query).then((value) {
      if (value.isNotEmpty) {
        _unreadNotificationAvailable = true;
      } else {
        _unreadNotificationAvailable = false;
      }
      notifyListeners();
    }).catchError((e) {
      debugPrint("error $e");
    });
  }
}
