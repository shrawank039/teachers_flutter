import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../ServerAPI.dart';

class DownloadAttendance extends StatefulWidget {
  final String classID;
  final String subjectID;

  DownloadAttendance(this.classID, this.subjectID);

  @override
  _DownloadAttendanceState createState() => _DownloadAttendanceState();
}

class _DownloadAttendanceState extends State<DownloadAttendance> {
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
        title: Text("Download Attendance"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 15, right: 15),
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
                onPressed: download,
                child: Text(
                  "Download Attendance Sheet",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  download() async {
    var classID = widget.classID;
    var subjectID = widget.subjectID;
    await launch(
        "http://128.199.237.154/school_erp/classSubjectWiseStudentAtendenceXlsList?class_id=$classID&subject_id=$subjectID&month=$selectMonth&year=2020");
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
