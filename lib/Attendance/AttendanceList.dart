import 'package:flutter/material.dart';
import '../IndividualChat/IndividualChat.dart';
import '../ServerAPI.dart';

class AttendanceList extends StatefulWidget {
  final String class_id;
  final String subject_id;

  AttendanceList(this.class_id, this.subject_id);

  @override
  _AttendanceListState createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  String date = "${DateTime.now().toLocal()}".split(' ')[0];
  DateTime selectedDate = DateTime.now();
  String absent = '0';
  String present = '0';
  List attendance = [];

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
    date = "${selectedDate.toLocal()}".split(' ')[0];
    _attendanceList();
  }

  var appBar = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _attendanceList();
  }

  @override
  Widget build(BuildContext context) {
    String att = "";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Student Attendance"),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10.0),
              width: 148.0,
              child: RaisedButton(
                color: Colors.blue[300],
                onPressed: () => _selectDate(context),
                textColor: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        date,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                      size: 30,
                    ),
                  ],
                ),
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
                        child: Text(present, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.white,),),
                      )
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
                        child: Text(absent, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.white,),),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              width: double.infinity,
              height: MediaQuery.of(context).size.height - 220,
              child: ListView.builder(
                itemCount: attendance.length,
                itemBuilder: (BuildContext context, int index) {
                  if(attendance[index]["attendence"] == 0) {
                    att = "A";
                  } else {
                    att = "P";
                  }
                  return Card(
                    margin: EdgeInsets.all(10.0),
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              attendance[index]['student_name']
                                  .toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              att,
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _updatePresentCount(data) {
    int count = 0;
    for (var i = 0; i < data.length; i++) {
      if (data[i]['attendence'] == 1) {
        count = count + 1;
      }
    }
    setState(() {
      present = count.toString();
    });
    print(present);
  }

  _updateAbsentCount(data) {
    int count = 0;
    for (var i = 0; i < data.length; i++) {
      if (data[i]['attendence'] == 0) {
        count = count + 1;
      }
    }
    setState(() {
      absent = count.toString();
    });
    print(absent);
  }

  _attendanceList() async {
    final result = await ServerAPI().calssWiseStudentAttendanceList(date, widget.class_id, widget.subject_id);
    print(result);
    _updatePresentCount(result["data"]);
    _updateAbsentCount(result["data"]);
    setState(() {
      attendance = result["data"];
    });
  }

}
