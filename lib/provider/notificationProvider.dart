import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tood_driver_new/models/notification_model.dart';
import 'package:tood_driver_new/servise/api_notifacation.dart';
import 'package:tood_driver_new/servise/api_order.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationProvider() {
    getNotification();
  }
  NotificationModel notification = new NotificationModel();
  int page = 1;
  RefreshController controller = RefreshController();

  void getNotification() {
    ApiNotification.instance
      ..getNotification(1).then((newNoti) {
        notification = newNoti!;
        notifyListeners();
      });
  }

  void onRefresh() {
    page++;
    ApiNotification.instance
      ..getNotification(page).then((newNoti) {
        NotificationModel? notification2 = newNoti!;
        notification.notifications!.data
            .addAll(notification2.notifications?.data ?? []);
        notification2 = null;
        controller.loadComplete();
        notifyListeners();
      });
  }

  void refuseOrder(int? id, String? notes) {
    ApiOrder.instance.refuseOrder(id, notes);
    notifyListeners();
  }
}
