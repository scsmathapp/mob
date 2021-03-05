import 'package:flutter/material.dart';
import 'Settings.dart';
import 'Calendar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController _pageController;

  int _selectedIndex = 1;
  List<Widget> _pages = <Widget>[Settings(), Calendar()];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sri Chaitanya Saraswat Math'),
        backgroundColor: Colors.deepOrange[300],
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
        ],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepOrange[300],
      ),
    );
  }
}