import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tood_driver_new/models/new_order_model.dart';
import 'package:tood_driver_new/models/order_details.dart';
import 'package:tood_driver_new/servise/api_order.dart';

class OrderDetailsProvider extends ChangeNotifier {
  OrderDetailsProvider(NewOrder order) {
    getOrderDetails(order.id);
  }
  OrderDetailsModel order = new OrderDetailsModel();

  String? lang;
  update() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lang = prefs.getString("lang")!;
    notifyListeners();
  }

  void getOrderDetails(int? id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiOrder.instance.getOrderDetails(id).then((newOrder) {
      order = newOrder!;
      notifyListeners();
    });
  }
}
