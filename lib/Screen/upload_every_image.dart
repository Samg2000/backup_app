import 'dart:io';
import 'package:backup_app/Widgets/CommonWidgets.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as Path;
import 'package:backup_app/Controls/Constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UploadEveryImage extends StatefulWidget {
  final List<FileSystemEntity> fsList;
  @required
  final String serverPath;

  UploadEveryImage({
    Key key,
    this.fsList,
    this.serverPath,
  }) : super(key: key);

  @override
  _UploadEveryImageState createState() => _UploadEveryImageState();
}

class _UploadEveryImageState extends State<UploadEveryImage> {
  int currentIndex = 0;
  bool isUploading = false;
  bool terminateReq = false;
  List<int> errorFree = List();

  Future uploadEveryThing() async {
    try {
      for (int i = 0; i < widget.fsList.length; i++) {
        // print(Path.extension(widget.fsList[i].path));
        if (terminateReq) {
          setState(() {
            isUploading = false;
            terminateReq = false;
          });
          return true;
        }
        http.MultipartRequest req = http.MultipartRequest(
            "POST", Uri.parse(serverUrl + widget.serverPath));
        if (widget.fsList[i].statSync().type ==
                FileSystemEntityType.directory ||
            widget.fsList[i].statSync().size == 0) continue;
        currentIndex = i;
        isUploading = true;
        setState(() {});
        req.files.add(await http.MultipartFile.fromPath(
            'picture', widget.fsList[i].path,
            filename: widget.fsList[i].path.split('/').last));
        final res = await req.send();
        if (res.statusCode == 200) errorFree.add(i);
        // print(erroFree);
        setState(() {});
      }
      isUploading = false;
      setState(() { });
      return true;
    } catch (e) {
      // print(e);
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    // print(currentIndex);
    return Scaffold(
      floatingActionButton: Stack(
        children: [
          (isUploading)
              ? Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          terminateReq = true;
                        });
                      },
                      backgroundColor: Colors.redAccent[400],
                      child: Icon(Icons.cancel),
                    ),
                  ),
                )
              : Container(),
          Align(
            alignment: Alignment.bottomRight,
            child: Builder(
              builder: (BuildContext context) => FloatingActionButton(
                onPressed: () {
                  // terminateReq=false;
                  SnackBar snackBar(text) => SnackBar(content: Text(text));
                  // terminateReq=false;
                  uploadEveryThing()
                      .then(
                        (value) => Scaffold.of(context).showSnackBar(
                          snackBar(
                            "Files Uploaded",
                          ),
                        ),
                      )
                      .catchError(
                        (err) => Scaffold.of(context).showSnackBar(
                          snackBar(
                            "Error Occurred",
                          ),
                        ),
                      );
                },
                child: Icon(Icons.file_upload),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: widget.fsList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CustomTile(
                    padding: 80,
                    left: true,
                    text: Path.basename(widget.fsList[index].path),
                    isRound: false,
                    color: (currentIndex==(widget.fsList.length-1)&&isUploading==false)?Colors.greenAccent[400]:((index >= currentIndex)
                        ? accentColor
                        : ((!errorFree.contains(index))
                            ? Colors.redAccent[400]
                            : Colors.greenAccent[400])),
                  ),
                  (currentIndex == index && isUploading)
                      ? LinearProgressIndicator(
                          backgroundColor: whiteColor,
                        )
                      : Container(),
                ],
              ),
            );
          }),
    );
  }
}
