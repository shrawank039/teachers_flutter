import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../GroupChat/ChatScreen.dart';
import '../ServerAPI.dart';

class GroupChat extends StatefulWidget {
  @override
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {

  List allSubject = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getClassWiseSubjectList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: todaySchedule(),
            builder: (BuildContext context, snapshot) {
              var response = snapshot.data;
              return Column(
                children: <Widget>[
                  _dayLog(response),
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text("All Subjects".toUpperCase(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    ),
                  ),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: allSubject.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          ListTile(
                            onTap: () async {
                              final user = await ServerAPI().getUserInfo();
                              Route route = MaterialPageRoute(builder: (context) => MyChatScreen(
                                  allSubject[index]['class_id'].toString(),
                                  allSubject[index]['class_status'].toString(),
                                  allSubject[index]['teacher_id'].toString(),
                                  allSubject[index]['subject_name'].toString(),
                                  allSubject[index]['chat_room_id'].toString()
                              ));
                              await Navigator.push(context, route);
                            },
                            leading: Container(
                              height: 25,
                              width: 25,
                              child: getStatus(allSubject[index]['class_status']),
                            ),
                            title: Text(allSubject[index]['subject_name'].toString()),
                            trailing: Text(allSubject[index]['class_name'].toString()),
                          ),
                          Container(
                            height: 1,
                            decoration: BoxDecoration(color: Colors.black12),
                          )
                        ],
                      );

                    },
                  )

                ],
              );
            }
          ),
      )
    );
  }

  Widget _dayLog(response){
    if(response != null) {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: response.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              ListTile(
                onTap: () async {
                  final user = await ServerAPI().getUserInfo();
                  Route route = MaterialPageRoute(builder: (context) => MyChatScreen(
                      response[index]['class_id'].toString(),
                      response[index]['class_status'].toString(),
                      response[index]['teacher_id'].toString(),
                      response[index]['subject_name'].toString(),
                      response[index]['chat_room_id'].toString()
                  ));
                  await Navigator.push(context, route);
                },
                leading: Container(
                  height: 25,
                  width: 25,
                  child: getStatus(response[index]['class_status']),
                ),
                title: Text(response[index]['subject_name'].toString()),
                subtitle: Text(response[index]['class_name'].toString()),
                trailing: Text(response[index]["timeslot"].toString()),
              ),
              Container(
                height: 1,
                decoration: BoxDecoration(color: Colors.black12),
              )
            ],
          );

        },
      );
    } else {
      return Container();
    }
  }

  Widget getStatus(status) {
    if(int.tryParse(status.toString()) == 0 ){
      return Image.asset('assets/images/completed_classes.png');
    } else if ( int.tryParse(status.toString()) == 1 ){
      return Image.asset('assets/images/ongoing_classes.png');
    } else {
      return Image.asset('assets/images/pending_class.png');
    }
  }

  todaySchedule() async{
    final result = await ServerAPI().todaySchedule();
    return result["data"];
  }

  _getClassWiseSubjectList() async {
    final result = await ServerAPI().calssWiseSubjectList();
    print(result);
    setState(() {
      allSubject = result["data"];
    });
  }

}
