import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:persona/screens/signIn/sign_in_screen.dart';
import 'package:persona/widgets/buttons/primary_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirm = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _phone = TextEditingController();

  String _userEmail;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            " 이름",
            textScaleFactor: 1,
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.bold, color: kTextColor),
          ),
          VerticalSpacing(),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: new BorderRadius.circular(10.0),
            ),
            child: TextFormField(
              style: kBodyTextStyle,
              keyboardType: TextInputType.name,
              autofocus: false,
              cursorColor: kActiveColor,
              controller: _name,
              decoration: InputDecoration(
                fillColor: Colors.grey[100],
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: InputBorder.none,
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return '이름을 입력해주세요.';
                }
                return null;
              },
            ),
          ),
          VerticalSpacing(of: 20),
          Text(
            " 이메일",
            textScaleFactor: 1,
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.bold, color: kTextColor),
          ),
          VerticalSpacing(),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: new BorderRadius.circular(10.0),
            ),
            child: TextFormField(
              style: kBodyTextStyle,
              keyboardType: TextInputType.emailAddress,
              cursorColor: kActiveColor,
              controller: _email,
              decoration: InputDecoration(
                fillColor: Colors.grey[100],
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: InputBorder.none,
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
          Text(
            " 비밀번호",
            textScaleFactor: 1,
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.bold, color: kTextColor),
          ),
          VerticalSpacing(),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: new BorderRadius.circular(10.0),
            ),
            child: TextFormField(
              style: kBodyTextStyle,
              cursorColor: kActiveColor,
              controller: _password,
              decoration: InputDecoration(
                fillColor: Colors.grey[100],
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                hintText: "6자리 이상 입력해주세요.",
                hintStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[500]),
                border: InputBorder.none,
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return '비밀번호를 입력해주세요';
                }
                if (value.length < 6) {
                  return "6자리 이상 입력해주세요";
                }
                return null;
              },
              obscureText: true,
            ),
          ),
          VerticalSpacing(of: 20),
          Text(
            " 비밀번호 확인",
            textScaleFactor: 1,
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.bold, color: kTextColor),
          ),
          VerticalSpacing(),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: new BorderRadius.circular(10.0),
            ),
            child: TextFormField(
              style: kBodyTextStyle,
              cursorColor: kActiveColor,
              controller: _confirm,
              decoration: InputDecoration(
                fillColor: Colors.grey[100],
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                hintText: "6자리 이상 입력해주세요.",
                hintStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[500]),
                border: InputBorder.none,
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return '비밀번호를 입력해주세요';
                }
                if (value != _password.text) {
                  return '비밀번호가 맞지 않습니다.';
                }
                return null;
              },
              obscureText: true,
            ),
          ),
          VerticalSpacing(of: 20),

          // Text(
          //   " 핸드폰 번호",
          //   textScaleFactor: 1,
          //   style: TextStyle(
          //       fontSize: 13, fontWeight: FontWeight.bold, color: kTextColor),
          // ),
          // VerticalSpacing(),
          // Container(
          //   decoration: BoxDecoration(
          //     color: Colors.grey[200],
          //     borderRadius: new BorderRadius.circular(10.0),
          //   ),
          //   child: TextFormField(
          //     controller: _phone,
          //     style: TextStyle(fontSize: 15),
          //     cursorColor: kActiveColor,
          //     decoration: InputDecoration(
          //       hintText: "숫자만 입력해주세요",
          //       hintStyle: TextStyle(
          //           fontSize: 14,
          //           fontWeight: FontWeight.w500,
          //           color: Colors.grey[500]),
          //       fillColor: Colors.grey[100],
          //       contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          //       border: InputBorder.none,
          //     ),
          //     validator: (String value) {
          //       if (value.isEmpty) {
          //         return '핸드폰 번호를 입력해주세요';
          //       }
          //       return null;
          //     },
          //   ),
          // ),

          // VerticalSpacing(of: 20),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Row(
          //       children: [
          //         HorizontalSpacing(of: 5),
          //         Center(
          //           child: InkWell(
          //               onTap: () {
          //                 setState(() {
          //                   _value1 = !_value1;
          //                 });
          //               },
          //               child: _value1
          //                   ? CircleAvatar(
          //                       backgroundColor: kActiveColor,
          //                       radius: 7,
          //                     )
          //                   : CircleAvatar(
          //                       backgroundColor: Colors.grey[300],
          //                       radius: 7,
          //                     )),
          //         ),
          //        HorizontalSpacing(of: 8),
          //         Text(
          //           "이용약관 동의",
          //           textScaleFactor: 1,
          //           style: TextStyle(
          //               fontSize: 12,
          //               color: kTextColor,
          //               fontWeight: FontWeight.w600),
          //         ),
          //       ],
          //     ),
          //     SizedBox(
          //       height: 30,
          //       child: IconButton(
          //         icon: SvgPicture.asset("assets/icons/arrow_next.svg"),
          //         onPressed: () {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => ServicePolicyScreen(),
          //             ),
          //           );
          //         },
          //       ),
          //     ),
          //   ],
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Row(
          //       children: [
          //         HorizontalSpacing(of: 5),
          //         Center(
          //           child: InkWell(
          //               onTap: () {
          //                 setState(() {
          //                   _value2 = !_value2;
          //                 });
          //               },
          //               child: _value2
          //                   ? CircleAvatar(
          //                       backgroundColor: kActiveColor,
          //                       radius: 7,
          //                     )
          //                   : CircleAvatar(
          //                       backgroundColor: Colors.grey[300],
          //                       radius: 7,
          //                     )),
          //         ),
          //         HorizontalSpacing(of: 8),
          //         Text(
          //           "개인정보 취급방침 동의",
          //           textScaleFactor: 1,
          //           style: TextStyle(
          //               fontSize: 12,
          //               color: kBodyTextColor,
          //               fontWeight: FontWeight.w600),
          //         ),
          //       ],
          //     ),
          //     SizedBox(
          //       height: 30,
          //       child: IconButton(
          //         icon: SvgPicture.asset("assets/icons/arrow_next.svg"),
          //         onPressed: () {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => PrivacyPolicyScreen(),
          //             ),
          //           );
          //         },
          //       ),
          //     )
          //   ],
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Row(
          //       children: [
          //         HorizontalSpacing(of: 5),
          //         Center(
          //           child: InkWell(
          //               onTap: () {
          //                 setState(() {
          //                   _value3 = !_value3;
          //                 });
          //               },
          //               child: _value3
          //                   ? CircleAvatar(
          //                       backgroundColor: kActiveColor,
          //                       radius: 7,
          //                     )
          //                   : CircleAvatar(
          //                       backgroundColor: Colors.grey[300],
          //                       radius: 7,
          //                     )),
          //         ),
          //         HorizontalSpacing(of: 8),
          //         Text(
          //           "마케팅 정보 수신 동의 (선택)",
          //           textScaleFactor: 1,
          //           style: TextStyle(
          //               fontSize: 12,
          //               color: kBodyTextColor,
          //               fontWeight: FontWeight.w600),
          //         ),
          //       ],
          //     ),
          //     SizedBox(
          //       height: 30,
          //     )
          //   ],
          // ),
          VerticalSpacing(of: 30),
          Center(
              child: PrimaryButton(
                  text: "가입하기",
                  press: () async {
                    if (_formKey.currentState.validate()) {
                      _register().then((User user) {
                        if (user != null) {
                          _userEmail = user.email;
                          user.updateProfile(
                              displayName: _name.text, photoURL: null);
                          FirebaseFirestore.instance
                              .collection("User")
                              .doc(_email.text)
                              .set({
                            'name': _name.text,
                            'email': _email.text,
                          });
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  content: Text(
                                    "회원가입을 축하드립니다!",
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: <Widget>[
                                    new CupertinoDialogAction(
                                        child: Text(
                                          '확인',
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        onPressed: () =>
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignInScreen(),
                                                ))),
                                  ],
                                );
                              });
                        }
                      });
                    }
                  })),
        ],
      ),
    );
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

  Future<User> _register() async {
    try {
      final User user = (await _auth.createUserWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      ))
          .user;
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showErrDialog(context, "비밀번호가 취약합니다.");
      } else if (e.code == 'email-already-in-use') {
        showErrDialog(context, "이미 존재하는 계정입니다. 다른 이메일을 입력해주세요.");
      }
    } catch (e) {
      print(e);
    }
  }
}
