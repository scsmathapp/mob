import 'package:flutter/material.dart';
import 'Menu.dart';
import 'Calendar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<NavigatorState> _navigatorKey = new GlobalKey<NavigatorState>(debugLabel: 'navigator');
  // final GlobalKey<CalendarState> _globalKey = new GlobalKey<CalendarState>(debugLabel: 'global');

  int _selectedIndex = 1;
  static List<String> _widgetOptions = <String>[ '/menu', '/calendar' ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header', style: TextStyle(color: Colors.white)),
              decoration: BoxDecoration(
                color: Colors.deepOrange[300],
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Sri Chaitanya Saraswat Math'),
        backgroundColor: Colors.deepOrange[300],
      ),
      body: Navigator(
        key: _navigatorKey,
        initialRoute: '/calendar',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          // Manage your route names here
          if (settings.name == '/menu') {
            builder = (BuildContext context) => Menu();
          } else {
            builder = (BuildContext context) => Calendar();
          }
          // You can also return a PageRouteBuilder and
          // define custom transitions between pages
          return MaterialPageRoute(
            builder: builder,
            settings: settings,
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
        ],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          _navigatorKey.currentState.pushReplacementNamed(_widgetOptions.elementAt(index));
        },
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepOrange[300],
      ),
    );
  }
}