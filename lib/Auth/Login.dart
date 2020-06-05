import 'package:flutter/material.dart';
import '../Dashboard/Dashboard.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../ServerAPI.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffolkey = GlobalKey<ScaffoldState>();

  var username = "";
  var password = "";
  int showLoader = 0;
  bool _obscureText = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _isLogin();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffolkey,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SingleChildScrollView(
            padding: EdgeInsets.only(left: 15, right: 15, top: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Image.asset("assets/images/login.jpg"),
                  width: 200,
                  height: 150,
                ),
                Text(
                  "Teacher Sign in".toUpperCase(),
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.supervised_user_circle),
                    hintText: 'Username',
                  ),
                  onChanged: (value) {
                    setState(
                      () {
                        username = value;
                      },
                    );
                  },
                ),
                SizedBox(height: 25),
                TextField(
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    icon: Icon(Icons.vpn_key),
                    hintText: 'Password',
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
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45.0,
                  child: RaisedButton(
                    elevation: 5,
                    textColor: Colors.white,
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 22),
                    ),
                    color: Colors.lightBlue[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onPressed: _authCheck,
                  ),
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
        ],
      ),
    );
  }

//  _isLogin() async {
//    if (await ServerAPI().isLogin()) {
//      print("login");
//      Route route = MaterialPageRoute(builder: (context) => Dashboard());
//      Navigator.pushReplacement(context, route);
//    } else {
//      print("not login");
//    }
//  }

  _authCheck() async {
    if (username == "") {
      _scaffolkey.currentState
          .showSnackBar(ServerAPI.errorToast('Please enter username'));
    } else if (password == "") {
      _scaffolkey.currentState
          .showSnackBar(ServerAPI.errorToast('Please enter password'));
    } else {
      try {
        final result = await ServerAPI().authRequest(
            {"username": username, "password": password, "role": 3.toString()});

        if (result["status"] == "success") {
          // Store Data in local storage
          await ServerAPI().setAuthUser(result["data"]);

          // Update device id
          var status = await OneSignal.shared.getPermissionSubscriptionState();
          var playerId = status.subscriptionStatus.userId;
          await ServerAPI().updateDeviceID({
            "student_id": result["data"]["id"].toString(),
            "device_id": playerId.toString()
          });

          // Navigate to Dashboard
          Route route = MaterialPageRoute(builder: (context) => Dashboard());
          Navigator.pushReplacement(context, route);
        } else {
          _scaffolkey.currentState
              .showSnackBar(ServerAPI.errorToast(result["msg"].toString()));
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
