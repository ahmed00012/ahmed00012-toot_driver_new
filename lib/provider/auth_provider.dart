import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:tood_driver_new/models/change_status.dart';
import 'package:tood_driver_new/models/user_model.dart';
import 'package:tood_driver_new/servise/auth_service.dart';

class AuthProvider with ChangeNotifier {
  //AuthService _api = ApiProvider.instance;
  UserModel? userModel;
  StatusModel status = new StatusModel();
  String lang = "en";

  Future<void> login(
    String phone,
    String password,
    String deviceId,
  ) async {
    print(deviceId);
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // lang = prefs.getString("lang") ?? "en";
    userModel = await AuthService.instance.login(phone, password, deviceId);

    // getProfile();
    notifyListeners();
  }

  Future<void> changePass(
    String oldPassword,
    String newPassword,
  ) async {
    await AuthService.instance.changePass(oldPassword, newPassword);
    notifyListeners();
  }

  Future<void> changeStatus() async {
    await AuthService.instance.changeStatus().then((newOrder) {
      status = newOrder!;
      notifyListeners();
    });
  }

  Future<void> logout() async {
    await AuthService.instance.logOut();
    // await userModel?.resetUser();
    userModel = null;
//    _timer?.cancel();

    notifyListeners();
  }

  // Future<void> accept(
  //     int orderId,
  //     ) async {
  //   await ApiOrder.instance.accept(orderId);
  //   // getProfile();
  //   notifyListeners();
  // }

//   Future<void> logout() async {
//     await userModel?.resetUser();
//     userModel = null;
// //    _timer?.cancel();
//
//     notifyListeners();
//   }
}
