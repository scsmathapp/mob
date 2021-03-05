import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isSwitched = false;

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
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                    print(isSwitched);
                  });
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