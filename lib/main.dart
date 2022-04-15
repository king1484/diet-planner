import 'package:diet_planner/database_helper.dart';
import 'package:diet_planner/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

void callbackDispatcher() {
  var androidPlatformSpecifics = const AndroidNotificationDetails(
    "notif",
    "notif",
  );
  var platformSpecifics =
      NotificationDetails(android: androidPlatformSpecifics);

  Workmanager().executeTask((task, inputData) async {
    DateTime now = DateTime.now();

    if (now.hour >= 8 && now.hour <= 22) {
      DatabaseHelper databaseHelper = DatabaseHelper();
      await databaseHelper.openDB();
      await databaseHelper.newDate();
      List<Map<String, dynamic>> data = await databaseHelper.getData();

      int breakFast = data[0]["breakFastDone"];
      int lunch = data[0]["lunchDone"];
      int dinner = data[0]["dinnerDone"];
      int water = data[0]["water"];
      SharedPreferences preferences = await SharedPreferences.getInstance();

      if (task == "waterRemainder") {
        if (preferences.getBool("waterOn") ?? true) {
          debugPrint("Water remainder fired");
          if (water <= 10) {
            await notificationsPlugin.show(
                1,
                "Its Water Time !",
                "Drink a glass of water and update in the app",
                platformSpecifics,
                payload: 'water');
          }
        }
      } else if (task == "foodRemainder") {
        debugPrint("Food remainder fired");
        if (now.hour >= 8 && now.hour <= 10) {
          if (breakFast == 0) {
            await notificationsPlugin.show(
                1,
                "Its Breakfast Time !",
                "Please take your breakfast or update if already taken",
                platformSpecifics,
                payload: 'breakFast');
          }
        } else if (now.hour >= 12 && now.hour <= 14) {
          if (lunch == 0) {
            await notificationsPlugin.show(
                1,
                "Its Lunch Time !",
                "Please take your lunch or update if already taken",
                platformSpecifics,
                payload: 'lunch');
          }
        } else if (now.hour >= 20 && now.hour <= 22) {
          if (dinner == 0) {
            await notificationsPlugin.show(
                1,
                "Its Dinner Time !",
                "Please take your dinner or update if already taken",
                platformSpecifics,
                payload: 'dinner');
          }
        }
      }
    }
    debugPrint("*****Called******");
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings("@mipmap/launcher_icon");
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await notificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) {
    if (payload != null) {
      debugPrint("Notification payload: $payload");
    }
  });

  Workmanager().initialize(callbackDispatcher);

  Workmanager().registerPeriodicTask(
    "10",
    "foodRemainder",
    frequency: const Duration(hours: 1),
  );

  Workmanager().registerPeriodicTask(
    "20",
    "waterRemainder",
    frequency: const Duration(hours: 1, minutes: 10),
  );

  await Firebase.initializeApp();
  await FirebaseDatabase.instance.setPersistenceEnabled(true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Diet Planner",
      home: SplashScreen(),
    );
  }
}
