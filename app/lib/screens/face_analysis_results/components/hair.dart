import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persona/widgets/cards/card.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class HairStyle extends StatelessWidget {
  final DocumentSnapshot data;
  HairStyle(this.data);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "이런 헤어스타일을 추천해드려요 💇🏻‍♀️",
          style: kHeadlineTextStyle,
          textScaleFactor: 1,
        ),
        VerticalSpacing(of: 10),
        StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("faceline")
                .doc(data['faceline_index'].toString())
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              return InkWellCard(
                onTap: () {},
                circular: 10,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      VerticalSpacing(),
                      Text(
                        "얼굴형에 따른 추천을 받고 싶어요! ",
                        style: kHeadlineTextStyle,
                      ),
                      VerticalSpacing(of: 20),
                      Text(
                        "Best : " + snapshot.data['best'],
                        style: kBodyTextStyle,
                      ),
                      VerticalSpacing(),
                      Text(
                        "Worst : " + snapshot.data['worst'],
                        style: kBodyTextStyle,
                      ),
                      VerticalSpacing(),
                      Text(
                        "Comment : " + snapshot.data['comment'],
                        style: kBodyTextStyle,
                      ),
                      VerticalSpacing(),
                    ],
                  ),
                ),
              );
            }),
        StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("ratio")
                .doc(data['ratio'].toString())
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              return InkWellCard(
                onTap: () {},
                circular: 10,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      VerticalSpacing(),
                      Text(
                        "상/중/하안부의 비율에 따른 추천을 받고 싶어요! ",
                        style: kHeadlineTextStyle,
                      ),
                      VerticalSpacing(of: 20),
                      Text(
                        snapshot.data['comment'],
                        style: kBodyTextStyle,
                      ),
                      VerticalSpacing(),
                    ],
                  ),
                ),
              );
            }),
        InkWellCard(
            onTap: () {},
            circular: 10,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  VerticalSpacing(),
                  Text(
                    "광대를 가릴 수 있는 추천을 받고 싶어요! ",
                    style: kHeadlineTextStyle,
                  ),
                  VerticalSpacing(of: 20),
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("cheek_side")
                          .doc(data['cheek_side'].toString())
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
                          .collection("cheek_front")
                          .doc(data['cheek_front'].toString())
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
