import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverDataProvider extends ChangeNotifier {
  DriverDataProvider() {
    getData();
  }
  String? fName;
  String? lName;
  String? vNameEn;
  String? vNameAr;
  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    fName = prefs.getString('fName');
    lName = prefs.getString('lName');
    vNameEn = prefs.getString('vendor_name_en');
    vNameAr = prefs.getString('vendor_name_ar');
    notifyListeners();
  }
}
