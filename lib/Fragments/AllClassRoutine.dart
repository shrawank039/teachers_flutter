import 'package:flutter/material.dart';
import '../Global.dart';
import 'TeachersList.dart';
import '../ServerAPI.dart';

class AllClassRoutine extends StatefulWidget {
  @override
  _AllClassRoutineState createState() => _AllClassRoutineState();
}

class _AllClassRoutineState extends State<AllClassRoutine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _getClassWiseSubjectList(),
          builder: (BuildContext context, snapshot) {
            var response = snapshot.data;
            if (response != null) {
              return ListView.builder(
                  itemCount: response.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          onTap: () async {
                            var student = await ServerAPI().getUserInfo();
                            Route route = MaterialPageRoute(
                                builder: (context) => TeachersList(
                                    response[index]['class_id'].toString(),
                                    response[index]['subject_id'].toString()));
                            await Navigator.push(context, route);
                          },
                          leading: Image.asset(
                            'assets/images/subject.png',
                          ),
                          title: Text(
                            response[index]['subject_name'].toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle:
                              Text(response[index]['class_name'].toString()),
                        ),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: Colors.black12),
                        )
                      ],
                    );
                  });
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
