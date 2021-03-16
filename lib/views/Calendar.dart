import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

Future<String> loadAsset(location) async {
  return await rootBundle.loadString('assets/cal/' + location + '.json');
}

class Calendar extends StatefulWidget {
  Calendar({Key key}) : super(key: key);

  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> with AutomaticKeepAliveClientMixin<Calendar> {
  @override
  bool get wantKeepAlive => true;
  int monthIndex = 1;
  int day1Index = 1;
  int dayLastIndex = 1;
  int year = 0;
  String selectedLocation = 'Select Location...';
  var calData;
  Map today = {};
  Map selectedDate = {};
  List<String> locationList = ['Bogota', 'India', 'Manila', 'Mauritius', 'Mexico', 'New York', 'Singapore', 'UK'];
  List<String> week = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  List<List<Map>> month = [];
  SharedPreferences prefs;

  List<Map> months = [
    {'name': 'January', 'days': 31},
    {'name': 'February', 'days': 28},
    {'name': 'March', 'days': 31},
    {'name': 'April', 'days': 30},
    {'name': 'May', 'days': 31},
    {'name': 'June', 'days': 30},
    {'name': 'July', 'days': 31},
    {'name': 'August', 'days': 31},
    {'name': 'September', 'days': 30},
    {'name': 'October', 'days': 31},
    {'name': 'November', 'days': 30},
    {'name': 'December', 'days': 31}
  ];

  String getDateText(year, month, date) {
    String sliceDate(str) {
      if (str.length == 1) {
        return '0' + str;
      } else {
        return str;
      }
    }
    return year.toString() + '-' + sliceDate(month.toString()) + '-' + sliceDate(date.toString());
  }

  void getMonth(date) {
    month = [];

    void fillMonth(weekNo, dateNum) {
      bool lastWeek = false;
      month.add([]);
      for (int i = 1; i <= 7; i++) {
      if ((weekNo == 0 && i < day1Index) || lastWeek) {
          month[weekNo].add({'display': ''});
        } else if (dateNum != months[monthIndex - 1]['days']) {
          month[weekNo].add({
            'display': dateNum.toString(),
            'date': dateNum,
            'month': monthIndex,
            'year': year,
            'day': i,
            'dateText': getDateText(year, monthIndex, dateNum)
          });
          dateNum++;
        } else {
          lastWeek = true;
          dayLastIndex = i;
          month[weekNo].add({
            'display': dateNum.toString(),
            'date': dateNum,
            'month': monthIndex,
            'year': year,
            'day': i,
            'dateText': getDateText(year, monthIndex, dateNum)
          });
        }
      }
      if (!lastWeek) {
        fillMonth(weekNo + 1, dateNum);
      }
    }

    if (date['date'] != 1) {
      day1Index = (((date['day'] - (date['date'] % 7)) + 1 + 7) % 7);
    } else {
      day1Index = date['day'];
    }

    fillMonth(0, 1);
  }
  
  void checkFeb() {
    if (monthIndex == 1 && (year % 4) == 0) {
      months[1]['days'] = 29;
    } else {
      months[1]['days'] = 28;
    }
  }

  void nextMonth() {
    if (monthIndex == 12) {
      monthIndex = 1;
      year++;
    } else {
      monthIndex++;
    }
    checkFeb();
    if (dayLastIndex == 7) {
      getMonth({ 'date': 1, 'day': 1 });
    } else {
      getMonth({ 'date': 1, 'day': dayLastIndex + 1 });
    }
  }

  void prevMonth() {
    if (monthIndex == 1) {
      monthIndex = 12;
      year--;
    } else {
      monthIndex--;
    }
    checkFeb();
    if (day1Index == 1) {
      getMonth({ 'date': months[monthIndex - 1]['days'], 'day': 7 });
    } else {
      getMonth({ 'date': months[monthIndex - 1]['days'], 'day': day1Index - 1 });
    }
  }

  void locationDialog() async {
    showDialog(context: context,
      child: SimpleDialog(
        title: Text("Select location"),
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.5,
            width: 50.0,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: locationList.map<Widget>((location) => ListTile(
                trailing: (() {
                  if (selectedLocation == location) {
                    return Icon(Icons.check);
                  } else {
                    return Icon(null);
                  }
                })(),
                title: Text(location),
                onTap: () async {
                  calData = await loadAsset(location);
                  if (calData != null) {
                    setState(() {
                      calData = jsonDecode(calData);
                      selectedLocation = location;
                      prefs.setString('location', location);
                      Navigator.of(context, rootNavigator: true).pop();
                    });
                  }
                },
              )).toList(),
            )
          )
        ],
      )
    );
  }

  void getLocation() async {
    prefs = await SharedPreferences.getInstance();
    String location = prefs.getString('location');
    if (location != null) {
      calData = await loadAsset(location);
      if (calData != null) {
        setState(() {
          calData = jsonDecode(calData);
          selectedLocation = location;
        });
      }
    }
  }
  
  @override
  void initState() {
    super.initState();
    var todate = DateTime.now();
    today = {
      'date': todate.day,
      'month': todate.month,
      'year': todate.year,
      'day': todate.weekday,
    };
    today['dateText'] = getDateText(today['year'], today['month'], today['date']);
    monthIndex = today['month'];
    year = today['year'];
    selectedDate = today;
    getMonth(today);
    getLocation();
  }

  @override
  void dispose() {
	  super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          Row(children: [
            FlatButton(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text('<'),
              onPressed: () {
                setState(() {
                  prevMonth();
                });
            },),
            Expanded(child: Center(child: Text(months[monthIndex - 1]['name'] + ' ' + year.toString()),)),
            FlatButton(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text('>'),
              onPressed: () {
                setState(() {
                  nextMonth();
                });
            },),
          ],),
          Row( children: week.map((weekday) => Expanded(child: Center( child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(weekday.substring(0, 3)),
          ), ), ), ).toList(), ),
          Column( children: month.map<Widget>((week) => Row(
            children: week.map<Widget>((date) => Expanded( child: Stack(
              children: 
                (() {
                  List<Widget> dateEventSet = [
                    Center(child: FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      color: (() {
                        if (date['dateText'] == today['dateText']) {
                          return Colors.deepOrange[200];
                        } else if (date['dateText'] == selectedDate['dateText']) {
                          return Colors.orange[200];
                        } else {
                          return Colors.transparent;
                        }
                      })(),
                      child: Text(date['display'] ), onPressed: () {
                        setState(() {
                          selectedDate = date;
                        });
                      },
                    ), ),
                  ];
                  if (calData != null && calData[date['dateText']] != null) {
                    if (calData[date['dateText']]['events'].length > 0 || calData[date['dateText']]['special'] != null) {
                      int eventCount = calData[date['dateText']]['events'].length > 0 ? calData[date['dateText']]['events'].length : 0;
                      if (calData[date['dateText']]['special'] != null) {
                        eventCount++;
                      }
                      dateEventSet.add(Positioned(
                        top: 38.0,
                        left: (MediaQuery.of(context).size.width / 7) - 23.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.all(Radius.circular(7.5))
                          ),
                          child: Center( child: Text(
                            eventCount.toString(),
                            style: TextStyle(fontSize: 10.0),
                          ), ),
                          width: 15.0,
                          height: 15.0
                        ),
                      ));
                    }
                    if (calData[date['dateText']]['ekadashi'] != null) {
                      dateEventSet.add(Positioned(
                        top: 39.0,
                        left: (MediaQuery.of(context).size.width / 7) - 51.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.redAccent[100],
                            borderRadius: BorderRadius.all(Radius.circular(7.5))
                          ),
                          width: 13.0,
                          height: 13.0
                        ),
                      ));
                    }
                  }
                  return dateEventSet;
                })(),
              ),
            )).toList(),
          )).toList(),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: (() {
            if (calData != null && calData[selectedDate['dateText']] != null) {
              List<Widget> events = [Container(
                padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 5.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  calData[selectedDate['dateText']]['lunar-day'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  textAlign: TextAlign.center,
                )
              )];
              if (calData[selectedDate['dateText']]['ekadashi'] != null) {
                events.add(Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.red[100],
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                  child: Text(calData[selectedDate['dateText']]['ekadashi']),
                ));
              }
              if (calData[selectedDate['dateText']]['special'] != null) {
                events.add(Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.orange[100],
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                  child: Text(calData[selectedDate['dateText']]['special']),
                ));
              }
              for (int i = 0; i < calData[selectedDate['dateText']]['events'].length; i++) {
                events.add(Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                  child: Text(calData[selectedDate['dateText']]['events'][i]['name']),
                ));
              }
              return events;
            } else {
              return <Widget>[];
            }
          })(),
        )
      ],),
      floatingActionButton: FloatingActionButton(
        onPressed: locationDialog,
        child: Icon(Icons.location_on),
        backgroundColor: Colors.deepOrange[300],
      ),
    );
  }
}
