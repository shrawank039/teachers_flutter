import 'package:flutter/material.dart';
import 'package:teachers/CustomDrawer.dart';
import 'package:teachers/NewsRoom/FullNews.dart';
import 'package:teachers/ServerAPI.dart';

import '../Global.dart';


class NewsRoom extends StatefulWidget {

  final String pageType;
  final String title;

  NewsRoom(this.pageType, this.title);

  @override
  _NewsRoomState createState() => _NewsRoomState();
}

class _NewsRoomState extends State<NewsRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(widget.title.toString()),
      ),
      body: FutureBuilder(
        future: getNews(),
        builder: (BuildContext context, snapshot){
          var response = snapshot.data;
          if(response == null){
            return Center(child: Global.spinkitCircle);
          } else {
            if(response.length > 0 ){
              return ListView.builder(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 15),
                  itemCount: response.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        onTap: (){
                          Route route = MaterialPageRoute(builder: (context) => FullNews(response[index], widget.title));
                          Navigator.push(context, route);
                        },
                        title: Text(response[index]['title'].toString()),
                        subtitle: Text(response[index]['created_date'].toString()),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    );
                  });
            } else {
              return Center(child: Text("NO RECORDS FOUND"));
            }
          }
        },
      ),
    );
  }


  getNews() async {
    final result = await ServerAPI().getNews(widget.pageType.toString());
    return result["data"];
  }

}
