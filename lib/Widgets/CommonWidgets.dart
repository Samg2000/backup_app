import '../Controls/Constants.dart';
import 'dart:io';
import 'package:backup_app/Screen/full_screen_image_screen.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomTile extends StatelessWidget {
  final Color color;
  final String text;
  final Color textColor;
  final double padding;
  final bool left;
  final bool right;
  final bool bottom;
  final bool isRound;
  final bool top;
  final double textSize;

  // final
  const CustomTile({
    Key key,
    this.color,
    this.text,
    this.textColor,
    this.padding,
    this.left,
    this.right,
    this.bottom,
    this.top,
    this.textSize,
    this.isRound = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          (isRound == true) ? BorderRadius.circular(9) : BorderRadius.zero,
      child: Container(
        height: padding ?? 70,
        decoration: BoxDecoration(
          color: color == null
              ? Colors.blueAccent[100].withAlpha(70)
              : color.withAlpha(70),
          // color: Colors.blueAccent[100].withAlpha(70),
          // borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(
            left: (left == true)
                ? BorderSide(
                    color: color ?? accentColor,
                    style: BorderStyle.solid,
                    width: 5)
                : BorderSide.none,
            right: (right == true)
                ? BorderSide(
                    color: color ?? accentColor,
                    style: BorderStyle.solid,
                    width: 5)
                : BorderSide.none,
            bottom: (bottom == true)
                ? BorderSide(
                    color: color ?? accentColor,
                    style: BorderStyle.solid,
                    width: 5)
                : BorderSide.none,
            top: (top == true)
                ? BorderSide(
                    color: color ?? accentColor,
                    style: BorderStyle.solid,
                    width: 5)
                : BorderSide.none,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text)
              .text
              .size(textSize ?? 20)
              .color(textColor ?? Theme.of(context).textTheme.bodyText1.color)
              .makeCentered(),
        ),
      ),
    );
  }
}

class VideoBoxWidget extends StatelessWidget {
  const VideoBoxWidget({
    Key key,
    this.fsList,
    @required this.itemHeight,
    @required this.size,

    @required this.canOpen, this.canUpload, this.serverPath, this.path,
    // @required this
  }) : super(key: key);

  final bool canOpen;
  final String path;
  final FileSystemEntity fsList;
  final double itemHeight;
  final Size size;
  final bool canUpload;
  final String serverPath;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (canOpen)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FullScreenImage(
                canUpload: true,
                serverPath: serverPath,
                fileStat: fsList.statSync(),
                path: fsList.path,
              ),
            ),
          );
      },
      child: SizedBox(
        height: itemHeight - 66,
        width: size.width * 0.5,
        child: Center(
          child:((path==null)?Path.extension(fsList.path).split('.').last.toUpperCase():Path.extension(path).split('.').last.toUpperCase()).text.size(25).make(),
        ),
      ),
    );
  }
}

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTile(
              text: "Something Went Wrong",
              color: Colors.redAccent[700],
            ),
          ],
        ),
      ),
    );
  }
}

Center spinWave(BuildContext context, [double size]) => Center(
      child:
          SpinKitWave(color: Theme.of(context).accentColor, size: size ?? 35),
    );
