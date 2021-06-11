import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persona/screens/camera_front/camera_screen.dart';

import 'package:persona/widgets/buttons/primary_button.dart';

import '../../constants.dart';
import '../../size_config.dart';

class PrecautionsScreen extends StatelessWidget {
  final User user;
  PrecautionsScreen(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "촬영",
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
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                VerticalSpacing(of: 200),
                Text(
                  "촬영 전 주의사항 📸",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: kActiveColor,
                      fontSize: 19,
                      height: 2.0,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  '''

      ✔️ 페이스라인에 맞춰서 촬영해주세요
      ✔️ 앞머리, 마스크 등 얼굴을 가리지 말아주세요
      ✔️ 어두운 곳에서 촬영을 피해주세요
      
''',
                  style: TextStyle(
                      color: kActiveColor,
                      fontSize: 17,
                      height: 2.0,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                    width: 200,
                    child: PrimaryButton(
                        text: "사진 찍기",
                        press: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CameraScreen(user)))))
              ]),
        ));
  }
}
