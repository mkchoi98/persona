import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persona/widgets/cards/card.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class MakeupStyle extends StatelessWidget {
  final DocumentSnapshot data;
  MakeupStyle(this.data);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "이런 메이크업을 추천해드려요 💄",
          style: kHeadlineTextStyle,
          textScaleFactor: 1,
        ),
        VerticalSpacing(of: 10),
        InkWellCard(
            onTap: () {},
            circular: 10,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    "눈 메이크업 Tip! 👀",
                    style: kHeadlineTextStyle,
                  ),
                  VerticalSpacing(of: 20),
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("eyeh")
                          .doc(data['eyeh_result'].toString())
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return CircularProgressIndicator();
                        return Text(
                          snapshot.data['comment'],
                          style: kBodyTextStyle,
                        );
                      }),
                  VerticalSpacing(of: 10),
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("eyew")
                          .doc(data['eyew_result'].toString())
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return CircularProgressIndicator();
                        return Text(
                          snapshot.data['comment'],
                          style: kBodyTextStyle,
                        );
                      }),
                  VerticalSpacing(of: 10),
                  if (data['between_result'] != 0)
                    StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("between")
                            .doc(data['between_result'].toString())
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return CircularProgressIndicator();
                          return Text(
                            snapshot.data['comment'],
                            style: kBodyTextStyle,
                          );
                        }),
                ],
              ),
            )),
        InkWellCard(
            onTap: () {},
            circular: 10,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    "눈썹 모양 Tip! 🤨",
                    style: kHeadlineTextStyle,
                  ),
                  VerticalSpacing(of: 20),
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("faceline")
                          .doc(data['faceline_index'].toString())
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return CircularProgressIndicator();
                        return Text(
                          snapshot.data['eyebrow'],
                          style: kBodyTextStyle,
                        );
                      }),
                  VerticalSpacing(),
                ],
              ),
            )),
        InkWellCard(
            onTap: () {},
            circular: 10,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    "코 쉐딩 Tip! 👃🏻 ",
                    style: kHeadlineTextStyle,
                  ),
                  VerticalSpacing(of: 20),
                  if (data['nose_result'] == 1)
                    StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("nose")
                            .doc(data['nose_result'].toString())
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return CircularProgressIndicator();
                          return Text(
                            snapshot.data['makeup'],
                            style: kBodyTextStyle,
                          );
                        }),
                  VerticalSpacing(),
                  if (data['ratio'] == 2)
                    StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("ratio")
                            .doc(data['ratio'].toString())
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return CircularProgressIndicator();
                          return Text(
                            snapshot.data['contouring'],
                            style: kBodyTextStyle,
                          );
                        }),
                  VerticalSpacing(),
                ],
              ),
            )),
        VerticalSpacing(of: 20),
        InkWellCard(
            onTap: () {},
            circular: 10,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    "립 메이크업 Tip! 💋",
                    style: kHeadlineTextStyle,
                  ),
                  VerticalSpacing(of: 20),
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("lips")
                          .doc(data['lips_result'].toString())
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return CircularProgressIndicator();
                        return Text(
                          snapshot.data['comment'],
                          style: kBodyTextStyle,
                        );
                      }),
                  VerticalSpacing(),
                ],
              ),
            )),
        VerticalSpacing(of: 30),
      ],
    );
  }
}
