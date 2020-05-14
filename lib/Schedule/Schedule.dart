import 'package:flutter/material.dart';
import '../ServerAPI.dart';

class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Class Schedule"),
      ),
      body: FutureBuilder(
          future: _weeklyScheduleClass(),
          builder: ( BuildContext context, snapshot ){
            var response = snapshot.data;
            if(response != null){

              var keyName = [];
              response.forEach((key, value) {
                keyName.add(key);
              });

              return ListView.builder(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  itemCount: response.length,
                  itemBuilder: (BuildContext context, int index){
                    var classList = response[keyName[index]];
                    return Card(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.today),
                            title: Text(keyName[index].toString(), style: TextStyle(fontWeight: FontWeight.bold),),
                          ),

                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                              itemCount: classList.length,
                              itemBuilder: (BuildContext context, int subIndex){
                                return Column(
                                  children: <Widget>[
                                    Container(height: 1, decoration: BoxDecoration(color: Colors.black12),),
                                    Column(
                                      children: <Widget>[
                                        ListTile(
                                          title: Text(classList[subIndex]['subject_name'].toString()),
                                          subtitle: Text(classList[subIndex]['class_name'].toString()),
                                          trailing: Text(classList[subIndex]['timeslot'].toString()),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              })

                        ],
                      ),
                    );
                  });
            } else {
              return Center(child: Text("Loading....", style: TextStyle(fontSize: 20),));
            }
          }
      ),
    );
  }

  _weeklyScheduleClass() async {
    final result = await ServerAPI().weeklyScheduleClass();
    print(result);
    return result['data'];
  }

}
