import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Dashboard/Dashboard.dart';
import '../ServerAPI.dart';

class SubmitAssignment extends StatefulWidget {

  final String classID;
  final String subjectID;

  SubmitAssignment(this.classID, this.subjectID);

  @override
  _SubmitAssignmentState createState() => _SubmitAssignmentState();
}

class _SubmitAssignmentState extends State<SubmitAssignment> {

  final GlobalKey<ScaffoldState> _scaffolkey = GlobalKey<ScaffoldState>();
  String title = "";
  String description = "";
  var attachmentPath;

  var attachmentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffolkey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
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

                GestureDetector(
                  onTap: (){
                    _attachFile('camera');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10, top: 20),
                    child: Icon(Icons.camera_alt, color: Colors.blueGrey,),
                  ),
                ),

                GestureDetector(
                  onTap: (){
                    _attachFile('gallery');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Icon(Icons.attach_file, color: Colors.blueGrey),
                  ),
                ),
              ],
          ),
          Container(height: 20,),
          Container(
            width: MediaQuery.of(context).size.width,
            child: FlatButton.icon(
              padding: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: Colors.blueGrey)
                ),
                color: Colors.blueGrey,
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

  _attachFile(type) async {
    var image;
    var source = ImageSource.camera;
    if (type == "gallery") {
      image = await FilePicker.getFile(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'pdf', 'doc', 'docx'],
      );
    } else {
      image = await ImagePicker.pickImage(source: source);
    }
    setState(() {
      attachmentController.text = image.toString();
      attachmentPath = image.path;
    });
  }

  _submitAssignment() async {

    if(title == "") {
      _scaffolkey.currentState.showSnackBar(ServerAPI.errorToast('Please enter title'));
    } else if ( description == "") {
      _scaffolkey.currentState.showSnackBar(ServerAPI.errorToast('Please enter description'));
    } else {

      try {
        var me = await ServerAPI().getUserInfo();
        final result = await ServerAPI().submitAssignment({
          'teacher_id' : me['id'].toString(),
          'class_id' : widget.classID,
          'subject_id' : widget.subjectID,
          'title' : title,
          'description' : description,
        }, attachmentPath);

        if(result["status"] == "success"){
          Navigator.pop(context);
        } else {
          _scaffolkey.currentState.showSnackBar(ServerAPI.errorToast(result['msg'].toString()));
        }

      } catch (e ) {
        _scaffolkey.currentState.showSnackBar(ServerAPI.errorToast(e.toString()));
      }

    }

  }

}
