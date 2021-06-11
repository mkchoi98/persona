import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persona/screens/signIn/sign_in_screen.dart';

class LoginAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("로그인 필요"),
      content: Text(
        "로그인이 필요한 메뉴입니다. \n로그인 페이지로 이동할까요?",
        style: TextStyle(fontSize: 13),
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        new CupertinoDialogAction(
            child: Text(
              '다음에 할래요',
              style: TextStyle(fontSize: 15),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        new CupertinoDialogAction(
            child: Text(
              '로그인',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.pop(context);

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInScreen(),
                  ));
            }),
      ],
    );
  }
}
