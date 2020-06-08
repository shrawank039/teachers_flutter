import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Assignment/ViewAssignments.dart';

import '../Global.dart';
import '../ServerAPI.dart';

class Assignment extends StatelessWidget {
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
                            Route route = MaterialPageRoute(
                                builder: (context) => ViewAssignments(
                                    response[index]['class_id'].toString(),
                                    response[index]['subject_id'].toString(),
                                    response[index]['subject_name'].toString(),
                                    response[index]['class_name'].toString()));
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
