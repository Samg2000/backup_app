import 'package:backup_app/Controls/Constants.dart';
import 'package:backup_app/Widgets/CommonWidgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class ChangeIpAddress extends StatefulWidget {
  static const String route = "ChangeIpAddress";
  static const SizedBox _sizedBox = const SizedBox(
    height: 10,
  );

  @override
  _ChangeIpAddressState createState() => _ChangeIpAddressState();
}

class _ChangeIpAddressState extends State<ChangeIpAddress> {
  final TextEditingController _textEditingController =
      TextEditingController(text: serverUrl);
  bool isSavingToStorage = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SizedBox()
              .box
              .size(size.width, size.height)
              .color(accentColor)
              .make(),
          "Change IP Address"
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
                  ChangeIpAddress._sizedBox,
                  ChangeIpAddress._sizedBox,
                  ChangeIpAddress._sizedBox,
                  ChangeIpAddress._sizedBox,
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      controller: _textEditingController,
                    ),
                  ),
                  ChangeIpAddress._sizedBox,
                  ChangeIpAddress._sizedBox,
                  ChangeIpAddress._sizedBox,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: FlatButton(
                      shape: (isSavingToStorage)
                          ? RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9))
                          : Border(
                              left: BorderSide(
                                  color: accentColor,
                                  width: 4,
                                  style: BorderStyle.solid),
                            ),
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      // textColor: whiteColor,
                      color: (Theme.of(context).accentColor)
                          .withAlpha((isSavingToStorage) ? 255 : 70),
                      onPressed: () async {
                        setState(() {
                          isSavingToStorage = true;
                        });
                        final isSuccess = await changeAddress(
                            newIpAddress: _textEditingController.text);
                        if (isSuccess) serverUrl = _textEditingController.text;
                        setState(() {
                          isSavingToStorage = false;
                        });
                      },
                      child: (isSavingToStorage)
                          ? CircularProgressIndicator(
                              backgroundColor: whiteColor)
                          : Text(
                              "Change Address",
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTile(
                color: Colors.deepOrangeAccent[400],
                text: "Current IP: $serverUrl",
                left: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future changeAddress({String newIpAddress}) async {
    try {
      SharedPreferences _sharedPreferences =
          await SharedPreferences.getInstance();
      return await _sharedPreferences.setString(ipString, newIpAddress);
    } catch (e) {
      throw Exception(e);
    }
  }
}
