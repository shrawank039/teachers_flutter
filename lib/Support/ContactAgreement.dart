import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teachers/CustomDrawer.dart';
import '../ServerAPI.dart';
import 'Contact.dart';

class ContactAgreement extends StatelessWidget {
  List<String> text = [
    'I have not shared my password with anyone.',
    'I am responsible for the content typed in query.',
    'I understand that necessary disciplinary action will be taken against me in case of '
        'use of derogarory words or false statement.'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Contact Agreement'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.grey[200],
            child: Container(
              padding: EdgeInsets.only(top: 30, bottom: 30.0),
              margin:
                  EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 50.0),
              color: Colors.white,
              child: Column(
                children: text
                    .map(
                      (t) => CheckboxListTile(
                        title: Text(t),
                        value: true,
                        onChanged: (bool value) {},
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Container(
            color: Colors.grey[200],
            margin: EdgeInsets.only(left: 20, top: 20, right: 20),
            width: double.infinity,
            height: 40.0,
            child: RaisedButton(
              color: Colors.green,
              child: Text(
                "I agree",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.0),
              ),
              onPressed: () async {
                await ServerAPI().addSupport();
                Route route =
                MaterialPageRoute(builder: (context) => Contact());
                Navigator.push(context, route);
              },
            ),
          ),
        ],
      ),
    );
  }
}
