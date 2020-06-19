import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class StartAudioCall extends StatefulWidget {

  final String room_id;
  final String user_name;
  final String user_id;
  final String subject_name;
  final String class_name;

  StartAudioCall(this.room_id, this.user_id, this.user_name, this.subject_name, this.class_name);

  @override
  _StartAudioCallState createState() => _StartAudioCallState();
}

class _StartAudioCallState extends State<StartAudioCall> {

  InAppWebViewController _webViewController;

  String room_id;
  String user_name;
  String user_id;
  String subject_name;
  String class_name;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    room_id = widget.room_id;
    user_name = widget.user_name;
    user_id = widget.user_id;
    subject_name = widget.subject_name;
    class_name = widget.class_name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user_name + " Ongoing Class"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.call),
        backgroundColor: Colors.red,
      ),
      body: Container(
          child: Column(children: <Widget>[
            Expanded(
              child: Container(
                child: InAppWebView(
                    initialUrl: "https://conference.21century.in/audio.php?type=teacher&room_id=$room_id&user_name=$user_name&user_id=$user_id&subject_name=$subject_name&class_name=$class_name",
                    initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        mediaPlaybackRequiresUserGesture: false,
                        debuggingEnabled: false,
                      ),
                    ),
                    onWebViewCreated: (InAppWebViewController controller) {
                      _webViewController = controller;
                    },
                    androidOnPermissionRequest: (InAppWebViewController controller, String origin, List<String> resources) async {
                      return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
                    }
                ),
              ),
            ),
          ])),
    );
  }



}
