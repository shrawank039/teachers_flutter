import 'package:flutter/material.dart';
import 'SubmitAssignment.dart';
import 'package:url_launcher/url_launcher.dart';
import '../ServerAPI.dart';

class ViewAssignments extends StatefulWidget {

  final String sutdentID;
  final String subjectID;
  final String subjectName;

  ViewAssignments( this.sutdentID, this.subjectID, this.subjectName);

  @override
  _ViewAssignmentsState createState() => _ViewAssignmentsState();
}

class _ViewAssignmentsState extends State<ViewAssignments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assignments for "+ widget.subjectName.toString()),
      ),
      body : FutureBuilder(
          future: _getIndividualAssignment(),
          builder: ( BuildContext context, snapshot ){
            var response = snapshot.data;
            if(response != null){
              return ListView.builder(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  itemCount: response.length,
                  itemBuilder: (BuildContext context, int index){
                    return Card(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                              leading: Image.asset('assets/images/subject.png',),
                              title: Text(response[index]['title'].toString(), style: TextStyle(fontWeight: FontWeight.bold),),
                              subtitle: Text(response[index]['subject_name'].toString()),
                              trailing: Text(response[index]['created_date'].toString()),
                           ),
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                            child: Text(response[index]['description'].toString()),
                          ),
                          Container(height: 1, decoration: BoxDecoration(color: Colors.black12),),
                          Padding(
                              padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
                            child: Row(
                              children: <Widget>[
                                FlatButton.icon(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.blueAccent)
                                    ),
                                    //color: Colors.blueAccent,
                                    textColor: Colors.blueAccent,
                                    onPressed: () async {
                                      await _openFile(response[index]['attachment'].toString());
                                    },
                                    icon: Icon(Icons.file_download),
                                    label: Text("Download")
                                ),
                                Spacer(),
                                assignmentWidget(response[index]),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  });
            } else {
              return Center(child: Text("Loading....", style: TextStyle(fontSize: 20),));
            }
          }
      ),
    );
  }

  Widget assignmentWidget(data){
    if(data["submission_status"].toString() == "done"){
      return FlatButton.icon(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.blueAccent)
          ),
          //color: Colors.blueAccent,
          textColor: Colors.blueAccent,
          onPressed: (){},
          icon: Icon(Icons.visibility),
          label: Text("Feedback")
      );
    } else {
      return FlatButton.icon(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.blueAccent)
          ),
          textColor: Colors.blueAccent,
          onPressed: () async {
            var student = await ServerAPI().getUserInfo();
            Route route = MaterialPageRoute(builder: (context) => SubmitAssignment(
                data["class_id"].toString(),
                student['id'].toString(),
                data["subject_id"].toString(),
                data["assignment_id"].toString(),
            ));
            await Navigator.push(context, route);
          },
          icon: Icon(Icons.file_upload),
          label: Text("Submit")
      );
    }
  }

  _openFile(url) async {
    await launch(url, enableJavaScript: true);
  }


  _getIndividualAssignment() async {
    final result = await ServerAPI().getIndividualAssignment(widget.sutdentID, widget.subjectID);
    if(result["data"].length > 0 ){
      return result["data"];
    }
  }

}
