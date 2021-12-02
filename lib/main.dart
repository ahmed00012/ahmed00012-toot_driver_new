import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tood_driver_new/provider/auth_provider.dart';
import 'package:tood_driver_new/screens/splash_screen/splash_screen.dart';
import 'package:tood_driver_new/translations/codegen_loader.g.dart';

import 'screens/home/home_screen.dart';

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     'This channel is used for important notifications.', // description
//     importance: Importance.high,
//     playSound: true);

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('A bg message just showed up :  ${message.messageId}');
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');
  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  runApp(EasyLocalization(
      path: "assets/translations/ar.json",
      supportedLocales: [
        Locale("ar"),
        // Locale("en"),
      ],
      fallbackLocale: Locale('ar'),
      assetLoader: CodegenLoader(),
      saveLocale: true,
      child: MyApp(
        log: token,
      )));
}

class MyApp extends StatefulWidget {
  final String? log;
  //late final bool status;
  const MyApp({Key? key, this.log}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseMessaging.instance.getToken().then((token) {
      print(token.toString() + 'hhhhhhh');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider(
        create: (context) => AuthProvider(),
        child: OverlaySupport.global(
          child: MaterialApp(
            title: 'Flutter Demo',
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: ThemeData(
              primarySwatch: Colors.green,
              fontFamily: 'Tajawal',
            ),
            home: widget.log == null
                ? SplashScreen()
                : HomeScreen(selectedPage: 0),
            debugShowCheckedModeBanner: false,
          ),
        ));
  }
}
