import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:backup_app/Screen/full_screen_image_screen.dart';
import 'package:backup_app/Screen/upload_every_image.dart';
import 'package:backup_app/Widgets/CommonWidgets.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/scheduler.dart';/
import 'package:path/path.dart' as Path;
import 'package:http/http.dart' as http;
import 'package:backup_app/Controls/Constants.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

List fun(Map<dynamic,dynamic> map){
  List<FileSystemEntity> fsList=List();
  for (int i = 0; i < map["tempFsList"].length; i++) {
    bool exist = false;
    for (int j = 0; j < map["images"].length; j++) {
      if (Path.basename(map["tempFsList"][i].path) == map["images"][j]) exist = true;
    }
    if (!exist) fsList.add(map["tempFsList"][i]);
  }
  fsList.sort(
          (a, b) => b.statSync().modified.compareTo(a.statSync().modified));
  return fsList;
}

class ImageGalleryWidget extends StatefulWidget {
  final String title;
  final String filePath;
  final String serverPath;

  const ImageGalleryWidget(
      {Key key, this.title, this.filePath, this.serverPath})
      : super(key: key);

  @override
  _ImageGalleryWidgetState createState() => _ImageGalleryWidgetState();
}

class _ImageGalleryWidgetState extends State<ImageGalleryWidget>
    with AutomaticKeepAliveClientMixin<ImageGalleryWidget> {
  List<dynamic> files;
  var cameraPath;
  List fsList = List();
  Future _getLocal;

  // static void fun(){
  //
  // }
  Future getFiles()async{
    try {
      // compute
      // SchedulerBinding.instance.`
      List<FileSystemEntity> tempFsList  = await Directory(cameraPath).list().toList() ;
      List finalList =await compute(fun,{
        "images":files,
        "tempFsList":tempFsList
      });
      // print(finalList[0].path);
      tempFsList.clear();
      fsList=finalList;

         // = List<FileSystemEntity>();
      // for (int i = 0; i < tempFsList.length; i++) {
      //   bool exist = false;
      //   for (int j = 0; j < files.length; j++) {
      //     if (Path.basename(tempFsList[i].path) == files[j]) exist = true;
      //   }
      //   if (!exist) fsList.add(tempFsList[i]);
      // }
      // print(fsList.length);

      return true;
    }  catch (e) {
      print(e);
      throw Exception("he");
    }
  }
  Future getImagesLocally() async {
    try {
      http.Response res = await http.get(serverUrl + widget.serverPath);
      files = JsonDecoder().convert(res.body);
      cameraPath = await ExtStorage.getExternalStorageDirectory();
      // print(cameraPath);
      cameraPath += widget.filePath;
      final pv =
          EasyPermissionValidator(context: context, appName: "Backup App");
      await pv.storage();
      var temp=await getFiles();
      if(temp)
        return true;
      else
        return false;
    } catch (e) {
      // print(e.toString());
      throw Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getLocal = getImagesLocally();
    // _getServer = getImagesFromServer();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.5;
    final double itemWidth = size.width / 2;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(Icons.cloud_upload),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UploadEveryImage(
                        fsList: fsList,
                        serverPath: widget.serverPath,
                      ),
                    ),
                  );
                })
          ],
          title: (widget.title).text.make(),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text("Upload"),
              ),
              Tab(
                child: Text("Uploaded"),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FutureBuilder(
              future: _getLocal,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data)
                    return GridView.count(
                      addAutomaticKeepAlives: true,
                      childAspectRatio: itemWidth / itemHeight,
                      crossAxisCount: 2,
                      // controller:,
                      // cacheExtent: ,
                      // cacheExtent: ,
                      children: List.generate(
                          fsList.length,
                          (index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(9),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      (Path.extension(fsList[index].path) !=
                                                  '.jpg' &&
                                              Path.extension(
                                                      fsList[index].path) !=
                                                  '.png' &&
                                              Path.extension(
                                                      fsList[index].path) !=
                                                  '.jpeg')
                                          ? VideoBoxWidget(
                                              fsList: fsList[index],
                                              itemHeight: itemHeight,
                                              size: size,
                                              canUpload: true,
                                              serverPath: widget.serverPath,
                                              canOpen: true,
                                            )
                                          : InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        FullScreenImage(
                                                      canUpload: true,
                                                      serverPath:
                                                          widget.serverPath,
                                                      path: fsList[index].path,
                                                      heroTag: "Hero$index",
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Hero(
                                                tag: "Hero$index",
                                                child: Image.file(
                                                  fsList[index],
                                                  errorBuilder: (context, exc,
                                                          trace) =>
                                                      errorBuilder(
                                                          context, exc, trace),
                                                  frameBuilder: (context, child,
                                                          frame, sync) =>
                                                      frameBuilder(context,
                                                          child, frame, sync),
                                                  cacheHeight:
                                                      (size.height * 0.12)
                                                          .toInt(),
                                                  cacheWidth:
                                                      (size.width * 0.25)
                                                          .toInt(),
                                                  height: itemHeight - 66,
                                                  width: size.width * 0.5,
                                                  fit: BoxFit.cover,
                                                ).box.make(),
                                              ),
                                            ),
                                      CustomTile(
                                        padding: 50,
                                        textSize: 13,
                                        left: true,
                                        text: Path.basename(
                                          fsList[index].path,
                                        ),
                                        isRound: false,
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                    );
                  return CustomErrorWidget();
                } else if (snapshot.hasError) return CustomErrorWidget();
                return spinWave(context);
              },
            ),
            FutureBuilder(
              future: _getLocal,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data)
                    return GridView.count(
                      addAutomaticKeepAlives: true,
                      childAspectRatio: itemWidth / itemHeight,
                      crossAxisCount: 2,
                      children: List.generate(
                        files.length,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                (Path.extension(files[index]) != '.jpg')
                                    ? VideoBoxWidget(
                                        itemHeight: itemHeight,
                                        size: size,
                                        path: files[index],
                                        canOpen: false)
                                    : InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => FullScreenImage(
                                                path:
                                                    "$cameraPath/${files[index]}",
                                                heroTag: "Hero$index#",
                                                canUpload: false,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Hero(
                                          tag: "Hero$index",
                                          child: Image.file(
                                            File(
                                                "$cameraPath/${files[index]}"),
                                            errorBuilder:
                                                (context, exc, trace) =>
                                                    errorBuilder(
                                                        context, exc, trace),
                                            frameBuilder:
                                                (context, child, frame, sync) =>
                                                    frameBuilder(context, child,
                                                        frame, sync),
                                            cacheHeight:
                                                (size.height * 0.12).toInt(),
                                            cacheWidth:
                                                (size.width * 0.25).toInt(),
                                            height: itemHeight - 66,
                                            width: size.width * 0.5,
                                            fit: BoxFit.cover,
                                          ).box.make(),
                                        ),
                                      ),
                                CustomTile(
                                  padding: 50,
                                  textSize: 13,
                                  left: true,
                                  text: Path.basename(
                                    files[index],
                                  ),
                                  isRound: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  return CustomErrorWidget();
                } else if (snapshot.hasError) return CustomErrorWidget();
                return spinWave(context);
              },
            ),
          ],
        ),
      ),
    );
  }

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
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
