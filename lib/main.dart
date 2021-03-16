import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'views/Home.dart';

FlutterLocalNotificationsPlugin fltrNotification;

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    var androidInitilize = new AndroidInitializationSettings('app_icon');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings = new InitializationSettings(androidInitilize, iOSinitilize);
    fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initilizationsSettings);
    var androidDetails = new AndroidNotificationDetails("Vaishnava_App", "SCSMath", "Vaishnava_App Notif Channel", icon: 'app_icon', importance: Importance.Max, styleInformation: BigTextStyleInformation(''));
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails = new NotificationDetails(androidDetails, iSODetails);
    await fltrNotification.show(0, "Task", "You created a \nTask", generalNotificationDetails, payload: "Task");
    return Future.value(true);
  });
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			initialRoute: '/',
			routes: {
				'/': (BuildContext context) => Home(),
			},
		);
	}
}

