import 'package:flutter/material.dart';
import 'package:tood_driver_new/models/slider_model.dart';
import 'package:tood_driver_new/servise/api_slidert.dart';

class SliderProvider extends ChangeNotifier {
  SliderProvider() {
    getSlider();
  }
  SliderModel slider = new SliderModel();

  void getSlider() {
    ApiSlider.instance.getSlider().then((slide) {
      slider = slide!;
      notifyListeners();
    });
  }
}
