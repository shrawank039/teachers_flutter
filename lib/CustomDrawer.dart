import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Dashboard/Dashboard.dart';
import 'Profile/Profile.dart';
import 'Announcement/Announcement.dart';
import 'Auth/Login.dart';
import 'Auth/changePassword.dart';
import 'Fragments/TabIndex.dart';
import 'Schedule/Schedule.dart';
import 'Screens/ContactAgreement.dart';
import 'ServerAPI.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<CustomDrawer> {

  String student_name = "";
  String student_code = "";
  String avatar = "";
  var wallet = "0.0";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserData();
  }

  _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = await prefs.get('userData');
    final dateToJson = json.decode(userData);
    setState(() {
      student_name = dateToJson['teacher_name'].toString();
      student_code = dateToJson['teacher_code'].toString();
      avatar = dateToJson['profile_photo'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    var MenuTextStyle = TextStyle(
      color: Colors.black54,
      fontSize: 20.0,
    );
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueGrey,
            ),
            accountName: Text(student_name.toUpperCase()),
            accountEmail: Row(
              children: <Widget>[
                Expanded(child: Text(student_code)),
              ],
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Image.asset('assets/images/avatar.png'),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.dashboard),
            title: Text('Dashboard', style: MenuTextStyle,),
            onTap: () {
              Route route = MaterialPageRoute(builder: (context) => Dashboard());
              Navigator.pushReplacement(context, route);
            },
          ),

          ListTile(
            leading: const Icon(Icons.archive),
            title: Text('Profile', style: MenuTextStyle,),
            onTap: () {
              Route route = MaterialPageRoute(builder: (context) => Profile());
              Navigator.pushReplacement(context, route);
            },
          ),

          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text('Time Table', style: MenuTextStyle,),
            onTap: () {
              Route route = MaterialPageRoute(builder: (context) => Schedule());
              Navigator.pushReplacement(context, route);
            },
          ),

          ListTile(
            leading: const Icon(Icons.notifications_active),
            title: Text('Announcement', style: MenuTextStyle,),
            onTap: () {
              Route route = MaterialPageRoute(builder: (context) => Announcement());
              Navigator.pushReplacement(context, route);
            },
          ),

          ListTile(
            leading: const Icon(Icons.chat),
            title: Text('Class Room', style: MenuTextStyle,),
            onTap: () {
              Route route = MaterialPageRoute(builder: (context) => TabIndex());
              Navigator.pushReplacement(context, route);
            },
          ),

          ListTile(
            leading: const Icon(Icons.live_help),
            title: Text('Support', style: MenuTextStyle,),
            onTap: () {
              Route route = MaterialPageRoute(builder: (context) => ContactAgreement());
              Navigator.pushReplacement(context, route);
            },
          ),

          Divider(),
          ListTile(
            leading: const Icon(Icons.vpn_key),
            title: Text('Change Password', style: MenuTextStyle,),
            onTap: () {
              Route route = MaterialPageRoute(builder: (context) => changePassword());
              Navigator.pushReplacement(context, route);
            },
          ),
          ListTile(
            leading: const Icon(Icons.undo),
            title: Text('Logout', style: MenuTextStyle,),
            onTap:_logout,
          ),

          Divider(),

          ListTile(
            title: Text('App version'.toUpperCase(), style: TextStyle(color: Colors.black54,),),
            trailing: Text("V3.0.1"),
          ),

        ],
      ),
    );
  }


  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLogin');
    await prefs.remove('access_token');
    await prefs.remove('api_token');
    await prefs.remove('userData');
    Route route = MaterialPageRoute(builder: (context) => Login());
    Navigator.pushReplacement(context, route);
  }

}