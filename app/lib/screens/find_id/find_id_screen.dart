import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persona/screens/signUp/sign_up_screen.dart';
import 'package:persona/widgets/buttons/primary_button.dart';
import '../../constants.dart';
import '../../size_config.dart';

class FindIDScreen extends StatefulWidget {
  @override
  _FindIDScreenState createState() => _FindIDScreenState();
}

class _FindIDScreenState extends State<FindIDScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  bool finded = false;
  bool isemail = false;
  String email = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: kActiveColor,
            ),
            color: kActiveColor,
            onPressed: () => Navigator.pop(context)),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VerticalSpacing(of: 10),
                Text(
                  "이메일 찾기",
                  textScaleFactor: 1,
                  style: TextStyle(
                      color: kActiveColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                VerticalSpacing(of: 50),
                !finded
                    ? _build1(context)
                    : isemail
                        ? _build2(context, email)
                        : _build3(context),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: !finded
                    ? PrimaryButton(
                        text: "확인",
                        press: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              FirebaseFirestore.instance
                                  .collection("User")
                                  .where('name',
                                      isEqualTo: _nameController.text)
                                  .where('phone',
                                      isEqualTo: _phoneController.text)
                                  .get()
                                  .then((value) {
                                if (value.size != 0)
                                  email = value.docs[0]['email'];
                              });
                            });
                            await Future.delayed(Duration(seconds: 1));

                            setState(() {
                              finded = true;
                              if (email != "") isemail = true;
                            });
                          }
                        })
                    : isemail
                        ? PrimaryButton(
                            text: "로그인 하기",
                            press: () {
                              Navigator.pop(context);
                            })
                        : PrimaryButton(
                            text: "회원가입 하기",
                            press: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpScreen(),
                                  ));
                            })),
          )
        ],
      ),
    );
  }

  Widget _build1(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: new BorderRadius.circular(10.0),
          ),
          child: TextFormField(
            controller: _nameController,
            style: TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: "이름을 입력해주세요.",
              hintStyle: TextStyle(color: kTextColor, fontSize: 13),
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
        VerticalSpacing(),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: new BorderRadius.circular(10.0),
          ),
          child: TextFormField(
            controller: _phoneController,
            style: TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: "전화번호을 입력해주세요.",
              hintStyle: TextStyle(color: kTextColor, fontSize: 13),
              fillColor: Colors.grey[100],
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: InputBorder.none,
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return '전화번호을 입력해주세요.';
              }
              return null;
            },
          ),
        ),
        VerticalSpacing(of: 50),
      ]),
    );
  }

  Widget _build2(BuildContext context, String myemail) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        _nameController.text + "님의 가입된 이메일",
        style: TextStyle(
            color: kTextColor,
            fontSize: 17,
            fontWeight: FontWeight.bold,
            height: 2.5),
      ),
      Text(
        myemail,
        style: TextStyle(
            color: kActiveColor, fontSize: 17, fontWeight: FontWeight.bold),
      ),
    ]);
  }

  Widget _build3(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        _nameController.text + "님은 등록된 회원이 아닙니다.",
        style: TextStyle(
            color: kTextColor,
            fontSize: 17,
            fontWeight: FontWeight.bold,
            height: 2.5),
      ),
    ]);
  }
}
