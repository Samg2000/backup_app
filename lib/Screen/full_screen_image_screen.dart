import 'dart:io';
import 'dart:ui';
import 'package:backup_app/Controls/Constants.dart';
import 'package:backup_app/Widgets/CommonWidgets.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as Path;

class FullScreenImage extends StatelessWidget {
  final String path;
  final String heroTag;
  final FileStat fileStat;
  final bool canUpload;
  final String serverPath;

  const FullScreenImage(
      {Key key,
      this.path,
      this.heroTag,
      this.fileStat,
      this.canUpload,
      this.serverPath})
      : super(key: key);

  Widget errorBuilder(context, exception, trace) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomTile(
          bottom: true,
          padding: 30,
          color: Colors.redAccent[400],
          text: "Something Went Wrong"),
    );
  }

  Widget frameBuilder(context, child, frame, isSync) {
    if (isSync) return child;
    return AnimatedOpacity(
      opacity: frame == null ? 0 : 1,
      duration: Duration(seconds: 1),
      child: child,
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isPicture = (Path.extension(path) == ".jpg" ||
            Path.extension(path) == ".png" ||
            Path.extension(path) == ".jpeg")
        ? true
        : false;

    return Scaffold(
      backgroundColor: Colors.grey[800],
      floatingActionButton: (canUpload == true)
          ? MyFab(
              serverPath: this.serverPath,
              path: path,
            )
          : Container(),
      body: Stack(
        children: [
          (isPicture)
              ? Image.file(
                  File(path),
                  cacheHeight: (size.height).toInt(),
                  cacheWidth: (size.width).toInt(),
                  height: size.height,
                  width: size.width,
                  // filterQuality: ,
                )
              : SizedBox(
                  height: size.height,
                  width: size.width,
                ),
          (isPicture)
              ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Colors.black.withOpacity(0.1),
                  ),
                )
              : Container(),
          (!isPicture)
              ? Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      "Size :${fileStat.size ~/ (1024 * 1024)}MB"
                          .text
                          .color(whiteColor)
                          .size(16)
                          .make(),
                      "Date Modified :${fileStat.modified}"
                          .text
                          .color(whiteColor)
                          .size(16)
                          .make(),
                      "Date Changes :${fileStat.changed}"
                          .text
                          .color(whiteColor)
                          .size(16)
                          .make()
                    ],
                  ),
                )
              : SizedBox(),
          (isPicture)
              ? Align(
                  alignment: Alignment.center,
                  child: Hero(
                    tag: heroTag,
                    child: InteractiveViewer(
                      maxScale: 4,
                      minScale: 0.2,
                      child: Image.file(
                        File(path),
                        errorBuilder: (context, exc, trace) =>
                            errorBuilder(context, exc, trace),
                        frameBuilder: (context, child, frame, sync) =>
                            frameBuilder(context, child, frame, sync),
                      ),
                    ),
                  ),
                )
              : SizedBox(),
          (!isPicture)
              ? Path.extension(this.path).split('.').last.toUpperCase().text.color(whiteColor).size(45).makeCentered()
              : SizedBox(),
        ],
      ),
    );
  }
}

class MyFab extends StatefulWidget {
  final String path;
  final String serverPath;

  const MyFab({
    Key key,
    this.path,
    this.serverPath,
  }) : super(key: key);

  @override
  _MyFabState createState() => _MyFabState();
}

class _MyFabState extends State<MyFab> {
  // double progress;

  bool isUploading = false;

  Future uploadImage() async {
    try {
      isUploading = true;
      setState(() {});
      http.MultipartRequest req = http.MultipartRequest(
          "POST", Uri.parse(serverUrl + widget.serverPath));
      req.files.add(
        http.MultipartFile(
          'picture',
          File(widget.path).readAsBytes().asStream(),
          File(widget.path).lengthSync(),
          filename: widget.path.split('/').last,
        ),
      );
      final res = await req.send();
      // print("Ethe vi nhi Aa gya bc");
      isUploading = false;
      setState(() {});
      if (res.statusCode == 200)
        return true;
      else
        return res.statusCode;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        SnackBar snackBar(text) => SnackBar(content: Text(text));
        var res = await uploadImage();
        if (res == true)
          Scaffold.of(context).showSnackBar(
            snackBar(
              "File Uploaded SuccessFully",
            ),
          );
        else
          Scaffold.of(context).showSnackBar(snackBar("Something Went Wrong"));
      },
      child: (isUploading)
          ? CircularProgressIndicator(
              backgroundColor: whiteColor,
              strokeWidth: 3,
            )
          : Icon(
              Icons.file_upload,
              color: whiteColor,
            ),
    );
  }
}
