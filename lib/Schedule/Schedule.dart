import 'package:flutter/material.dart';
import '../Global.dart';
import '../ServerAPI.dart';
import '../CustomDrawer.dart';

class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  List subjectList = [];
  bool isFirst = true;
  String selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text("Time Table"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: _weeklyScheduleClass(),
            builder: (BuildContext context, snapshot) {
              var response = snapshot.data;
              if (response != null) {
                var keyName = [];
                response.forEach((key, value) {
                  keyName.add(key);
                });
                return Column(
                  children: <Widget>[
                    // Dropdown
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Container(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        margin: EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 10, bottom: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black26),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selected,
                            hint: Text('Select Day'),
                            items: keyName.map((item) {
                              return DropdownMenuItem<String>(
                                value: item.toString(),
                                child: Text(item.toString()),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selected = value;
                                subjectList = response[value];
                              });
                            },
                          ),
                        ),
                      ),
                    ),

                    scheduleList()
                  ],
                );
              } else {
                return Center(child: Global.spinkitCircle);
              }
            }),
      ),
    );
  }

  Widget scheduleList() {
    if (subjectList == null || subjectList == [] || subjectList == "") {
      return Center(
        child: Text("No Records Found".toUpperCase()),
      );
    } else {
      return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          itemCount: subjectList.length,
          itemBuilder: (BuildContext context, int subIndex) {
            return Card(
              child: ListTile(
                title: Text(
                  subjectList[subIndex]['subject_name'].toString(),
                  style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                ),
                subtitle: Text(
                  subjectList[subIndex]['class_name'].toString(),
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Text(
                    "Time : \n" + subjectList[subIndex]['timeslot'].toString(),
                    style: TextStyle(fontSize: 18)),
              ),
            );
          });
    }
  }

  _weeklyScheduleClass() async {
    final result = await ServerAPI().weeklyScheduleClass();
    if (isFirst) {
      var keyName = [];
      result['data'].forEach((key, value) {
        keyName.add(key);
      });
      setState(() {
        selected = keyName[0];
        subjectList = result['data'][keyName[0]];
        isFirst = false;
      });
    }
    return result['data'];
  }
}
