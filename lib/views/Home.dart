import 'package:flutter/material.dart';
import 'Menu.dart';
import 'Calendar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  int _selectedIndex = 1;
  static List<String> _widgetOptions = <String>[ '/menu', '/calendar' ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: _navigatorKey,
        initialRoute: '/calendar',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          // Manage your route names here
          switch (settings.name) {
            case '/menu':
              builder = (BuildContext context) => Menu();
              break;
            case '/calendar':
              builder = (BuildContext context) => Calendar();
              break;
            default:
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
            title: Text('Menu')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text('Calendar'),
          ),
        ],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          _navigatorKey.currentState.pushNamed(_widgetOptions.elementAt(index));
        },
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepOrange[300],
      ),
    );
  }
}