import 'dart:core';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../FileViewer.dart';
import '../ServerAPI.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';

class IndividualChat extends StatefulWidget {

  final String teacher;
  final String subject;
  final String chat_group_id;
  final String calss_id;
  final String student_id;

  IndividualChat(this.calss_id, this.teacher, this.subject, this.student_id, this.chat_group_id);

  @override
  _IndividualChatState createState() =>  _IndividualChatState();
}

class _IndividualChatState extends State<IndividualChat> {

  var currentUser;
  List chatHistory = [];
  SocketIOManager manager;
  final _textController = TextEditingController();
  SocketIO socket;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    manager = SocketIOManager();
    initSocket();
    _readAllMessage();
  }

  getCurrentUser() async {
    final user = await ServerAPI().getUserInfo();
    currentUser = user;
  }

  initSocket() async {
    var userId = widget.student_id;
    var chatRoomID = widget.chat_group_id;
    // Load Chat History
    await getGroupChatHistory(chatRoomID);
    socket = await manager.createInstance(SocketOptions(
      //Socket IO server URI
        "http://chatserver.21century.in:3000/",
        nameSpace: "/",
        query: {
          "user_type": "teacher",
          "user_id": userId,
          "chat_room_id": chatRoomID
        },
        enableLogging: false,
        transports: [Transports.WEB_SOCKET/*, Transports.POLLING*/] //Enable required transport
    ));
    socket.onConnect((data) {
      print("connected...");
      print(data);
    });
    socket.onConnectError(print);
    socket.onConnectTimeout(print);
    socket.onError(print);
    socket.onDisconnect(print);
    socket.on("individual_chat_room/$chatRoomID", (message){
      setState(() {
        chatHistory.insert(0, message);
      });
    });
    socket.connect();
  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
        backgroundColor: Color(0xFFe8dfd8),
        appBar:  AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text(widget.subject.toString() + " Homework",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.camera_alt),
              tooltip: 'Pick From Camera',
              onPressed: () async {
                await _selectAttachment('camera');
              },
            ),
            IconButton(
              icon: const Icon(Icons.attach_file),
              tooltip: 'Pick from Gallery',
              onPressed: () async {
                await _selectAttachment('gallery');
              },
            ),
          ],
        ),
        body:  LoadingOverlay(
          child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Color(0xFFe8dfd8),
              child:  Column(
                children: <Widget>[
                  //Chat list
                  Flexible(
                    child:  ListView.builder(
                      padding:  EdgeInsets.all(8.0),
                      reverse: true,
                      itemBuilder: ( context, int index){
                        return chatList(chatHistory[index]);
                      },
                      itemCount: chatHistory.length,
                    ),
                  ),
                  Divider(height: 1.0),
                  Container(
                      decoration: BoxDecoration(color: Theme.of(context).cardColor),
                      child:  IconTheme(
                          data:  IconThemeData(color: Theme.of(context).accentColor),
                          child:  Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2.0),
                            child:  Row(
                              children: <Widget>[

                                //Enter Text message here
                                Flexible(
                                  child:  TextField(
                                    controller: _textController,
                                    decoration:  InputDecoration.collapsed(hintText: "Enter message"),
                                  ),
                                ),

                                //right send button

                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 2.0),
                                  width: 48.0,
                                  height: 48.0,
                                  child:  IconButton(
                                      icon: Image.asset("assets/images/send_out.png"),
                                      onPressed: _sendChatMessage
                                  ),
                                ),

                              ],
                            ),
                          ))),
                ],
              )
          ),
          isLoading: _saving
        )
    );
  }

  Widget chatList(data){
    var align = CrossAxisAlignment.end;
    var myLeft = null;
    var myRight = 7.0;

    if(currentUser['id'].toString() !=  data["send_by"].toString()){
      align = CrossAxisAlignment.start;
      myLeft = 7.0;
      myRight = null;
    }

    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 5),
              margin: EdgeInsets.symmetric(horizontal: 21,vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  contentWidget(data),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(data["created_date"].toString(),style: TextStyle(fontSize: 12,color: Colors.grey), textAlign: TextAlign.right,),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: myRight,
              left: myLeft,
              top: 12,
              child: ClipPath(
                clipper: TriangleClipper(),
                child: Container(
                  height: 20,
                  width: 30,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget contentWidget(data) {
    if (data['content_type'].toString() == 'text') {
      return Text(data['content'].toString(), style: TextStyle(fontSize: 17,));
    } else if(data['content_type'].toString() == 'image') {
      return CachedNetworkImage(
        imageUrl: data['content'].toString(),
        imageBuilder: (context, imageProvider) => GestureDetector(
          onTap: (){
            Route route = MaterialPageRoute(builder: (context) => FileViewer(data['content'].toString(), data['content_type'].toString()));
            Navigator.push(context, route);
          },
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    } else if(data['content_type'].toString() == 'pdf') {

      return GestureDetector(
        onTap: () async {
          Route route = MaterialPageRoute(builder: (context) => FileViewer(data['content'].toString(), data['content_type'].toString()));
          Navigator.push(context, route);
        },
        child: Container(
          width: 200,
          height: 150,
          child: Image.asset('assets/images/pdf.jpg'),
        ),
      );

    } else {
      return GestureDetector(
        onTap: () async {
          await launch(data['content'].toString(), enableJavaScript: true);
        },
        child: Container(
          width: 200,
          height: 150,
          child: Image.asset('assets/images/document.jpg'),
        ),
      );;
    }
  }

  _sendChatMessage() async{
    final user = await ServerAPI().getUserInfo();
    if (socket != null) {
      if(_textController.text.toString() != ""){
        var msg = {
          "room_id" :widget.chat_group_id.toString(),
          "student" : 'student',
          "send_by" : user['id'].toString(),
          "content_type" : "text",
          "content" : _textController.text.toString(),
          "created_date" : _getDate()
        };
        //String jsonData = json.encode(msg);
        socket.emit("individual_chat_room", [msg]);
        // Clear Text field
        _textController.text = "";
        setState(() {
          chatHistory.insert(0, msg);
        });
      }
    }
  }

  void _onReceiveChatMessage(dynamic message) {
    var jsonMessage = json.decode(message.toString());
    setState(() {
      chatHistory.insert(0, jsonMessage["content"]);
    });
  }

  getGroupChatHistory(chatRoomID) async {
    final result = await ServerAPI().getIndividualChatHistory(chatRoomID);
    if(result['status'] != "failure"){
      final data = result["data"];
      for(var i = 0; i < data.length; i++){
        chatHistory.add(data[i]);
      }
      setState(() {});
    }
    return chatHistory;
  }


  _selectAttachment(type) async {
    _showLoader();
    var source = ImageSource.camera;
    var image;
    if (type == "gallery") {
      image = await FilePicker.getFile(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'pdf', 'doc', 'docx'],
      );
    } else {
      image = await ImagePicker.pickImage(source: source);
    }
    final response = await ServerAPI().attachmentUpload(image.path);
    print(response);
    final user = await ServerAPI().getUserInfo();
    if (socket != null) {
      var msg = {
        "room_id": widget.chat_group_id.toString(),
        "student": 'student',
        "send_by": user['id'].toString(),
        "content_type": response['data']['fileType'],
        "content": response['data']['attachmentUrl'],
        "created_date": _getDate()
      };
      socket.emit("individual_chat_room", [msg]);
      _textController.text = "";
      setState(() {
        chatHistory.insert(0, msg);
      });
    }
    _hideLoader();
  }

  _getDate(){
    var now = new DateTime.now();
    return now.year.toString() + "-"+ now.month.toString()+ "-"+ now.day.toString() + " " + now.hour.toString()+":"+now.minute.toString()+":"+now.second.toString();
  }

  _readAllMessage() async {
    await ServerAPI().readAllMessage(widget.chat_group_id);
  }

  _showLoader(){
    setState(() {
      _saving = true;
    });
  }

  _hideLoader(){
    setState(() {
      _saving = false;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    manager.clearInstance(socket);
    super.dispose();
  }
}


class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}
