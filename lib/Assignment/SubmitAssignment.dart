import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Dashboard/Dashboard.dart';
import '../ServerAPI.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  String deadline = "";

  bool isSubmitted = false;

  var attachmentController = TextEditingController();
  var deadlineController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffolkey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Submit Assignment"),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: ListView(
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
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
            ),
            Container(
              height: 15,
            ),
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
              onChanged: (value) {
                description = value;
              },
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: TextFormField(
                      controller: attachmentController,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'File',
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _attachFile('camera');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10, top: 20),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.green,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _attachFile('gallery');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Icon(Icons.attach_file, color: Colors.green),
                  ),
                ),
              ],
            ),
            Container(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    enabled: false,
                    controller: deadlineController,
                    decoration: InputDecoration(
                      alignLabelWithHint: false,
                      hintStyle: TextStyle(fontSize: 14.0),
                      labelStyle: TextStyle(fontSize: 16.0),
                      hintText: 'Deadline',
                      labelText: 'Deadline',
                    ),
                    onChanged: (value) {
                      setState(() {
                        title = value;
                      });
                    },
                  ),
                ),
                GestureDetector(
                  onTap: _selectDate,
                  child: Padding(
                    padding: EdgeInsets.only(top: 15),
                    child:
                        Icon(Icons.date_range, size: 35, color: Colors.green),
                  ),
                )
              ],
            ),
            Container(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: FlatButton.icon(

                  padding: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: Colors.green)),
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: _submitAssignment,
                  icon: Icon(Icons.attachment),
                  label: Text(
                    "Submit Assignment".toUpperCase(),
                    style: TextStyle(fontSize: 15),
                  )),
            )
          ],
        ),
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

  _selectDate() async {
    var selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      firstDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(
          DateTime.now().year, DateTime.now().month + 3, DateTime.now().day),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
              primaryColor: Colors.red,
              accentColor: Colors.red,
              buttonColor: Colors.red),
          child: child,
        );
      },
    );

    String date = selectedDate.year.toString() +
        "-" +
        selectedDate.month.toString() +
        "-" +
        selectedDate.day.toString();
    setState(() {
      deadline = date;
      deadlineController.text = date;
    });
  }

  _submitAssignment() async {
    if (title == "") {
      _scaffolkey.currentState
          .showSnackBar(ServerAPI.errorToast('Please enter title'));
    } else if (description == "") {
      _scaffolkey.currentState
          .showSnackBar(ServerAPI.errorToast('Please enter description'));
    } else if (deadline == "") {
      _scaffolkey.currentState.showSnackBar(
          ServerAPI.errorToast('Please select submission deadline'));
    } else {
      try {
        var me = await ServerAPI().getUserInfo();
        var result;
        if (attachmentPath == null) {
          result = await ServerAPI().submitAssignmentWithoutAttachment({
            'teacher_id': me['id'].toString(),
            'class_id': widget.classID,
            'subject_id': widget.subjectID,
            'title': title,
            'description': description,
            'last_submission_date': deadline
          });
        } else {
          result = await ServerAPI().submitAssignment({
            'teacher_id': me['id'].toString(),
            'class_id': widget.classID,
            'subject_id': widget.subjectID,
            'title': title,
            'description': description,
            'last_submission_date': deadline
          }, attachmentPath);
        }

        if (result["status"] == "success") {
          Fluttertoast.showToast(
              msg: "Assignment Submitted successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);

          Navigator.pop(context);

        } else {
          _scaffolkey.currentState
              .showSnackBar(ServerAPI.errorToast(result['msg'].toString()));
        }
      } catch (e) {
        _scaffolkey.currentState
            .showSnackBar(ServerAPI.errorToast(e.toString()));
      }
    }
  }
}
