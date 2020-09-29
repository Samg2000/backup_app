// import 'package:backup_app/Widgets/CommonWidgets.dart';
import 'package:backup_app/Controls/Constants.dart';
import 'package:backup_app/Screen/image_gallery_screen.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomPathScreen extends StatelessWidget {
  static const String route = "CustomPathScreen";
  static const SizedBox _sizedBox = const SizedBox(
    height: 10,
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final TextEditingController _textEditingController =
    // finalextEditingController();
    final _textEditingControllerServerPath = TextEditingController();
    final _textEditingControllerLocalPath = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SizedBox()
              .box
              .size(size.width, size.height)
              .color(accentColor)
              .make(),
          "Custom Path"
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                color: Theme.of(context).cardColor,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _sizedBox,
                  _sizedBox,
                  _sizedBox,
                  _sizedBox,
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Enter Server Path",
                      ),
                      controller: _textEditingControllerServerPath,
                    ),
                  ),
                  _sizedBox,
                  _sizedBox,
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      decoration:
                          InputDecoration(labelText: "Enter Local Path"),
                      controller: _textEditingControllerLocalPath,
                    ),
                  ),
                  _sizedBox,
                  _sizedBox,
                  _sizedBox,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: FlatButton(
                      shape: Border(
                        left: BorderSide(
                            color: accentColor,
                            width: 4,
                            style: BorderStyle.solid),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      // textColor: whiteColor,
                      color: (Theme.of(context).accentColor).withAlpha(70),
                      onPressed: () {
                        if (_textEditingControllerServerPath.text
                                    .trim()
                                    .length >
                                0 &&
                            _textEditingControllerLocalPath.text.trim().length >
                                0)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageGalleryWidget(
                                serverPath: MisServerUrl +
                                    "/${_textEditingControllerServerPath.text}",
                                title: _textEditingControllerLocalPath.text.split("/").last,
                                filePath: _textEditingControllerLocalPath.text,
                              ),
                            ),
                          );
                      },
                      child: Text(
                        "Upload Files",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
