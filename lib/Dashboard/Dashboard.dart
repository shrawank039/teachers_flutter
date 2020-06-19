import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teachers/Attendance/StudentAttaindance.dart';
import 'package:teachers/CustomDrawer.dart';
import 'package:teachers/Profile/Profile.dart';
import 'package:teachers/ServerAPI.dart';
import 'package:teachers/Support/Contact.dart';

import '../Announcement/Announcement.dart';
import '../Fragments/TabIndex.dart';
import '../Schedule/Schedule.dart';
import '../NewsRoom/NewsRoom.dart';

import 'package:permission_handler/permission_handler.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String schoolName = "";
  String teacherName = "";
  String schoolLogo = "";
  String teacherCode = "";

  final androidVersionNames = [
    'Schedule',
    'Announce-\nment',
    'Class Room',
    'Attendance',
    'Profile',
    'Administrative \nQuery',
    'GK & News \nRoom',
    'Educational Stories',
  ];

  final carIcons = [
    'assets/images/schedule.png',
    'assets/images/announcement.png',
    'assets/images/chat.png',
    'assets/images/attendance.png',
    'assets/images/profile.png',
    'assets/images/help.png',
    'assets/images/news.png',
    'assets/images/education.png',
  ];

  final colors = [
    Colors.blue[200],
    Colors.red[300],
    Colors.green[300],
    Colors.purple[200],
    Colors.green[300],
    Colors.purple[300],
    Colors.green[200],
    Colors.red[300],
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
    testStorage();
  }

  requestPermission() async {
    await Permission.camera.request();
    await Permission.microphone.request();
  }

  testStorage() async {
    final result = await ServerAPI().getUserInfo();
    setState(() {
      if (result['school_name'] != null) schoolName = result['school_name'];
      if (result['teacher_name'] != null) teacherName = result['teacher_name'];
      if (result['teacher_code'] != null) teacherCode = result['teacher_code'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text("Teacher Dashboard"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[

              Container(
                width: double.infinity,
                height: 200.0,
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Image.asset('assets/images/school_banner.png',
                          fit: BoxFit.fill),
                      height: 190.0,
                      width: MediaQuery.of(context).size.width,
                    ),
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 25, bottom: 7),
                            width: 70.0,
                            height: 70.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    'https://f0.pngfuel.com/png/382/222/delhi-public-school-faridabad-modern-delhi-public-school-delhi-public-school-society-national-secondary-school-others-png-clip-art.png'),
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              teacherName.toUpperCase(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              teacherCode.toUpperCase(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 3),
                            child: Text(
                              ('Welcome to ' + schoolName).toUpperCase(),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                //fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                //Image.asset('assets/images/school.jpg'),
              ),

              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: carIcons.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 5.0,
                    margin: EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0, bottom: 5.0),
                    child: Container(
                      child: GestureDetector(
                        onTap: () {
                          if (index == 2) {
                            Route route = MaterialPageRoute(builder: (context) => TabIndex());
                            Navigator.push(context, route);
                          }

                          if (index == 0) {
                            Route route = MaterialPageRoute(
                                builder: (context) => Schedule());
                            Navigator.push(context, route);
                          }

                          if (index == 1) {
                            Route route = MaterialPageRoute(builder: (context) => Announcement());
                            Navigator.push(context, route);
                          }

                          if (index == 3) {
                            Route route = MaterialPageRoute(builder: (context) => StudentAttaindance());
                            Navigator.push(context, route);
                          }

                          if (index == 4) {
                            Route route = MaterialPageRoute(builder: (context) => Profile());
                            Navigator.push(context, route);
                          }

                          if (index == 5) {
                            Route route = MaterialPageRoute(builder: (context) => Contact());
                            Navigator.push(context, route);
                          }

                          if (index == 6) {
                            Route route = MaterialPageRoute(builder: (context) => NewsRoom('news', "GK & News Room"));
                            Navigator.push(context, route);
                          }

                          if (index == 7) {
                            Route route = MaterialPageRoute(builder: (context) => NewsRoom('storyTime', "Educational Stories"));
                            Navigator.push(context, route);
                          }


                        },
                        child: Container(
                          //color: colors[index],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 50,
                                width: 50,
                                child: Image.asset(
                                  carIcons[index],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5.0),
                                child: Center(
                                  child: Text(
                                    androidVersionNames[index],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black54,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
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

              Container(
                  margin: EdgeInsets.only(bottom: 10, top: 10),
                  child: Image.asset('assets/images/ic_launcher.png', width: 70,)
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 10),
                child: Text('AKSH Education System', textAlign: TextAlign.center, style: TextStyle( fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 10),
                child: Text('POWERED BY \n 21 century innovative solutions Pvt. Ltd.', textAlign: TextAlign.center, style: TextStyle( fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),),
              )

            ],
          ),
        ),
      ),
    );
  }
}
