import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ServerAPI.dart';

class StudentWiseAttendance extends StatefulWidget {
  final String classID;
  final String subjectID;

  StudentWiseAttendance(this.classID, this.subjectID);

  @override
  _StudentWiseAttendanceState createState() => _StudentWiseAttendanceState();
}

class _StudentWiseAttendanceState extends State<StudentWiseAttendance> {
  String absent = '0';
  String present = '0';

  List attendance = [];
  List studentList = [];
  List month = [
    {"name": 'January', "value": '01'},
    {"name": 'February', "value": '02'},
    {"name": 'March', "value": '03'},
    {"name": 'April', "value": '04'},
    {"name": 'May', "value": '05'},
    {"name": 'June', "value": '06'},
    {"name": 'July', "value": '07'},
    {"name": 'August', "value": '08'},
    {"name": 'September', "value": '09'},
    {"name": 'October', "value": '10'},
    {"name": 'November', "value": '11'},
    {"name": 'December', "value": '12'},
  ];
  String student = "9";
  String selectMonth = "05";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getStudentList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Student Wise Attendance"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    child: DropdownButton<String>(
                  isExpanded: true,
                  value: student,
                  hint: Text('Select Student'),
                  items: studentList.map((item) {
                    return DropdownMenuItem<String>(
                      value: item['id'].toString(),
                      child: Text(item['student_name'].toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      student = value.toString();
                    });
                  },
                )),
                Expanded(
                    child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectMonth,
                  hint: Text('Select Month'),
                  items: month.map((item) {
                    return DropdownMenuItem<String>(
                      value: item['value'].toString(),
                      child: Text(item['name'].toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectMonth = value.toString();
                    });
                  },
                ))
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 5, bottom: 5),
              child: FlatButton(
                onPressed: _attendanceList,
                child: Text(
                  "Search",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.green,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 7.0),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Present',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.black54,
                        ),
                      ),
                      Container(
                        color: Colors.green,
                        margin: EdgeInsets.all(5.0),
                        padding: EdgeInsets.all(7.0),
                        child: Text(
                          present,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Absent',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.black54,
                        ),
                      ),
                      Container(
                        color: Colors.red,
                        margin: EdgeInsets.all(5.0),
                        padding: EdgeInsets.all(7.0),
                        child: Text(
                          absent,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 15,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: attendance.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {},
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              attendance[index]['date'].toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              getStatus(attendance[index]['status']),
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
            ),
          ],
        ),
      ),
    );
  }

  getStatus(status) {
    if (status == 1) {
      return "P";
    }
    return "A";
  }

  _attendanceList() async {
    final result = await ServerAPI().classSubjectWiseStudentAtendenceList(
        student, widget.classID, widget.subjectID, selectMonth, "2020");
    setState(() {
      attendance = result["data"];
    });
    _updatePresentCount(result["data"]);
    _updateAbsentCount(result["data"]);
  }

  _updatePresentCount(data) {
    int count = 0;
    for (var i = 0; i < data.length; i++) {
      if (data[i]['status'] == 1) {
        count = count + 1;
      }
    }
    setState(() {
      present = count.toString();
    });
  }

  _updateAbsentCount(data) {
    int count = 0;
    for (var i = 0; i < data.length; i++) {
      if (data[i]['status'] == 0) {
        count = count + 1;
      }
    }
    print(count);
    print(data.length);
    setState(() {
      absent = count.toString();
    });
  }

  _getStudentList() async {
    final result = await ServerAPI()
        .individualChatRoomList(widget.classID, widget.subjectID);
    setState(() {
      student = result["data"][0]['id'].toString();
      studentList = result["data"];
    });
  }
}
