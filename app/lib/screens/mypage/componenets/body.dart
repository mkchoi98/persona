import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persona/screens/modify_info/modify_info_screen.dart';
import 'package:persona/screens/signIn/sign_in_screen.dart';
import 'package:persona/widgets/alert.dart';
import 'package:persona/widgets/buttons/primary_button.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import '../../root.dart';

class Body extends StatefulWidget {
  final User user;
  Body(this.user);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: SizeConfig.screenWidth,
        height: 350,
        decoration: BoxDecoration(
            //borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300],
                offset: Offset(0.0, 2.0), //(x,y)
                blurRadius: 4.0,
              ),
            ]),
        child: widget.user != null
            ? Padding(
                padding: const EdgeInsets.all(30.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            VerticalSpacing(of: 70),
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: kActiveColor,
                              child: CircleAvatar(
                                radius: 49,
                                backgroundColor: Colors.white,
                              ),
                            ),
                            VerticalSpacing(
                              of: 30,
                            ),
                            Text(
                              widget.user.displayName + "님 ",
                              textScaleFactor: 1,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: kActiveColor),
                            ),
                            VerticalSpacing(),
                            Text(widget.user.email,
                                textScaleFactor: 1,
                                style: TextStyle(
                                  color: kActiveColor,
                                  fontSize: 15,
                                )),
                          ])
                    ]))
            : Padding(
                padding: const EdgeInsets.all(45.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          VerticalSpacing(
                            of: 100,
                          ),
                          Text(
                            "로그인 후 서비스를 이용할 수 있어요",
                            style: kHeadlineTextStyle,
                          ),
                          VerticalSpacing(
                            of: 30,
                          ),
                          SizedBox(
                            width: 200,
                            child: PrimaryButton(
                                text: "로그인 / 회원가입",
                                press: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignInScreen(),
                                    ))),
                          ),
                          VerticalSpacing(),
                        ]),
                  ],
                ),
              ),
      ),
      Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VerticalSpacing(of: 15),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: TextButton(
                child: Text(
                  "로그아웃",
                  style: TextStyle(color: kTextColor, fontSize: 16),
                ),
                onPressed: () {
                  if (widget.user == null)
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return LoginAlert();
                        });
                  else {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: Text(
                              "로그아웃",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            content: Text(
                              "정말 로그아웃 하시겠어요?",
                              style: TextStyle(fontSize: 13, height: 1.3),
                              textAlign: TextAlign.center,
                            ),
                            actions: <Widget>[
                              new CupertinoDialogAction(
                                  child: Text(
                                    '아니오',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  }),
                              new CupertinoDialogAction(
                                  child: Text(
                                    '예',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.popUntil(
                                        context, ModalRoute.withName('/root'));
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => RootPage()));
                                  }),
                            ],
                          );
                        });
                  }
                }),
          ),

          Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: TextButton(
                onPressed: () {
                  if (widget.user == null)
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return LoginAlert();
                        });
                  else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ModifyScreen(widget.user)));
                  }
                },
                child: Text(
                  "계정 정보 관리",
                  style: TextStyle(color: kTextColor, fontSize: 16),
                )),
          ),
          // Divider(),
          // Padding(
          //     padding: const EdgeInsets.only(left: 5.0),
          //     child: TextButton(
          //         onPressed: () {},
          //         child: Text(
          //           "   서비스 이용약관",
          //           style: TextStyle(color: kTextColor, fontSize: 16),
          //         ))),
          // Divider(),
          // Padding(
          //     padding: const EdgeInsets.only(left: 5.0),
          //     child: TextButton(
          //         onPressed: () {},
          //         child: Text(
          //           "   개인정보 이용약관",
          //           style: TextStyle(color: kTextColor, fontSize: 16),
          //         ))),
          Divider(),
          Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Ver. 1.0",
                    style: TextStyle(color: kTextColor, fontSize: 15),
                  ))),
          Divider(),
        ],
      ))
    ]);
  }
}
