import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ViewAnnouncement());
}

class ViewAnnouncement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Announcement'),
        ),
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                //title
                child: Text(
                  'Mathematics class will be held on Monday 9am - 10am.',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                //uploaded date and time
                child: Text(
                  '(05/12/2020 06:29 PM)',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                //full message
                child: Text(
                  'Extra class of mathematics will be held on 13 Jan, 2020 at 2nd floor class 10 room number 203.'
                  'All student are requested to bring their mathematics books and copies. No any excuses made by students will be '
                  'entertained\. All parents are requested to send their children as per the date.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Text(
                  'Uploaded By:',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Text(
                  'Bivek Kundra',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 2.0),
                child: Text(
                  'Mathematics Teacher',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
