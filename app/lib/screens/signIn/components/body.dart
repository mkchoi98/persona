import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persona/screens/find_id/find_id_screen.dart';
import 'package:persona/screens/find_password/find_pw_screen.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../screens/signUp/sign_up_screen.dart';
import 'sign_in_form.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VerticalSpacing(of: 200),
            SignInForm(),
            VerticalSpacing(
              of: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FindIDScreen(),
                          ),
                        ),
                    child: Text(
                      "이메일 찾기",
                      textScaleFactor: 1,
                      style: TextStyle(
                          fontSize: 12,
                          color: kTextColor,
                          fontWeight: FontWeight.w500),
                    )),
                SizedBox(
                  height: 10,
                  child: VerticalDivider(
                    thickness: 1.2,
                    color: kTextColor,
                  ),
                ),
                InkWell(
                    onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FindPWScreen(),
                          ),
                        ),
                    child: Text(
                      "비밀번호 찾기",
                      textScaleFactor: 1,
                      style: TextStyle(
                          fontSize: 12,
                          color: kTextColor,
                          fontWeight: FontWeight.w500),
                    )),
                SizedBox(
                  height: 10,
                  child: VerticalDivider(
                    thickness: 1.2,
                    color: kTextColor,
                  ),
                ),
                InkWell(
                    onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ),
                        ),
                    child: Text(
                      "회원가입",
                      textScaleFactor: 1,
                      style: TextStyle(
                          fontSize: 12,
                          color: kTextColor,
                          fontWeight: FontWeight.w500),
                    )),
              ],
            ),
            VerticalSpacing(
              of: 100,
            ),
          ],
        ),
      ),
    );
  }
}
