import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
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

  Future login(String phone, String password, String deviceId) async {
    var response = await http
        .post(Uri.parse("https://toot.work/api/auth/driverlogin"), body: {
      "phone": "$phone",
      "password": "$password",
      "device_id": "$deviceId"
    }, headers: {
      "Content-Language": 'ar',
    });
    return json.decode(response.body);

    // print(deviceId + 'kkkkkkkkkk');
    // try {
    //   var response = await Dio().post(
    //     "https://toot.work/api/auth/driverlogin",
    //     data: {
    //       "phone": "$phone",
    //       "password": "$password",
    //       "device_id": "$deviceId"
    //     },
    //     options: Options(
    //       headers: {
    //         "Content-Language": 'ar',
    //       },
    //     ),
    //   );
    //   print('zzzzzz');
    //   print(response.statusCode.toString() + 'hghhhhhh');
    //   return response.data;
    // } catch (e) {
    //   final errorMessage = DioExceptions.fromDioError(e as DioError).toString();
    //   print(errorMessage);
    //   return errorMessage;
    // }
    //     .catchError((error) {
    //   final errorMessage = DioExceptions.fromDioError(e).toString();
    //   // return dioError!.message;
    // });
    // if (DioErrorType.response) print(DioErrorType.response);

    // log("${response.data}");

    // if (response.statusCode == 200) {
    //   user = UserModel.fromJson(response.data);
    // }
    // else {
    //   throw ApiException.fromApi(response.statusCode!, response.data);
    // }
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

// class DioExceptions implements Exception {
//   String? message;
//   DioExceptions.fromDioError(DioError dioError) {
//     switch (dioError.type) {
//       case DioErrorType.cancel:
//         message = "Request to API server was cancelled";
//         break;
//       case DioErrorType.response:
//         message = _handleError(401, dioError.response);
//         break;
//       default:
//         message = "Something went wrong";
//         break;
//     }
//   }
//
//   String _handleError(int statusCode, dynamic error) {
//     switch (statusCode) {
//       case 400:
//         return 'Bad request';
//       case 404:
//         return error["message"];
//       case 500:
//         return 'Internal server error';
//       case 401:
//         return 'بيانات الاعتماد هذه غير متطابقة مع البيانات المسجلة لدينا';
//       default:
//         return 'Oops something went wrong';
//     }
//   }
//
//   @override
//   String toString() => message!;
// }
