import 'package:flutter/material.dart';
import 'package:tood_driver_new/models/distance_model.dart';
import 'package:tood_driver_new/models/new_order_model.dart';
import 'package:tood_driver_new/servise/api_distance.dart';

class DistanceProvider extends ChangeNotifier {
  DistanceProvider(NewOrder order) {
    order.cart?.address != null
        ? getDistance(order.cart!.vendor?.lat, order.cart!.vendor?.long,
            order.cart?.address?.lat ?? "0", order.cart?.address?.lng ?? "0")
        : getDistance(
            order.cart!.vendor?.lat, order.cart!.vendor?.long, "0", "0");
  }
  DistanceModel distance = new DistanceModel();

  void getDistance(String? lat1, String? lng1, String? lat2, String? lng2) {
    ApiDistance.instance
        .getDistance(lat1, lng1, lat2, lng2, "client")
        .then((newOrder) {
      distance = newOrder!;
      notifyListeners();
    });
  }
}
