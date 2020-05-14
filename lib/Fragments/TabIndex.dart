import 'package:flutter/material.dart';
import 'Assignment.dart';
import 'GroupChat.dart';
import 'TeachersList.dart';

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
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: "Class Room",),
              Tab(text: "Assignment",),
              Tab(text: "Homework",),
            ],
          ),
          title: Text('Class Communications'),
        ),
        body: TabBarView(
          children: [
            GroupChat(),
            Assignment(),
            TeachersList(""),
          ],
        ),
      ),
    );
  }
}
