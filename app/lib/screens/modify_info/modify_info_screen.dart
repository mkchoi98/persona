import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../size_config.dart';
import 'components/body.dart';

class ModifyScreen extends StatelessWidget {
  final User user;
  ModifyScreen(this.user);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(context),
      backgroundColor: Colors.white,
      body: Body(user),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 1,
      title: Text(
        "계정 정보 관리",
        style: kHeadlineTextStyle,
      ),
      leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: kActiveColor,
          onPressed: () => Navigator.pop(context)),
    );
  }
}
