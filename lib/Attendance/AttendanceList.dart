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
  String date = "2020-05-20";
  int a = 0;
  int p = 0;
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
//    a = 0;
//    p = 0;
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
  }

  var appBar = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    p = p;
    a = a;
  }

  @override
  Widget build(BuildContext context) {
    String att = "";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
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
                        child: Text(
                          p.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
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
                        child: Text(
                          a.toString(),
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
              margin: EdgeInsets.only(top: 10.0),
              width: double.infinity,
              height: MediaQuery.of(context).size.height - 220,
              child: FutureBuilder(
                future: _AttendanceList(),
                builder: (BuildContext context, snapshot) {
                  var response = snapshot.data;
                  p = 0;
                  a = 0;
                  if (response != null) {
                    return ListView.builder(
                      itemCount: response.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (response[index]['status'].toString() == "1") {
                          p = p + 1;
                          att = "P";
                        } else {
                          att = "A";
                          a = a + 1;
                        }
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              p = p;
                              a = a;
                            });
                          },
                          child: Card(
                            margin: EdgeInsets.all(10.0),
                            child: Container(
                              padding: EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      response[index]['student_name']
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _AttendanceList() async {
    print("_AttendanceList");
    final result = await ServerAPI().calssWiseStudentAttendanceList(date, widget.class_id);
    return result["data"];
  }
}
