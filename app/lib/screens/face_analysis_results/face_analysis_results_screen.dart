import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/body.dart';

class FaceAnanlysisScreen extends StatelessWidget {
  final User user;
  FaceAnanlysisScreen(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //appBar: buildAppBar(context),
      body: Body(user),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 2,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: kActiveColor,
          ),
          color: kActiveColor,
          onPressed: () => Navigator.pop(context)),
      title: Image.asset(
        "assets/icons/logo.png",
        width: 100,
      ),
    );
  }
}
