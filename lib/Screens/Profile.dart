import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Profile());
}

class Profile extends StatelessWidget {
  var profileImage =
      'https://img.etimg.com/thumb/width-640,height-480,imgsize-357504,resizemode-1,msid-72039253/beardo-boss-bats-for-moustaches-this-movember-talks-about-the-biggest-grooming-mistake-men-make.jpg';
  var studentName = 'Mukesh Kumar';
  var studentUID = '11712414';
  var classSection = 'Class: 10 (Section: 1)';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.blue[600],
                  width: double.infinity,
                  height: 200.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(profileImage),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5.0, bottom: 3.0),
                        child: Text(
                          studentName,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                      ),
                      Text(
                        studentUID,
                        style: TextStyle(color: Colors.white, fontSize: 14.0),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 3.0),
                        child: Text(
                          classSection,
                          style: TextStyle(color: Colors.white, fontSize: 14.0),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 1,
                  child: Container(
                    color: Colors.grey,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Text(
                    'Basic',
                  ),
                ),
                SizedBox(
                  height: 1,
                  child: Container(
                    color: Colors.grey,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0, left: 30.0, bottom: 20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Father\'s Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 3),
                        child: Text('Mahesh Kumar'),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Mother\'s Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 3),
                        child: Text('Gita Devi'),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Contact No.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 3),
                        child: Text('+91-000-000-0000'),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Email',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 3),
                        child: Text('example@gmail.com'),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Date of Birth',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 3),
                        child: Text('25 Nov, 1996'),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Gender',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 3),
                        child: Text('Male'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 1,
                  child: Container(
                    color: Colors.grey,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Text(
                    'Academic Details',
                  ),
                ),
                SizedBox(
                  height: 1,
                  child: Container(
                    color: Colors.grey,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0, left: 30.0, bottom: 20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Program',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 3),
                        child: Text('SSC/HSEB'),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Batch',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 3),
                        child: Text('2017'),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Class',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 3),
                        child: Text('10'),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Section',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 3),
                        child: Text('II'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 1,
                  child: Container(
                    color: Colors.grey,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Text(
                    'Hostel Details',
                  ),
                ),
                SizedBox(
                  height: 1,
                  child: Container(
                    color: Colors.grey,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0, left: 30.0, bottom: 70),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Hostel',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text('Not Applicable'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
