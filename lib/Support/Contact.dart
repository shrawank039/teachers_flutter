import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../ServerAPI.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {

  List<String> text = [
    'I have not shared my password with anyone.',
    'I am responsible for the content typed in query.',
    'I understand that necessary disciplinary action will be taken against me in case of '
        'use of derogarory words or false statement.'
  ];

  String title ="";
  String description = "";

  final GlobalKey<ScaffoldState> _scaffolkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffolkey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Administrative Query'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(20.0),
                height: 100.0,
                width: 120.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/school.jpg'),
                  ),
                ),
              ),
              Card(
                elevation: 5.0,
                margin: EdgeInsets.all(10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.zero),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextField(
                    onChanged: (value){
                      setState(() {
                        title = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Reason for Query',
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 5.0,
                margin: EdgeInsets.all(10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.zero),
                ),
                child: TextField(
                  onChanged: (value){
                    setState(() {
                      description = value;
                    });
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  maxLength: 200,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Your Query...',
                    counterText: '200',
                    contentPadding: EdgeInsets.all(10.0),
                  ),
                ),
              ),

              Column(
                children: <Widget>[
                  Container(
                    child: Container(
                      child: Column(
                        children: text
                            .map((t) => CheckboxListTile(
                            title: Text(t),
                            value: true,
                            onChanged: (bool value) {},
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ).toList(),
                      ),
                    ),
                  ),
                ],
              ),


              Container(
                margin: EdgeInsets.only(left: 10, top: 20, right: 10),
                width: double.infinity,
                height: 45.0,
                child: RaisedButton(
                  elevation: 5,
                  color: Colors.green[700],
                  child: Text(
                    "Submit Query",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  onPressed: _submitQuery,
                ),
              ),
              Container(height: 70,)
            ],
          ),
        ),
      ),
    );
  }

  _submitQuery() async {
    if(title == ""){
      _scaffolkey.currentState.showSnackBar(ServerAPI.errorToast('Please enter title'));
    } else if( description == "") {
      _scaffolkey.currentState.showSnackBar(ServerAPI.errorToast('Please enter description'));
    } else {
      final result = await ServerAPI().contactQuery({
        "title" : title,
        "description" : description,
        "usertype" : "teacher"
      });
      if(result['status'] == "success") {
        Fluttertoast.showToast(msg: "Query Submitted successfully", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, backgroundColor: Colors.green, textColor: Colors.white, fontSize: 16.0);
        Navigator.pop(context);
      } else {
        _scaffolkey.currentState.showSnackBar(ServerAPI.errorToast(result['msg'].toString()));
      }
    }
  }

}
