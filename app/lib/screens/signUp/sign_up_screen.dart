import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../size_config.dart';
import 'components/body.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: kActiveColor,
            onPressed: () => Navigator.pop(context)),
      ),
      backgroundColor: Colors.white,
      body: Body(),
    );
  }
}
