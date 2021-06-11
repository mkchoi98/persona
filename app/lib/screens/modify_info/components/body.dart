import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Body extends StatefulWidget {
  final User user;
  Body(this.user);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("User")
            .doc(widget.user.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              VerticalSpacing(of: 15),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Text(
                      "이름",
                      textScaleFactor: 1,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: kActiveColor),
                    ),
                    HorizontalSpacing(of: 30),
                    Text(
                      widget.user.displayName,
                      textScaleFactor: 1,
                      style: TextStyle(
                          fontSize: 15,
                          //fontWeight: FontWeight.w500,
                          color: kTextColor),
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Text(
                      "핸드폰 번호",
                      textScaleFactor: 1,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: kActiveColor),
                    ),
                    HorizontalSpacing(of: 30),
                    Text(
                      snapshot.data['phone'],
                      textScaleFactor: 1,
                      style: TextStyle(
                          fontSize: 15,
                          //fontWeight: FontWeight.w500,
                          color: kTextColor),
                    ),
                    HorizontalSpacing(of: 120),
                    InkWell(
                      child: Text(
                        "변경",
                        style: kSecondaryTextStyle,
                      ),
                      onTap: () {},
                    )
                  ],
                ),
              ),
              Divider(),
              VerticalSpacing(of: 50),
            ],
          );
        });
  }
}
