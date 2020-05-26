import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

class FileViewer extends StatefulWidget {

  final String fileURL;
  final String fileType;

  FileViewer(this.fileURL, this.fileType);

  @override
  _FileViewerState createState() => _FileViewerState();
}

class _FileViewerState extends State<FileViewer> {

  bool _isLoading = true;
  PDFDocument document;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadDocument();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0.0,
        title: Text("File Viewer"),
      ),
      body: viewFile(),
    );
  }

  Widget viewFile(){
    if(widget.fileType == "image"){
      return SingleChildScrollView(
        child: Image.network(widget.fileURL, fit: BoxFit.fitWidth,),
      );
    } else {
      return Center(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : PDFViewer(
          document: document,
          zoomSteps: 1,
          //uncomment below line to preload all pages
          // lazyLoad: false,
          // uncomment below line to scroll vertically
          // scrollDirection: Axis.vertical,

          //uncomment below code to replace bottom navigation with your own
          /* navigationBuilder:
                      (context, page, totalPages, jumpToPage, animateToPage) {
                    return ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.first_page),
                          onPressed: () {
                            jumpToPage()(page: 0);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            animateToPage(page: page - 2);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            animateToPage(page: page);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.last_page),
                          onPressed: () {
                            jumpToPage(page: totalPages - 1);
                          },
                        ),
                      ],
                    );
                  }, */
        ),
      );
    }
  }

  loadDocument() async {
    if(widget.fileType == "pdf"){
      document = await PDFDocument.fromURL(widget.fileURL);
      setState(() => _isLoading = false);
    }
  }


}
