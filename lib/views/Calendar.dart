import 'package:flutter/material.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

  String today = 'No Date';
  
  List<List<Widget>> month = [];

  void getMonth(day1Index, numOfDays) {
    month = [];

    void fillMonth(weekNo, date) {
      bool lastWeek = false;
      month.add([]);
      for(int i = 0; i < 7; i++) {
        if (weekNo == 0 && i < day1Index) {
          month[0].add(Expanded( child: Center( child: Text('') ) ));
        } else if(date != numOfDays) {
          month[weekNo].add(Expanded(child: Center(child: Text(date.toString()))));
          date++;
        } else {
          lastWeek = true;
          month[weekNo].add(Expanded(child: Center(child: Text(date.toString()))));
          month[weekNo].add(Expanded(flex: (7 - (i + 1)),child: Center(child: Text(''))));
          break;
        }
      }
      if (!lastWeek) {
        fillMonth(weekNo + 1, date);
      }
    }

    fillMonth(0, 1);
  }

  @override
  void initState() {
    super.initState();
    getMonth(3, 31);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sri Chaitanya Saraswat Math'),
        backgroundColor: Colors.deepOrange[300],
      ),
      body: Column(
        children: month.map<Widget>((week) => Row(
          children: week,
        )).toList()
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            print(month.isEmpty);
            getMonth(6, 30);
          });
        }
      ),
    );
  }
}