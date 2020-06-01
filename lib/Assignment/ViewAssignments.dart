import 'package:flutter/material.dart';
import 'SubmitAssignment.dart';
import 'package:url_launcher/url_launcher.dart';
import '../ServerAPI.dart';

class ViewAssignments extends StatefulWidget {

  final String classID;
  final String subjectID;
  final String subjectName;
  final String className;

  ViewAssignments( this.classID, this.subjectID, this.subjectName, this.className);

  @override
  _ViewAssignmentsState createState() => _ViewAssignmentsState();
}

class _ViewAssignmentsState extends State<ViewAssignments> {

  @override
  Widget build(BuildContext context) {

    String pageTitle = "Assignments for\n"+widget.subjectName.toString()+", "+widget.className.toString();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(pageTitle, style: TextStyle(color: Colors.white, fontSize: 15), textAlign: TextAlign.left,),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              Route route = MaterialPageRoute(builder: (context) => SubmitAssignment(widget.classID, widget.subjectID));
              await Navigator.push(context, route);
              setState(() {});
            },
          ),
        ],
      ),
      body : FutureBuilder(
          future: _getIndividualAssignment(),
          builder: ( BuildContext context, snapshot ){
            var response = snapshot.data;
            if(response != null){

              if(response.length < 1) {
                return Center(child: Text("No Data Found", style: TextStyle(fontSize: 20),));
              } else {
                return ListView.builder(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    itemCount: response.length,
                    itemBuilder: (BuildContext context, int index){
                      var deadline = response[index]['last_submission_date'].toString() == "null" ? "" : response[index]['last_submission_date'].toString();
                      return Card(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(response[index]['title'].toString(), style: TextStyle(fontWeight: FontWeight.bold),),
                              subtitle: Text(response[index]['created_date'].toString()),
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
                                      textColor: Colors.blueAccent,
                                      onPressed: () async {
                                        await _openFile(response[index]['attachment'].toString());
                                      },
                                      icon: Icon(Icons.file_download),
                                      label: Text("Download")
                                  ),
                                  Spacer(),
                                  Container(
                                    child: Text("Deadline : "+ deadline, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    });
              }
            } else {
              return Center(child: Text("Loading....", style: TextStyle(fontSize: 20),));
            }
          }
      ),
    );
  }

  _openFile(url) async {
    await launch(url, enableJavaScript: true);
  }


  _getIndividualAssignment() async {
    final result = await ServerAPI().getIndividualAssignment(widget.classID, widget.subjectID);
    return result["data"];
  }

}
