import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../GroupChat/ChatScreen.dart';
import '../ServerAPI.dart';

class GroupChat extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: todaySchedule(),
          builder: (BuildContext context, snapshot) {
            var response = snapshot.data;
            if(response != null){
              return ListView.builder(
                itemCount: response.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(left: 10.0, right: 10, top: 5),
                    child: GestureDetector(
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
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                response[index]["timeslot"].toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[500],
                                ),
                              ),
                              Text(
                                response[index]['subject_name'],
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Container(
                                height: 25,
                                width: 25,
                                child: getStatus(response[index]['class_status']),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text("Loading....", style: TextStyle(fontSize: 20),));
            }
          }
        )
    );
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
    print(result);
    return result["data"];
  }

}
