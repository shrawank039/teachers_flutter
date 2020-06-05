import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teachers/CustomDrawer.dart';
import '../Auth/Login.dart';

import '../ServerAPI.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () async {
              await ServerAPI().logout();
              Route route = MaterialPageRoute(builder: (context) => Login());
              Navigator.pushReplacement(context, route);
            },
          ),
        ],
      ),
      body: FutureBuilder(
          future: getProfile(),
          builder: (BuildContext context, snapshot) {
            var response = snapshot.data;
            if (response != null) {
              return SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
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
                        margin:
                            EdgeInsets.only(top: 20.0, left: 30.0, bottom: 20),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(
                                'Teacher Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 3),
                              child: Text(response["teacher_name"].toString()),
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
                              child: Text(response["teacher_phone"].toString()),
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
                              child: Text(response["teacher_email"].toString()),
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
                              child: Text(response["teacher_dob"].toString()),
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
                              child:
                                  Text(response["teacher_gender"].toString()),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Address',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 3),
                              child:
                                  Text(response["teacher_address"].toString()),
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
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                  child: Text(
                "Loading....",
                style: TextStyle(fontSize: 20),
              ));
            }
          }),
    );
  }

  getProfile() async {
    final result = await ServerAPI().getProfile();
    return result['data'][0];
  }
}
