import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persona/constants.dart';
import 'package:camera/camera.dart';

import 'components/body.dart';

List<CameraDescription> cameras;

class CameraScreen extends StatefulWidget {
  final User user;
  CameraScreen(this.user);
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController controller;
  List cameras;
  int selectedCameraIndex;
  String imgPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "측면 촬영",
            style: kHeadlineTextStyle,
          ),
          elevation: 0,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: kActiveColor,
              ),
              color: kActiveColor,
              onPressed: () => Navigator.pop(context)),
        ),
        body: Body(widget.user));
  }
}
