import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:convert';

SharedPreferences prefs;

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    SharedPreferences prefs;

    String getDateText(date) {
      String sliceDate(str) {
        if (str.length == 1) {
          return '0' + str;
        } else {
          return str;
        }
      }
      return date.year.toString() + '-' + sliceDate(date.month.toString()) + '-' + sliceDate(date.day.toString());
    }

    String getEvents(date) {
      String events = '';
      for (int i = 0; i < date['events'].length; i++) {
        if (i != 0) events += '\n';
        events += date['events'][i]['name'];
      }
      return events;
    }

    Future<String> loadAsset(location) async {
      return await rootBundle.loadString('assets/cal/' + location + '.json');
    }

    Future getLocation() async {
      prefs = await SharedPreferences.getInstance();
      var calData;
      String location = prefs.getString('location');
      if (location != null) {
        calData = await loadAsset(location);
        if (calData != null) {
          return jsonDecode(calData);
        }
      }
    }
    AndroidInitializationSettings androidInitilize = new AndroidInitializationSettings('app_icon');
    IOSInitializationSettings iOSinitilize = new IOSInitializationSettings();
    InitializationSettings initilizationsSettings = new InitializationSettings(androidInitilize, iOSinitilize);
    FlutterLocalNotificationsPlugin fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initilizationsSettings);
    AndroidNotificationDetails androidDetails = new AndroidNotificationDetails("Vaishnava_App", "SCSMath", "Vaishnava_App Notif Channel", icon: 'app_icon', importance: Importance.Max, styleInformation: BigTextStyleInformation(''));
    IOSNotificationDetails iOSDetails = new IOSNotificationDetails();
    NotificationDetails generalNotificationDetails = new NotificationDetails(androidDetails, iOSDetails);
    DateTime now = DateTime.now();
    Map calData = await getLocation();
    DateTime tomorrow = now.add(Duration(days: 1));
    String todayText = getDateText(now);
    String tomorrowText = getDateText(tomorrow);
    String afterTomorrowText = getDateText(tomorrow.add(Duration(days: 1)));
    if (now.hour < 5) {
      if (calData[todayText] != null && calData[todayText]['events'] != null) {
        fltrNotification.schedule(int.parse(todayText.replaceAll('-', '') + '0'), "Today", getEvents(calData[todayText]), DateTime(now.year, now.month, now.day, 5, 0), generalNotificationDetails);
      }
      if (calData[tomorrowText] != null && calData[tomorrowText]['events'] != null) {
        fltrNotification.schedule(int.parse(todayText.replaceAll('-', '') + '1'), "Tomorrow", getEvents(calData[tomorrowText]), DateTime(now.year, now.month, now.day, 20, 0), generalNotificationDetails);
      }
    } else if (now.hour < 20) {
      if (calData[tomorrowText] != null && calData[tomorrowText]['events'] != null) {
        fltrNotification.schedule(int.parse(tomorrowText.replaceAll('-', '') + '0'), "Today", getEvents(calData[tomorrowText]), DateTime(now.year, now.month, now.day, 5, 0), generalNotificationDetails);
      }
      if (calData[tomorrowText] != null && calData[tomorrowText]['events'] != null) {
        fltrNotification.schedule(int.parse(todayText.replaceAll('-', '') + '1'), "Tomorrow", getEvents(calData[tomorrowText]), DateTime(now.year, now.month, now.day, 20, 0), generalNotificationDetails);
      }
    } else {
      if (calData[tomorrowText] != null && calData[tomorrowText]['events'] != null) {
        fltrNotification.schedule(int.parse(tomorrowText.replaceAll('-', '') + '0'), "Today", getEvents(calData[tomorrowText]), DateTime(now.year, now.month, now.day, 5, 0), generalNotificationDetails);
      }
      if (calData[afterTomorrowText] != null && calData[afterTomorrowText]['events'] != null) {
        fltrNotification.schedule(int.parse(tomorrowText.replaceAll('-', '') + '1'), "Tomorrow", getEvents(calData[afterTomorrowText]), DateTime(now.year, now.month, now.day, 20, 0), generalNotificationDetails);
      }
    }
    return Future.value(true);
  });
}

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isSwitched = false;

  void getSwitch() async {
    prefs = await SharedPreferences.getInstance();
    bool notif = prefs.getBool('notif');
    if (notif != null) {
      setState(() {
        isSwitched = notif;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getSwitch();
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  void dispose() {
	  super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(40.0),
                child: Text(
                  'Suyash',
                  style: TextStyle(
                    fontSize: 40.0
                  ),
                ),
              ),
              Container(
                child: FlatButton.icon(
                  icon: Icon(Icons.edit),
                  label: Text(
                    'Edit Info',
                  ),
                  onPressed: () {},
                )
              )
            ],
          ),
          Container (
            padding: EdgeInsets.all(20.0),
            child: Row(children: [
              Expanded(child: Text('Receive notifications for events')),
              Switch(
                value: isSwitched,
                onChanged: (value) async {
                  setState(() {
                    isSwitched = value;
                  });
                  prefs = await SharedPreferences.getInstance();
                  prefs.setBool('notif', value);
                  if (value) {
                    // _showNotification();
                    String now = DateTime.now().toString();
                    await Workmanager.initialize(callbackDispatcher);
                    await Workmanager.registerOneOffTask(now, "daily_notif");
                    print(Workmanager.registerOneOffTask);
                  } else {
                    Workmanager.cancelAll();
                  }
                },
                activeColor: Colors.deepOrange[300],
              ),
            ])
          ),
          Container (
            padding: EdgeInsets.all(20.0),
            child: RaisedButton(
              color: Colors.deepOrange[300],
              child: Text(
                'Go to calendar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/notif');
              },
            )
          ),
          Container (
            padding: EdgeInsets.all(20.0),
            child: RaisedButton(
              color: Colors.deepOrange[300],
              child: Text(
                'View my reports',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {},
            )
          ),
          Container (
            padding: EdgeInsets.all(20.0),
            child: RaisedButton(
              color: Colors.deepOrange[300],
              child: Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {},
            )
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
    );
	}
}