import 'package:flutter/material.dart';
import '../IndividualChat/IndividualChat.dart';
import '../ServerAPI.dart';

class TeachersList extends StatefulWidget {

  final String class_id;
  final String subject_id;

  TeachersList(this.class_id, this.subject_id);

  @override
  _TeachersListState createState() => _TeachersListState();
}

class _TeachersListState extends State<TeachersList> {

  var appBar = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Homewark Submission"),
      ),
      body: FutureBuilder(
        future: _individualChatRoomList(),
        builder: ( BuildContext context, snapshot ){
          var response = snapshot.data;
          if(response != null){
            return ListView.builder(
              itemCount: response.length,
              itemBuilder: (BuildContext context, int index){
                return Column(
                  children: <Widget>[
                    ListTile(
                      onTap: () async {
                        Route route = MaterialPageRoute(builder: (context) => IndividualChat(
                            response[index]['class_id'].toString(),
                            response[index]['teacher_id'].toString(),
                            response[index]['subject_name'].toString(),
                            response[index]['student_id'].toString(),
                            response[index]['chat_room_id'].toString()
                        ));
                        await Navigator.push(context, route);
                      },
                      leading: Image.asset('assets/images/teacher_icon.png',),
                      title: Text(response[index]['student_name'].toString(), style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: Text(response[index]['subject_name'].toString()),
                    ),
                    Container(height: 1,width: MediaQuery.of(context).size.width, decoration: BoxDecoration(color: Colors.black12),)
                  ],
                );
              });
          } else {
            return Center(child: Text("Loading....", style: TextStyle(fontSize: 20),));
          }
        },
      ),
    );
  }

  _individualChatRoomList() async {
    final result = await ServerAPI().individualChatRoomList(widget.class_id, widget.subject_id);
    print(result);
    return result["data"];
  }
}
