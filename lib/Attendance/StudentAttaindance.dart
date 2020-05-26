import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:teachers/Fragments/TeachersList.dart';

import '../ServerAPI.dart';
import 'AttendanceList.dart';

class StudentAttaindance extends StatefulWidget {
  @override
  _StudentAttaindanceState createState() => _StudentAttaindanceState();
}

class _StudentAttaindanceState extends State<StudentAttaindance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Choose Class'),
      ),
      body: FutureBuilder(
          future: _getClassWiseSubjectList(),
          builder: (BuildContext context, snapshot) {
            var response = snapshot.data;
            if (response != null) {
              return ListView.builder(
                itemCount: response.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {
                      var student = await ServerAPI().getUserInfo();
                      Route route = MaterialPageRoute(
                          builder: (context) => AttendanceList(
                              response[index]['class_id'].toString(),
                              response[index]['subject_id'].toString()));
                      await Navigator.push(context, route);
                    },
                    child: Card(
                      margin: EdgeInsets.all(10.0),
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Text(
                                response[index]['subject_name'].toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                response[index]['class_name'].toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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

//  void showToast(message) {
//    Fluttertoast.showToast(
//        msg: message,
//        toastLength: Toast.LENGTH_SHORT,
//        gravity: ToastGravity.BOTTOM,
//        timeInSecForIos: 1,
//        backgroundColor: Colors.red,
//        textColor: Colors.white,
//        fontSize: 16.0);
//  }

  _getClassWiseSubjectList() async {
    final result = await ServerAPI().calssWiseSubjectList();
    print(result);
    return result["data"];
  }
}
