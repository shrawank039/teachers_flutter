import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Dashboard/Dashboard.dart';
import '../ServerAPI.dart';

class SubmitAssignment extends StatefulWidget {

  final String classID;
  final String studentID;
  final String subjectID;
  final String assignmentID;

  SubmitAssignment(this.classID, this.studentID, this.subjectID, this.assignmentID);

  @override
  _SubmitAssignmentState createState() => _SubmitAssignmentState();
}

class _SubmitAssignmentState extends State<SubmitAssignment> {

  final GlobalKey<ScaffoldState> _scaffolkey = GlobalKey<ScaffoldState>();
  String title = "";
  String description = "";
  String attachmentPath = "";

  var attachmentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffolkey,
      appBar: AppBar(
        title: Text("Submit Assignment"),
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 10, right: 10, top: 20),
        children: <Widget>[
            TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.keyboard),
              alignLabelWithHint: false,
              hintStyle: TextStyle(fontSize: 14.0),
              labelStyle: TextStyle(fontSize: 16.0),
              hintText: 'Title',
              labelText: 'Title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(),
              ),
            ),
            onChanged: (value){
              setState(() {
                title = value;
              });
            },
          ),
          Container(height: 15,),
          TextFormField(
            maxLines: 6,
            decoration: InputDecoration(
              alignLabelWithHint: false,
              hintStyle: TextStyle(fontSize: 14.0),
              labelStyle: TextStyle(fontSize: 16.0),
              hintText: 'Description',
              labelText: 'Description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(),
              ),
            ),
            onChanged: (value){
              description = value;
            },
          ),
          Row(
              children: <Widget>[
                Expanded(child: Container(
                  child: TextFormField(
                    controller: attachmentController,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'File',
                    ),
                  ),
                ),),
                FlatButton.icon(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.blueAccent)
                    ),
                    //color: Colors.blueAccent,
                    textColor: Colors.blueAccent,
                    onPressed: _attachFile,
                    icon: Icon(Icons.attachment),
                    label: Text("Attach File")
                )
              ],
          ),
          Container(height: 20,),
          Container(
            width: MediaQuery.of(context).size.width,
            child: FlatButton.icon(
              padding: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blueAccent)
                ),
                color: Colors.blueAccent,
                textColor: Colors.white,
                onPressed: _submitAssignment,
                icon: Icon(Icons.attachment),
                label: Text("Submit Assignment".toUpperCase(), style: TextStyle(fontSize: 20),)
            ),
          )

        ],
      ),
    );
  }

  _attachFile() async {
    var source = ImageSource.camera;
    var image = await ImagePicker.pickImage(source: source);
    setState(() {
      attachmentPath = image.path.toString();
    });
  }

  _submitAssignment() async {

    if(title == "") {
      _scaffolkey.currentState.showSnackBar(ServerAPI.errorToast('Please enter title'));
    } else if ( description == "") {
      _scaffolkey.currentState.showSnackBar(ServerAPI.errorToast('Please enter description'));
    } else {

      try {

        final result = await ServerAPI().submitAssignment({
          'class_id' : widget.classID,
          'student_id' : widget.studentID,
          'subject_id' : widget.subjectID,
          'title' : title,
          'description' : description,
          'assignment_id' : widget.assignmentID
        }, attachmentPath);

        if(result["status"] == "success"){
          Route route = MaterialPageRoute(builder: (context) => Dashboard());
          await Navigator.pushReplacement(context, route);
        } else {
          _scaffolkey.currentState.showSnackBar(ServerAPI.errorToast(result['msg'].toString()));
        }

      } catch (e ) {
        _scaffolkey.currentState.showSnackBar(ServerAPI.errorToast(e.toString()));
      }

    }

  }

}
