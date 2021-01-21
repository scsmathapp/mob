import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
				title: Text('Sri Chaitanya Saraswat Math'),
				backgroundColor: Colors.deepOrange[300],
			),
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
            child: RaisedButton(
              color: Colors.blue,
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
              color: Colors.blue,
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
              color: Colors.blue,
              child: Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {},
            )
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
    );
	}
}