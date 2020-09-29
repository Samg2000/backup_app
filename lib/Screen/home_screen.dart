import 'dart:async';
import 'package:backup_app/Controls/Constants.dart';
import 'package:backup_app/Screen/change_ip_address.dart';
import 'package:backup_app/Screen/custom_path_screen.dart';
import 'package:backup_app/Screen/image_gallery_screen.dart';
import 'package:backup_app/Screen/upload_every_image_from_media_file.dart';
import 'package:backup_app/Widgets/CommonWidgets.dart';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  static const String route = "HomeScreen";
  static const SizedBox _sizedBox = const SizedBox(
    height: 10,
  );

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StreamSubscription _intentDataStreamSubscription;
  List<SharedMediaFile> _sharedFiles;
  Future _instance;

  @override
  void setState(fn) {
    if (mounted) // TODO: implement setState
      super.setState(fn);
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> value) {
      setState(() {
        // print("Shared:" + (_sharedFiles?.map((f) => f.path)?.join(",") ?? ""));
        _sharedFiles = value;
      });
    }, onError: (err) {
      // print("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      setState(() {
        _sharedFiles = value;
      });
    });

    _instance = getIpAddress();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (_sharedFiles == null)
      return Scaffold(
        body: FutureBuilder(
            future: _instance,
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return Stack(
                  children: [
                    SizedBox()
                        .box
                        .size(size.width, size.height)
                        .color(accentColor)
                        .make(),
                    "Backup"
                        .text
                        .size(25)
                        .white
                        .makeCentered()
                        .box
                        .size(size.width, size.height * 0.17)
                        .make(),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: size.height * 0.83,
                        width: size.width,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                          color: Theme.of(context).cardColor,
                        ),
                        child: Column(
                          children: [
                            HomeScreen._sizedBox,
                            HomeScreen._sizedBox,
                            HomeScreen._sizedBox,
                            HomeTile(
                              title: "Camera",
                              serverPath: cameraServerUrl,
                              filePath: cameraPath,
                            ),
                            HomeScreen._sizedBox,
                            HomeScreen._sizedBox,
                            HomeTile(
                              title: "ScreenShots",
                              serverPath: screenShotServerUrl,
                              filePath: screenshotPath,
                            ),
                            HomeScreen._sizedBox,
                            HomeScreen._sizedBox,
                            HomeTile(
                              title: "Downloads",
                              serverPath: MisServerUrl + "/Download",
                              filePath: downloadPath,
                            ),
                            HomeScreen._sizedBox,
                            HomeScreen._sizedBox,
                            HomeTile(
                              title: "WhatsApp Images",
                              serverPath: MisServerUrl + "/WhatsAppImages",
                              filePath: "/WhatsApp/Media/WhatsApp Images",
                            ),
                            HomeScreen._sizedBox,
                            HomeScreen._sizedBox,
                            HomeTile(
                              title: "WhatsApp Doc",
                              serverPath: MisServerUrl + "/WhatsAppDocument",
                              filePath: "/WhatsApp/Media/WhatsApp Documents",
                            ),
                            HomeScreen._sizedBox,
                            HomeScreen._sizedBox,
                            HomeTile(title: "Custom",route: CustomPathScreen.route,),
                            HomeScreen._sizedBox,
                            HomeScreen._sizedBox,
                            HomeTile(title: "Change IP Address",color: Colors.yellow[700],route: ChangeIpAddress.route,)

                            // _sizedBox,
                            // _sizedBox,
                          ],
                        ),
                      ),
                    )
                  ],
                );
              return spinWave(context);
            }),
      );
    else
      return UploadEveryImageFromMediaFile(
        images: _sharedFiles,
        serverPath: MisServerUrl + "/Shared",
      );
  }

  Future getIpAddress() async {
    try {
      SharedPreferences _sharedPreferences =
          await SharedPreferences.getInstance();
      final string = _sharedPreferences.getString(ipString);
      if (string != null) {
        serverUrl = string;
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}

class HomeTile extends StatelessWidget {
  final String title;
  final String serverPath;
  final String filePath;
  final String route;
  final Color color;

  const HomeTile({
    Key key,
    this.title,
    this.serverPath,
    this.filePath,
    this.route, this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(route==null)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageGalleryWidget(
              title: title,
              serverPath: serverPath,
              filePath: filePath,
            ),
          ),
        );
        else
          Navigator.pushNamed(
              context,route);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: CustomTile(
          text: title,
          left: true,
          color: color??accentColor,
        ),
      ),
    );
  }
}
