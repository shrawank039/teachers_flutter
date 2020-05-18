import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teachers/Profile/Profile.dart';
import 'package:teachers/Screens/ContactAgreement.dart';
import 'package:teachers/ServerAPI.dart';
import '../Fragments/TabIndex.dart';
import '../Schedule/Schedule.dart';
import '../Announcement/Announcement.dart';

class Dashboard extends StatefulWidget {

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  String schoolName = "";

  final androidVersionNames = [
    'Schedule',
    'Announcement',
    'Class Room',
    'Support',
    'Profile'
  ];

  final carIcons = [
    'assets/images/schedule.png',
    'assets/images/announcement.png',
    'assets/images/chat.png',
    'assets/images/suppoert0.png',
    'assets/images/profile.png'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Dashboard"),
        ),
        body: Stack(
          children: <Widget>[
            Positioned(
              bottom: 20,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Center(child: Text(schoolName.toString(), style: TextStyle(fontSize: 20),)),
              ),
            ),
            Container(
              child: GridView.builder(
                itemCount: carIcons.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.all(15.0),
                    child: Card(
                      child: GestureDetector(
                        onTap: () {

                          if(index == 2 ){
                            Route route = MaterialPageRoute(builder: (context) => TabIndex());
                            Navigator.push(context, route);
                          }

                          if(index == 0 ){
                            Route route = MaterialPageRoute(builder: (context) => Schedule());
                            Navigator.push(context, route);
                          }

                          if(index == 1 ){
                            Route route = MaterialPageRoute(builder: (context) => Announcement());
                            Navigator.push(context, route);
                          }

                          if(index == 3 ){
                            Route route = MaterialPageRoute(builder: (context) => ContactAgreement());
                            Navigator.push(context, route);
                          }

                          if(index == 4 ){
                            Route route = MaterialPageRoute(builder: (context) => Profile());
                            Navigator.push(context, route);
                          }

                        },
                        child: Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 15, top: 15),
                                  child: Text(
                                    androidVersionNames[index],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 50, top: 15),
                                  height: 90,
                                  width: 90,
                                  child: Image.asset(
                                    carIcons[index],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getProfile() async {
    final result = await ServerAPI().getUserInfo();
    print(result);
    setState(() {
      schoolName = result['school_name'].toString();
    });

  }


}