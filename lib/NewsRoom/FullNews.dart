import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullNews extends StatefulWidget {

  var data;
  var title;

  FullNews(this.data, this.title);

  @override
  _FullNewsState createState() => _FullNewsState();
}

class _FullNewsState extends State<FullNews> {

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.data['file_type'] == "mp4"){
      _controller = VideoPlayerController.network(widget.data['file_url']);
      _initializeVideoPlayerFuture = _controller.initialize();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: Text(widget.data["created_date"], textAlign: TextAlign.right, style: TextStyle(color: Colors.grey),),
            ),
            ifVideo(),
            Text(widget.data["text"].toString(), style: TextStyle(fontSize: 18), textAlign: TextAlign.justify,)
          ],
        ),
      ),
    );
  }

  Widget ifVideo(){
    if(widget.data["file_type"] == "png"){
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Image.network(widget.data["file_url"]),
      );
    } else if(widget.data["file_type"] == "mp4") {
      return FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the video.
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // Use the VideoPlayer widget to display the video.
              child: VideoPlayer(_controller),
            );
          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
            return Center(child: CircularProgressIndicator());
          }
        },
      );
    }
  }

}
