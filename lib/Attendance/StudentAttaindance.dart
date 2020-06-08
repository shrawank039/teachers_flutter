import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Global.dart';
import '../ServerAPI.dart';
import 'AttendanceList.dart';
import 'DownloadAttendance.dart';
import 'StudentWiseAttendance.dart';

class StudentAttaindance extends StatefulWidget {
  @override
  _StudentAttaindanceState createState() => _StudentAttaindanceState();
}

class _StudentAttaindanceState extends State<StudentAttaindance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
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

                      showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext cupertinoContext) {
                            return CupertinoActionSheet(
                              title: Text('Attendance Option'),
                              cancelButton: CupertinoActionSheetAction(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.pop(cupertinoContext);
                                },
                              ),
                              actions: <Widget>[
                                CupertinoActionSheetAction(
                                  child: Text('Date Wise Attendance Report'),
                                  onPressed: () {
                                    Route route = MaterialPageRoute(
                                        builder: (context) => AttendanceList(
                                            response[index]['class_id']
                                                .toString(),
                                            response[index]['subject_id']
                                                .toString()));
                                    Navigator.push(context, route);
                                    Navigator.pop(cupertinoContext);
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: Text('Student Wise Attendance Report'),
                                  onPressed: () {
                                    Route route = MaterialPageRoute(
                                        builder: (context) =>
                                            StudentWiseAttendance(
                                                response[index]['class_id']
                                                    .toString(),
                                                response[index]['subject_id']
                                                    .toString()));
                                    Navigator.push(context, route);
                                    Navigator.pop(cupertinoContext);
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: Text('Download Monthly Attendance'),
                                  onPressed: () {
                                    Route route = MaterialPageRoute(
                                        builder: (context) =>
                                            DownloadAttendance(
                                                response[index]['class_id']
                                                    .toString(),
                                                response[index]['subject_id']
                                                    .toString()));
                                    Navigator.push(context, route);
                                    Navigator.pop(cupertinoContext);
                                  },
                                )
                              ],
                            );
                          });
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
              return Center(child: Global.spinkitCircle);
            }
          }),
    );
  }

  _getClassWiseSubjectList() async {
    final result = await ServerAPI().calssWiseSubjectList();
    return result["data"];
  }
}
