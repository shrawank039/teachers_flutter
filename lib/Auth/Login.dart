import 'package:flutter/material.dart';
import '../Dashboard/Dashboard.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../ServerAPI.dart';

void main() {
  runApp(Login());
}

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final GlobalKey<ScaffoldState> _scaffolkey = GlobalKey<ScaffoldState>();

  var username = "";
  var password = "";
  int showLoader = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffolkey,
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              padding: EdgeInsets.only(left: 15, right: 15, top: 150),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Image.asset("assets/images/school.jpg"),
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(height: 50,),
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Username',
                        ),
                        onChanged: (value){
                          setState(() {
                            username = value;
                          });
                        },
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    margin: EdgeInsets.only(top: 20,),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                        ),
                        onChanged: (value){
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  SizedBox(height: 25,),

                  SizedBox(
                    width: double.infinity,
                    height: 45.0,
                    child: RaisedButton(
                      elevation: 5,
                      textColor: Colors.white,
                      child: Text("Login", style: TextStyle(fontSize: 22),),
                      color: Colors.lightBlue[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onPressed: _authCheck,
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
    );
  }

  _isLogin() async {
    if(await ServerAPI().isLogin()){
      print("login");
      Route route = MaterialPageRoute(builder: (context) => Dashboard());
      Navigator.pushReplacement(context, route);
    } else {
      print("not login");
    }
  }

  _authCheck() async {

    if(username == "") {
      _scaffolkey.currentState.showSnackBar(ServerAPI.errorToast('Please enter username'));
    } else if ( password == "") {
      _scaffolkey.currentState.showSnackBar(ServerAPI.errorToast('Please enter password'));
    } else {

      try {

        final result = await ServerAPI().authRequest({
          "username" : username,
          "password" : password,
          "role" : 3.toString()
        });

        if( result["status"] == "success"){

          // Store Data in local storage
          await ServerAPI().setAuthUser(result["data"]);

          // Update device id
          var status = await OneSignal.shared.getPermissionSubscriptionState();
          var playerId = status.subscriptionStatus.userId;
          await ServerAPI().updateDeviceID({
            "student_id" : result["data"]["id"].toString(),
            "device_id" : playerId.toString()
          });

          // Navigate to Dashboard
          Route route = MaterialPageRoute(builder: (context) => Dashboard());
          Navigator.pushReplacement(context, route);

        } else {
          _scaffolkey.currentState.showSnackBar(ServerAPI.errorToast(result["msg"].toString()));
        }

      } catch(e) {
        print(e.toString());
      }

    }
  }
}
