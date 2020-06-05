import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Auth/Login.dart';
import '../CustomDrawer.dart';
import '../ServerAPI.dart';

void main() => runApp(MaterialApp(
      home: changePassword(),
    ));

class changePassword extends StatefulWidget {
  @override
  _changePasswordState createState() => _changePasswordState();
}

class _changePasswordState extends State<changePassword> {
  bool _obscureText = true;
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  String oldPassword = "";
  String newPassword = "";
  String confirmPassword = "";

  final GlobalKey<ScaffoldState> _scaffolkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffolkey,
        drawer: CustomDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Change Password'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20.0, left: 25.0, right: 25.0),
                child: Text(
                  'If you forget your old password then please contact your school for further assistance.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              oldPassword = value;
                            });
                          },
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.text,
                          obscureText: _obscureText1,
                          style: TextStyle(fontSize: 18),
                          maxLength: 10,
                          decoration: InputDecoration(
                            icon: Icon(Icons.vpn_key),
                            hintText: 'Old password',
                            counterText: "",
                            suffixIcon: IconButton(
                              color: Colors.grey,
                              icon: Icon(Icons.remove_red_eye),
                              onPressed: () {
                                setState(() {
                                  if (_obscureText1 == true) {
                                    _obscureText1 = false;
                                  } else {
                                    _obscureText1 = true;
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: 25,
                        ),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              newPassword = value;
                            });
                          },
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.text,
                          obscureText: _obscureText2,
                          style: TextStyle(fontSize: 18),
                          maxLength: 10,
                          decoration: InputDecoration(
                              icon: Icon(Icons.vpn_key),
                              hintText: 'New Password',
                              counterText: "",
                              suffixIcon: IconButton(
                                color: Colors.grey,
                                icon: Icon(Icons.remove_red_eye),
                                onPressed: () {
                                  setState(() {
                                    if (_obscureText2 == true) {
                                      _obscureText2 = false;
                                    } else {
                                      _obscureText2 = true;
                                    }
                                  });
                                },
                              )),
                        ),
                        Container(
                          height: 25,
                        ),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              confirmPassword = value;
                            });
                          },
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.text,
                          obscureText: _obscureText,
                          style: TextStyle(fontSize: 18),
                          maxLength: 10,
                          decoration: InputDecoration(
                            icon: Icon(Icons.vpn_key),
                            hintText: 'Confirm password',
                            counterText: "",
                            suffixIcon: IconButton(
                              color: Colors.grey,
                              icon: Icon(Icons.remove_red_eye),
                              onPressed: () {
                                setState(() {
                                  if (_obscureText == true) {
                                    _obscureText = false;
                                  } else {
                                    _obscureText = true;
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                    EdgeInsets.only(left: 0, top: 30, right: 0, bottom: 25),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 45.0,
                    child: RaisedButton(
                      child: Text('Confirm Change'),
                      color: Colors.green,
                      textColor: Colors.white,
                      shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      onPressed: _changePassword,
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          'Do you want to move to Sign In Page?',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0, bottom: 20),
                        child: InkWell(
                          onTap: () {
                            _moveToLogin();
                          },
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.teal[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Center(
                  child: Text(
                    'POWERED BY \n 21 century innovative solutions Pvt. Ltd.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _moveToLogin() async {
    await ServerAPI().logout();
    Route route = MaterialPageRoute(builder: (context) => Login());
    Navigator.pushReplacement(context, route);
  }

  _changePassword() async {
    if (oldPassword == "") {
      _scaffolkey.currentState
          .showSnackBar(ServerAPI.errorToast('Please enter old password'));
    } else if (newPassword == "") {
      _scaffolkey.currentState
          .showSnackBar(ServerAPI.errorToast('Please enter new password'));
    } else if (confirmPassword == "") {
      _scaffolkey.currentState
          .showSnackBar(ServerAPI.errorToast('Please enter confirm password'));
    } else if (newPassword != confirmPassword) {
      _scaffolkey.currentState
          .showSnackBar(ServerAPI.errorToast('Confirm password do not match'));
    } else {
      final result = await ServerAPI()
          .changePassword(oldPassword, newPassword, confirmPassword);

      if (result['status'] == "failure") {
        _scaffolkey.currentState
            .showSnackBar(ServerAPI.errorToast(result['msg'].toString()));
      } else {
        _scaffolkey.currentState
            .showSnackBar(ServerAPI.successToast(result['msg'].toString()));
        Future.delayed(Duration(seconds: 3), () {
          _moveToLogin();
        });
      }
    }
  }
}
