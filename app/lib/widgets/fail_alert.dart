import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persona/screens/precautions/precautions_screen.dart';

class FailAlert extends StatelessWidget {
  final User user;
  FailAlert(this.user);
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("인식 실패"),
      content: Text(
        "인식이 실패했습니다. 사진을 다시 촬영해주세요",
        style: TextStyle(fontSize: 13),
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        new CupertinoDialogAction(
            child: Text(
              '확인',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.pop(context);

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrecautionsScreen(user),
                  ));
            }),
      ],
    );
  }
}
