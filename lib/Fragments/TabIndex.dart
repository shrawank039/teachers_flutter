import 'package:flutter/material.dart';
import 'package:teachers/CustomDrawer.dart';
import 'Assignment.dart';
import 'GroupChat.dart';
import 'TeachersList.dart';
import 'AllClassRoutine.dart';

class TabIndex extends StatefulWidget {
  @override
  _TabIndexState createState() => _TabIndexState();
}

class _TabIndexState extends State<TabIndex> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.green,
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Class Room",
              ),
              Tab(
                text: "Assignment",
              ),
              Tab(
                text: "Homework",
              ),
            ],
          ),
          title: Text('Class Room'),
        ),
        body: TabBarView(
          children: [
            GroupChat(),
            Assignment(),
            AllClassRoutine(),
          ],
        ),
      ),
    );
  }
}
