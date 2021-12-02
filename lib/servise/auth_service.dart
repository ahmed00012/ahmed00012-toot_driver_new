import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:tood_driver_new/models/change_status.dart';
import 'package:tood_driver_new/models/user_model.dart';
import 'package:tood_driver_new/servise/vars.dart';

import 'api_exceptions.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();
  static UserModel? user;
  static StatusModel? status;

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

  Future<UserModel?> login(
      String phone, String password, String deviceId) async {
    print(deviceId + 'kjbfvfkhb v');
    // Json Data
    // var _data = {
    //   "phone": "$phone",
    //   "password": "$password",
    //   "device_id": "$deviceId"
    // };
    print('login start');
    // Http Request

    var _response = await dio.post(ServerConstants.Login,
        data: {
          "phone": "$phone",
          "password": "$password",
          "device_id": "$deviceId"
        },
        options: Options(
          headers: {
            "Content-Language": 'ar',
          },
        ));

    print("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
    log("${_response.data}");

    if (ServerConstants.isValidResponse(_response.statusCode!)) {
      user = UserModel.fromJson(_response.data);
      return user;
    } else {
      throw ApiException.fromApi(_response.statusCode!, _response.data);
    }
  }

  Future<void> logOut() async {
    // Json Data
    String token = await _getUserToken();
    var _response = await dio.post(ServerConstants.Logout,
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
      //  print(user!.accessToken);
      //   user!.saveToken(user!.accessToken);
      //    SharedPreferences prefs = await SharedPreferences.getInstance();
      //    prefs?.setBool("isLoggedIn", true);
      // user = UserModel.fromJson(_response.data);
      // return user;

      //  return UserModel.fromJson(_response.body);
    } else {
      // DioErrorType type;
      // No Success
      print(
          'ApiException....login***********************************************************');

      // print(_response.request.uri.data);
      print('...................................................');

      throw ApiException.fromApi(_response.statusCode!, _response.data);
    }
  }

  Future<void> changePass(String oldPassword, String newPassword) async {
    // Json Data
    var _data = {
      "old_password": "$oldPassword",
      "new_password": "$newPassword",
    };
    // Json Data
    String token = await _getUserToken();
    var _response = await dio.post(ServerConstants.ChangePass,
        data: _data,
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
      //  print(user!.accessToken);
      //   user!.saveToken(user!.accessToken);
      //    SharedPreferences prefs = await SharedPreferences.getInstance();
      //    prefs?.setBool("isLoggedIn", true);
      // user = UserModel.fromJson(_response.data);
      // return user;

      //  return UserModel.fromJson(_response.body);
    } else {
      // DioErrorType type;
      // No Success
      print(
          'ApiException....login***********************************************************');

      // print(_response.request.uri.data);
      print('...................................................');

      throw ApiException.fromApi(_response.statusCode!, _response.data);
    }
  }

  Future<StatusModel?> changeStatus() async {
    // Http Request
    String token = await _getUserToken();
    var _response = await dio.get("https://toot.work/api/driver/change_status",
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
      status = StatusModel.fromJson(_response.data);
      return status;
    } else {
      // DioErrorType type;
      // No Success
      print(
          'ApiException....status***********************************************************');

      // print(_response.request.uri.data);
      print('...................................................');

      throw ApiException.fromApi(_response.statusCode!, _response.data);
    }
  }
}

Future<String> _getUserToken() async {
  print('_getUserToken()');
  UserModel user = UserModel();
  print('UserModel');
  //print(AuthService.user!.accessToken);

  String? userToken = await user.getToken;
  print(userToken);
  if (userToken == null) throw "User Not Logged In";
  return userToken;
}
