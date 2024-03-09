import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_core/src/smart_management.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nebula/routes/app_pages.dart';
import 'package:nebula/utils/app_utils.dart';
import 'package:nebula/utils/global_utils.dart';
import 'package:nebula/utils/storage.dart';
import 'package:nebula/utils/strings.dart';
import 'package:nebula/view/auth/splash/splash_screen.dart';

import 'app_binding.dart';
import 'utils/log_utils.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    // await GlobalUtils().init();
    // await GetStorage.init("chatContainer");
    // await setupPushNotificationsListeners();
    // await initializeFlutterCrashlytics();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp])
        .then((value) => runApp(MyApp()));
  }, (error, stackTrace) {
    LogUtils.debugLog("********* Error ******");
    LogUtils.error(error.toString());
    LogUtils.error(stackTrace.toString());
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

setupPushNotificationsListeners() async {
  AndroidNotificationChannel callSummaryNotificationChannel =
  AndroidNotificationChannel(
      'call_summary_channel', 'Call Summary Notification',
      description:
      'This is to trigger ${GlobalUtils.entity} popup when a call is ended.',
      importance: Importance.high,
      showBadge: false,
      playSound: false);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(callSummaryNotificationChannel);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  if (Platform.isIOS) {
    NotificationSettings settings =
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
    }
  }

  await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
          android:
          AndroidInitializationSettings("@drawable/ic_notification_icon"),
          iOS: DarwinInitializationSettings()),
      );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // color: ColorConstants.primaryOrange,
              channelDescription: channel.description,
              playSound: true,
              icon: '@drawable/ic_notification_icon',
            ),
          ),
          payload: jsonEncode(message.data));
    }
    if (jsonEncode(message.data).isNotEmpty) {
      Map payloadData = jsonDecode(jsonEncode(message.data));
      // String? type = payloadData["moduleType"];

    }
  });

  AppUtils().checkForFCMUpdate();
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    AppUtils().checkForFCMUpdate();
  });

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    // AppUtils.handleNotificationRedirection(jsonEncode(event.data));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      enableLog: true,
      textDirection: TextDirection.ltr,
      initialRoute: Routes.splash,
      initialBinding: AppBinding(),
      defaultTransition: Transition.fade,
      getPages: AppPages.routes,
      smartManagement: SmartManagement.full,
      title: Strings.nebula,
      // navigatorObservers: [AnalyticsHelper.getAnalyticsObserver()],
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: Colors.white,
          backgroundColor: Colors.white),
    );
  }
}

