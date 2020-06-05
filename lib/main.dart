import 'package:flutter/material.dart';
import 'Auth/Login.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'Dashboard/Dashboard.dart';
import 'ServerAPI.dart';

void main() {
  runApp(MyApp());
  OneSignal.shared.init("0ff4329e-5eda-4e47-8de0-0e4f05fb6f50");
  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLogin();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: Colors.green,
        primaryColor: Colors.white,
        primaryColorDark: Colors.white,
        fontFamily: 'Montserrat Regularr',
      ),
      home: Login(),
    );
  }

  _isLogin() async {
    if (await ServerAPI().isLogin()) {
      print("login");
      Route route = MaterialPageRoute(builder: (context) => Dashboard());
      Navigator.pushReplacement(context, route);
    } else {
      print("not login");
    }
  }
}
