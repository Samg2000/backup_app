import 'dart:io';
import 'package:backup_app/Widgets/CommonWidgets.dart';
import 'package:path/path.dart' as Path;
import 'package:backup_app/Controls/Constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class UploadEveryImageFromMediaFile extends StatefulWidget {
  final List<SharedMediaFile> images;
  @required
  final String serverPath;

  const UploadEveryImageFromMediaFile({Key key, this.images, this.serverPath})
      : super(key: key);

  @override
  _UploadEveryImageFromMediaFileState createState() =>
      _UploadEveryImageFromMediaFileState();
}

class _UploadEveryImageFromMediaFileState
    extends State<UploadEveryImageFromMediaFile> {
  int currentIndex = 0;
  bool terminateReq = false;
  bool isUploading = false;
  List<int> errorFree = List();
  final _controller = TextEditingController();

  Future uploadEveryThing() async {
    try {
      for (int i = 0; i < widget.images.length; i++) {
        if (terminateReq) {
          setState(() {
            isUploading = false;
            terminateReq = false;
          });
          return true;
        }
        // print(Path.extension(widget.images[i].path));
        http.MultipartRequest req = http.MultipartRequest(
          "POST",
          Uri.parse(
            serverUrl +
                widget.serverPath +
                "/" +
                ((_controller.text.length != 0) ? _controller.text : "Shared"),
          ),
        );
        if (File(widget.images[i].path).statSync().type !=
                FileSystemEntityType.file ||
            File(widget.images[i].path).statSync().size == 0) continue;
        currentIndex = i;
        isUploading = true;
        setState(() {});
        req.files.add(await http.MultipartFile.fromPath(
            'picture', widget.images[i].path,
            filename: widget.images[i].path.split('/').last));
        final res = await req.send();
        if (res.statusCode == 200) errorFree.add(i);
        setState(() {});
      }
      isUploading = false;
      setState(() {});
      return true;
    } catch (e) {
      // print(e);
      throw Exception(e);
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Files"),
      ),
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
          (isUploading)
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(left: 28.0, right: 80),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: TextField(
                      controller: _controller,
                      decoration:
                          InputDecoration(labelText: "Enter Folder Name"),
                    ),
                  ),
                ),
          Align(
            alignment: Alignment.bottomRight,
            child: Builder(
              builder: (BuildContext context) => FloatingActionButton(
                onPressed: () {
                  SnackBar snackBar(text) => SnackBar(content: Text(text));
                  // terminateReq=false;
                  uploadEveryThing()
                      .then(
                        (value) => Scaffold.of(context).showSnackBar(
                          snackBar(
                            "File Uploaded",
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
          itemCount: widget.images.length,
          itemBuilder: (context, index) {
            // print(index);
            // print(!errorFree.contains(index));
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CustomTile(
                    padding: 80,
                    left: true,
                    text: Path.basename(widget.images[index].path),
                    isRound: false,
                    color: (currentIndex == (widget.images.length - 1) &&
                            isUploading == false)
                        ? Colors.greenAccent[400]
                        : ((index >= currentIndex)
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
