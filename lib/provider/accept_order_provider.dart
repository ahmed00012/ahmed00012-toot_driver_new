import 'package:flutter/material.dart';
import 'package:tood_driver_new/models/new_order_model.dart';
import 'package:tood_driver_new/servise/api_order.dart';

class AcceptOrderProvider extends ChangeNotifier {
  AcceptOrderProvider() {
    // acceptOrder(order.id);
  }
  NewOrdersModel order = new NewOrdersModel();

  void acceptOrder(int? id) {
    ApiOrder.instance
      ..acceptOrder(id).then((newOrder) {
        order = newOrder!;
        notifyListeners();
      });
  }

// void addToFav(Movie movie){
//   movie.isfav = !movie.isfav;
//   notifyListeners();
// }
//
// void removeMovie (Movie movie){
//   movies.remove(movie);
//
//   notifyListeners();
// }
}
