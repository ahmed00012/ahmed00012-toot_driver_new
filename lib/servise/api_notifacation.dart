import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:tood_driver_new/models/notification_model.dart';
import 'package:tood_driver_new/models/user_model.dart';
import 'package:tood_driver_new/servise/vars.dart';

class ApiNotification {
  ApiNotification._();

  static final ApiNotification instance = ApiNotification._();
  static NotificationModel? notificationModel;

  var dio = Dio()
    ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ));

  //
  static Map<String, String> apiHeaders = {
    "Content-Type": "application/json",
    "X-Requested-With": "XMLHttpRequest",
    "Content-Language": "ar",
  };

  Future<NotificationModel?> getNotification(int page) async {
    // Json Data
    String token = await _getUserToken();
    var _response =
        await dio.get("https://toot.work/api/driver/notifications?page=$page",
            options: Options(
              headers: {
                ...apiHeaders,
                'Authorization': '$token',
              },
              validateStatus: (status) {
                return status! < 500;
              },
            ));

    print("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
    print("${_response.data}");

    if (ServerConstants.isValidResponse(_response.statusCode!)) {
      // OK
      // if (!ServerConstants.isValidResponse(
      //     int.parse(_response.data[0]))) {
      //   throw ApiException.fromApi(_response.statusCode!, _response.data);
      // }

      notificationModel = NotificationModel.fromJson(_response.data);
      return notificationModel;
      //  return UserModel.fromJson(_response.body);
    } else {
      // DioErrorType type;
      // No Success
      print(
          'ApiException....not***********************************************************');

      // print(_response.request.uri.data);
      print('...................................................');

      //throw ApiException.fromApi(_response.statusCode!, _response.data);
    }
  }
}

Future<String> _getUserToken() async {
  print('_getUserToken()');
  UserModel user = UserModel();
  print('UserModel');
  String? userToken = await user.getToken;
  print(userToken);
  if (userToken == null) throw "User Not Logged In";
  return userToken;
}
