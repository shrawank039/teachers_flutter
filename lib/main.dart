import 'package:flutter/material.dart';
import 'Auth/Login.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() {
  runApp(MyApp());
  OneSignal.shared.init("0ff4329e-5eda-4e47-8de0-0e4f05fb6f50");
  OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: Colors.blue,
        primaryColor: Colors.white,
        primaryColorDark: Colors.white,
        fontFamily: 'Montserrat Regularr',
      ),
      home: Login(),
    );
  }
}
