import 'package:flutter/material.dart';
import 'package:teachers/CustomDrawer.dart';

import '../Global.dart';
import '../ServerAPI.dart';

class Announcement extends StatefulWidget {
  @override
  _AnnouncementState createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Announcement"),
      ),
      body: FutureBuilder(
          future: _getAnnouncement(),
          builder: (BuildContext context, snapshot) {
            var response = snapshot.data;
            if (response != null) {
              if (response.length < 1) {
                return Center(
                    child: Text(
                  "NO RECORDS FOUND",
                  style: TextStyle(fontSize: 20),
                ));
              }

              return ListView.builder(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 15),
                  itemCount: response.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Card(
                        elevation: 5.0,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(response[index]['title'].toString()),
                              subtitle: Text(
                                  response[index]['created_date'].toString()),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, bottom: 15),
                              child: Text(
                                response[index]['description'].toString(),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return Center(child: Global.spinkitCircle);
            }
          }),
    );
  }

  _getAnnouncement() async {
    final result = await ServerAPI().announcement();
    return result["data"];
  }
}
