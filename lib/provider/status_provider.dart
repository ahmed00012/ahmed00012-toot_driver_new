import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tood_driver_new/models/change_status.dart';
import 'package:tood_driver_new/servise/auth_service.dart';

class StatusProvider extends ChangeNotifier {
  StatusProvider() {
    changeStatus1();
  }
  StatusModel status = new StatusModel();
  SharedPreferences? prefs;
  String? statuss;

  Future<void> changeStatus1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    statuss = prefs.getString('status');
    print(status);
    notifyListeners();
  }

  void changeStatus() async {
    await AuthService.instance.changeStatus().then((newOrder) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      status = newOrder!;
      if (statuss == "0") {
        prefs.setString("status", "1");
        statuss = "1";
      } else {
        prefs.setString("status", "0");
        statuss = "0";
      }
      ////  SharedPreferences.Editor prefsEditr = mypref.edit();
      //   prefsEditr.putString("Userid", UserId);
      notifyListeners();
    });
  }

  _toastInfo(String info) {
    Fluttertoast.showToast(
        msg: info,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.green);
  }
}
