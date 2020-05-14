import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(HomeworkSubmit());
}

class HomeworkSubmit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Assignment'),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(
                    left: 10, right: 10.0, top: 30.0, bottom: 30),
                child: Text(
                  'Please choose the correct file to upload. \nOnly .pdf and .ppt files are allowed.',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700]),
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
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Title',
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'File name',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          debugPrint('222');
                        },
                      ),
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
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Description',
                    contentPadding: EdgeInsets.all(10.0),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, top: 20, right: 10),
                width: double.infinity,
                height: 45.0,
                child: RaisedButton(
                  elevation: 5,
                  color: Colors.blue[700],
                  child: Text(
                    "Upload",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
