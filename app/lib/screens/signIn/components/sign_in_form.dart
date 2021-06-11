import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persona/widgets/buttons/primary_button.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import '../../bottom_nav_bar.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "로그인",
            textScaleFactor: 1,
            style: TextStyle(
                color: kActiveColor, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          VerticalSpacing(
            of: 30,
          ),
          // Text(
          //   " 이메일",
          //   textScaleFactor: 1,
          //   style: TextStyle(
          //       fontSize: 13, fontWeight: FontWeight.bold, color: kTextColor),
          // ),
          VerticalSpacing(),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: new BorderRadius.circular(10.0),
            ),
            child: TextFormField(
              controller: _emailController,
              cursorColor: kActiveColor,
              style: kBodyTextStyle,
              decoration: InputDecoration(
                hintText: "이메일",
                hintStyle: TextStyle(
                    color: Colors.grey[500], fontWeight: FontWeight.w500),
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return '이메일을 입력해주세요.';
                }
                return null;
              },
            ),
          ),
          VerticalSpacing(of: 20),
          // Text(
          //   " 비밀번호",
          //   textScaleFactor: 1,
          //   style: TextStyle(
          //       fontSize: 13, fontWeight: FontWeight.bold, color: kTextColor),
          // ),
          // VerticalSpacing(),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: new BorderRadius.circular(10.0),
            ),
            child: TextFormField(
              controller: _passwordController,
              style: kBodyTextStyle,
              cursorColor: kActiveColor,
              decoration: InputDecoration(
                hintText: "비밀번호",
                hintStyle: TextStyle(
                    color: Colors.grey[500], fontWeight: FontWeight.w500),
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              ),
              validator: (String value) {
                if (value.isEmpty) return '비밀번호를 입력해주세요.';
                if (value.length < 6) return '6자리 이상 입력해주세요';

                return null;
              },
              obscureText: true,
            ),
          ),
          VerticalSpacing(
            of: 30,
          ),
          PrimaryButton(
            text: "로그인",
            press: () async {
              if (_formKey.currentState.validate()) {
                _signInWithEmailAndPassword().then((user) {
                  if (user != null) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BottomNavBar(user)));
                  } else {}
                });
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  showErrDialog(BuildContext context, String err) {
    return Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        err,
        textAlign: TextAlign.center,
        textScaleFactor: 1,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      ),
      backgroundColor: kActiveColor,
    ));
  }

  Future<User> _signInWithEmailAndPassword() async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
      return user;
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          showErrDialog(context, '이메일 형식이 맞지 않습니다.');
          break;
        case 'wrong-password':
          showErrDialog(context, '비밀번호가 올바르지 않습니다.');
          break;
        case 'user-not-found':
          showErrDialog(context, '가입된 이메일이 아닙니다.');
          break;
        case 'user-disabled':
          showErrDialog(context, e.code);
          break;
        case 'too-many-requests':
          showErrDialog(context, e.code);
          break;
        case 'operation-not-allowed':
          showErrDialog(context, e.code);
          break;
      }
      return null;
    } catch (e) {
      print(e);
    }
  }
}
