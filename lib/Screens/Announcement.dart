import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(Announcement());
}

class Announcement extends StatelessWidget {
  final category = [
    'Academic',
    'Co-curricular/Sports',
    'Administrative',
    'Events',
    'Academic',
    'Co-curricular/Sports',
    'Administrative',
    'Events',
  ];

  final announcement = [
    'Extra class of mathematics will be held on 13 Jan, 2020 at 2nd floor class 10 room number 203.',
    'Student of class 12 are organizing teacher\'s day and you are requested to co-operate them.',
    'Last day of fee submission is 20 Jan, 2020 for class 9 and 10.',
    'Trees plantattion campeign will be held on 2 feb, 2020 on ocassion of Environment day.',
    'Extra class of mathematics will be held on 13 Jan, 2020 at 2nd floor class 10 room number 203.',
    'Student of class 12 are organizing teacher\'s day and you are requested to co-operate them.',
    'Last day of fee submission is 20 Jan, 2020 for class 9 and 10.',
    'Trees plantattion campeign will be held on 2 feb, 2020 on ocassion of Environment day.',
  ];
  final date = [
    '2nd feb, 2020',
    '3rd feb, 2020',
    '4th feb, 2020',
    '5th feb, 2020',
    '6th feb, 2020',
    '7th feb, 2020',
    '8th feb, 2020',
    '9th feb, 2020'
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Announcements'),
        ),
        body: ListView.builder(
          itemCount: date.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int position) {
            return Container(
              margin: EdgeInsets.only(left: 10.0, right: 10, top: 5, bottom: 5),
              child: GestureDetector(
                onTap: () {
                  showToast('Position: $position');
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, top: 20, bottom: 20.0),
                    child: Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 5.0, top: 2, right: 3, bottom: 2),
                                  margin: EdgeInsets.only(right: 5.0),
                                  color: Colors.red[500],
                                  child: Text(
                                    category[position],
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                  date[position],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              margin: EdgeInsets.only(top: 10.0),
                              child: Text(
                                announcement[position],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 40,
                          width: 40,
                          child: Icon(
                            Icons.arrow_forward_ios,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void showToast(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
