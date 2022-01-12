import 'dart:async';

import 'package:dio/dio.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tood_driver_new/provider/auth_provider.dart';
import 'package:tood_driver_new/provider/driver_data_provider.dart';
import 'package:tood_driver_new/screens/change_pass/change_pass_screen.dart';
import 'package:tood_driver_new/screens/help/constants.dart';
import 'package:tood_driver_new/screens/help/help.dart';
import 'package:tood_driver_new/screens/help/loading_screen.dart';
import 'package:tood_driver_new/screens/login/login_screen.dart';
import 'package:tood_driver_new/screens/notification/notification_screen.dart';
import 'package:tood_driver_new/servise/api_exceptions.dart';
import 'package:tood_driver_new/servise/vars.dart';
import 'package:tood_driver_new/translations/locale_keys.g.dart';

import 'Taps/new_orders.dart';
import 'Taps/open_orders.dart';
import 'closed_orders_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.selectedPage}) : super(key: key);
  final int selectedPage;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  TabController? _tabController;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  // fcmNotification() {
  //   FirebaseMessaging.instance.requestPermission(
  //       sound: true, badge: true, alert: true, provisional: false);
  //
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     RemoteNotification? notification = message.notification;
  //     AndroidNotification? android = message.notification?.android;
  //     if (notification != null && android != null) {
  //       flutterLocalNotificationsPlugin.show(
  //         notification.hashCode,
  //         notification.title,
  //         notification.body,
  //         NotificationDetails(
  //           iOS: IOSNotificationDetails(
  //             subtitle: notification.body ?? "",
  //           ),
  //           android: AndroidNotificationDetails(
  //             "",
  //             notification.title ?? "",
  //             notification.body ?? "",
  //             // TODO add a proper drawable resource to android, for now using
  //             //      one that already exists in icontds app.
  //             icon: '@mipmap/ic_launcher',
  //           ),
  //         ),
  //       );
  //     }
  //   });
  //   // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   //   print('A new onMessageOpenedApp event was published!');
  //   //   RemoteNotification? notification = message.notification;
  //   //   AndroidNotification? android = message.notification?.android;
  //   //   if (notification != null && android != null) {
  //   //     showDialog(
  //   //         context: context,
  //   //         builder: (_) {
  //   //           return AlertDialog(
  //   //             title: Text(notification.title??""),
  //   //             content: SingleChildScrollView(
  //   //               child: Column(
  //   //                 crossAxisAlignment: CrossAxisAlignment.start,
  //   //                 children: [Text(notification.body??"")],
  //   //               ),
  //   //             ),
  //   //           );
  //   //         });
  //   //   }
  //   // });
  //
  //   // ديه بتفتح التطبيق وتقيم الخدمة
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     print(
  //         'A new onMessageOpenedApp event was published Message ${message.notification!.title} ');
  //
  //     if (message.notification!.title == "تغير حالة الطلب") {
  //       Navigator.of(context)
  //           .push(MaterialPageRoute(
  //               builder: (context) => HomeScreen(
  //                     selectedPage: 0,
  //                   )))
  //           .then((value) => setState(() {}));
  //     } else {
  //       Navigator.of(context)
  //           .push(MaterialPageRoute(builder: (context) => NotificationScreen()))
  //           .then((value) => setState(() {}));
  //     }
  //   });
  //
  //   // FirebaseMessaging.instance.getToken().then((value) {
  //   //   print("FIREBASE TOKEN $value");
  //   // });
  // }

  // fcmNotification() async {
  //   //FCM
  //   FirebaseMessaging.instance
  //       .getInitialMessage()
  //       .then((RemoteMessage? message) {
  //     if (message != null) {
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => HomeScreen(selectedPage: 1)));
  //     }
  //   });
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //   NotificationSettings settings = await messaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );
  //
  //   await messaging.setForegroundNotificationPresentationOptions(
  //     alert: true, // Required to display a heads up notification
  //     badge: true,
  //     sound: true,
  //   );
  //
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     RemoteNotification notification = message.notification!;
  //     AndroidNotification? android = message.notification!.android;
  //     print('efweferw' + message.data.toString());
  //     if (notification != null && android != null) {
  //       flutterLocalNotificationsPlugin.show(
  //           notification.hashCode,
  //           notification.title,
  //           notification.body,
  //           NotificationDetails(
  //             android: AndroidNotificationDetails(
  //               '',
  //               notification.title!,
  //               notification.body!,
  //               // TODO add a proper drawable resource to android, for now using
  //               //      one that already exists in icontds app.
  //               icon: '@mipmap/ic_launcher',
  //             ),
  //           ));
  //       // if (message.notification!.title == "تقيم الخدمة") {
  //       //   Navigator.push(
  //       //       context,
  //       //       MaterialPageRoute(
  //       //           builder: (context) => Review(
  //       //             vendorID: message.data['vendor_id'],
  //       //             token: LocalStorage.getData(key: 'token'),
  //       //             orderId: message.data['type_id'],
  //       //           )));
  //       // }
  //     }
  //   });
  //
  //   //ديه بتفتح التطبيق وتقيم الخدمة
  //   // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   //   final order =
  //   //   message.notification!.body!.replaceAll(RegExp('[^0-9]'), '');
  //   //   print(
  //   //       'A new onMessageOpenedApp event was published Message ${message.notification!.title} ');
  //   //   if (message.notification!.title == "تقيم الخدمة") {
  //   //     Navigator.push(
  //   //         context,
  //   //         MaterialPageRoute(
  //   //             builder: (context) => Review(
  //   //               vendorID: message.data['vendor_id'],
  //   //               token: LocalStorage.getData(key: 'token'),
  //   //               orderId: message.data['type_id'],
  //   //             )));
  //   //   } else if (message.notification!.title == "تغير حالة الطلب") {
  //   //     Navigator.push(
  //   //         context,
  //   //         MaterialPageRoute(
  //   //             builder: (context) => OrdersDetailsScreen(
  //   //               id: int.parse(order),
  //   //             )));
  //   //   } else
  //   //     Navigator.push(context,
  //   //         MaterialPageRoute(builder: (context) => NotificationScreen()));
  //   // });
  //
  //   // FirebaseMessaging.instance.getToken().then((value) {
  //   //   print("FIREBASE TOKEN $value");
  //   // });
  // }

  fcmNotification() async {
    //FCM
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(selectedPage: 0)));
      }
    });
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification? android = message.notification!.android;
      print('efweferw' + message.data.toString());
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                notification.title!,
                notification.body!,
                icon: 'app_icon',
              ),
            ));
        if (message.notification!.title == "تغير حالة الطلب") {
          showSimpleNotification(
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(
                              selectedPage: 0,
                            )));
              },
              child: Container(
                height: 67,
                child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Column(
                      children: [
                        Text(
                          message.notification!.title!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          message.notification!.body!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
              ),
            ),
            duration: Duration(seconds: 3),
            elevation: 2.0,
            background: Colors.green,
          );
        } else {
          showSimpleNotification(
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationScreen()));
              },
              child: Container(
                height: 67,
                child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Column(
                      children: [
                        Text(
                          message.notification!.title!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          message.notification!.body!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
              ),
            ),
            duration: Duration(seconds: 3),
            elevation: 2.0,
            background: Colors.green,
          );
        }
      }
    });

    //ديه بتفتح التطبيق وتقيم الخدمة
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification!.title == "تغير حالة الطلب") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      selectedPage: 0,
                    )));
      } else
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NotificationScreen()));
    });

    FirebaseMessaging.instance.getToken().then((value) {
      print("FIREBASE TOKEN $value");
    });
  }

  Future<void> _submit() async {
    try {
      print('0000000000000000000000000000');
      LoadingScreen.show(context);
      await Provider.of<AuthProvider>(context, listen: false).logout();
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
      // helpNavigateTo(context, HomeScreen());
      //   }
    } on ApiException catch (_) {
      print('ApiException');
      Navigator.of(context).pop();
      ServerConstants.showDialog1(context, _.toString());
    } on DioError catch (e) {
      //<<<<< IN THIS LINE
      print(
          "e.response.statusCode    ////////////////////////////         DioError");
      if (e.response!.statusCode == 400) {
        print(e.response!.statusCode);
      } else {
        print(e.message);
        // print(e?.request);
      }
    } catch (e) {
      print('catch');
      print(e);

      Navigator.of(context).pop();
      ServerConstants.showDialog1(context, e.toString());
    } finally {
      if (mounted) setState(() {});
    }
  }

  final List<Tab> listTab = [
    Tab(text: "ppp"),
    Tab(text: LocaleKeys.opened_translate.tr()),
    //   Tab(text: 'Women'),
  ];

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new CupertinoAlertDialog(
            title: new Text(
              LocaleKeys.exit_translate.tr(),
              // CodegenLoader.exit.tr(),
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  LocaleKeys.no_translate.tr(),
                ),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text(
                  LocaleKeys.yes_translate.tr(),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fcmNotification();
    _tabController = new TabController(vsync: this, length: listTab.length);
    _nextPage(widget.selectedPage);
    // _getUserLocation();
    //   Future.delayed(const Duration(seconds: 20), () {
    //     if(lat !=null)
    //     _sendLoc();
    //   });
    // Timer.periodic(Duration(seconds:80), (Timer t) => _getUserLocation());
    // if(lat != null)
    // Timer.periodic(Duration(seconds:100), (Timer t) => _sendLoc());
    // else
    //   print('object');
  }

  void _nextPage(int tab) {
    final int newTab = _tabController!.index + tab;
    if (newTab < 0 || newTab >= _tabController!.length) return;
    _tabController!.animateTo(newTab);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // _tabController = TabController(length: listTab.length, vsync: this);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: DefaultTabController(
          initialIndex: widget.selectedPage,
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                LocaleKeys.orders_translate.tr(),
                style: TextStyle(color: Colors.black),
              ),
              iconTheme: IconThemeData(color: Colors.black),
              centerTitle: true,
              automaticallyImplyLeading: false,
              bottom: TabBar(
                labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                controller: _tabController,
                indicatorWeight: 4,
                indicatorColor: kColorPrimary,
                tabs: [
                  Tab(
                      child: Text(
                    LocaleKeys.new_translate.tr(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Tajawal'),
                  )),
                  Tab(
                      child: Text(
                    LocaleKeys.opened_translate.tr(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Tajawal'),
                  )),
                ],
              ),
            ),
            endDrawer: ChangeNotifierProvider<DriverDataProvider>(
                create: (context) => DriverDataProvider(),
                child: Consumer<DriverDataProvider>(
                    builder: (buildContext, dataProvider, _) => Drawer(
                          // Add a ListView to the drawer. This ensures the user can scroll
                          // through the options in the drawer if there isn't enough vertical
                          // space to fit everything.
                          child: Column(
                            // Important: Remove any padding from the ListView.
                            children: [
                              // const DrawerHeader(
                              //   decoration: BoxDecoration(
                              //     color: Colors.white,
                              //   ),
                              //   child: Text(fName),
                              // ),
                              SizedBox(height: 50),
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 25.0),
                              //   child: ClipRRect(
                              //     borderRadius: BorderRadius.circular(6.0),
                              //     child: Image.asset(
                              //      "assets/images/t.png",
                              //       fit: BoxFit.fill,
                              //       height: 70,
                              //       width: 70,
                              //     ),
                              //   ),
                              // ),
                              Text(
                                "${dataProvider.fName} ${dataProvider.lName}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 6),
                                  child: Text(
                                    "${dataProvider.vNameAr}",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: kColorPrimary),
                                  )),
                              SizedBox(
                                height: 50,
                              ),
                              ListTile(
                                title: Row(
                                  children: [
                                    const Icon(
                                      Icons.home_outlined,
                                      size: 26,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      LocaleKeys.home_translate.tr(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  // Update the state of the app
                                  // ...
                                  // Then close the drawer
                                  helpNavigateTo(
                                      context, HomeScreen(selectedPage: 0));
                                  // Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: Row(
                                  children: [
                                    const Icon(Icons.history, size: 26),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      LocaleKeys.history_translate.tr(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  // Update the state of the app
                                  // ...
                                  // Then close the drawer
                                  helpNavigateTo(context, ClosedOrdersScreen());
                                },
                              ),
                              ListTile(
                                title: Row(
                                  children: [
                                    const Icon(Icons.notifications_none,
                                        size: 26),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      LocaleKeys.notifications_translate.tr(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  // Update the state of the app
                                  // ...
                                  // Then close the drawer
                                  //Navigator.pop(context);
                                  helpNavigateTo(context, NotificationScreen());
                                },
                              ),
                              ListTile(
                                title: Row(
                                  children: [
                                    const Icon(Icons.lock_outline, size: 26),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      LocaleKeys.password_setting_translate
                                          .tr(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  // Update the state of the app
                                  // ...
                                  // Then close the drawer
                                  helpNavigateTo(context, ChangePassScreen());
                                },
                              ),
                              // ListTile(
                              //   title: Row(
                              //     children: [
                              //       const Icon(Icons.language, size: 26),
                              //       SizedBox(
                              //         width: 10,
                              //       ),
                              //       Text(
                              //         LocaleKeys.language_translate.tr(),
                              //         style: TextStyle(
                              //             fontSize: 20,
                              //             fontWeight: FontWeight.bold),
                              //       ),
                              //     ],
                              //   ),
                              //   onTap: () async {
                              //     if (context.locale.toString() == 'ar') {
                              //       await context.setLocale(
                              //         Locale("en"),
                              //       );
                              //       SharedPreferences prefs =
                              //           await SharedPreferences.getInstance();
                              //       prefs.setString("lang", "en");
                              //     } else {
                              //       await context.setLocale(
                              //         Locale("ar"),
                              //       );
                              //       SharedPreferences prefs =
                              //           await SharedPreferences.getInstance();
                              //       prefs.setString("lang", "ar");
                              //     }
                              //   },
                              // ),
                              ListTile(
                                title: Row(
                                  children: [
                                    const Icon(Icons.logout, size: 26),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      LocaleKeys.log_Out_translate.tr(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                onTap: () async {
                                  // Update the state of the app
                                  // ...
                                  // Then close the drawer
                                  _submit();
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.remove('access_token');
                                },
                              ),
                            ],
                          ),
                        ))),
            body: SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IndexedStack(
                children: [
                  TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      Container(
                          height: MediaQuery.of(context).size.height,
                          child: NewOrders()),
                      OpenedOrders(),
                      //  Women(),
                    ],
                  ),
                ],
              ),
            )),
          )),
    );
  }
}
