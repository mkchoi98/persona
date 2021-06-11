import 'package:flutter/material.dart';
import 'package:persona/size_config.dart';

// clolors that we use in our app
const kMainColor = Colors.white;
const kActiveColor = Color(0xFF9297FF);
const kTextColor = Color(0xFF707070);
const kBgColor = Colors.white;

// Text Styles

final TextStyle kHeadlineTextStyle = TextStyle(
  fontFamily: 'NotoSans',
  fontSize: 17,
  color: kActiveColor,
  fontWeight: FontWeight.bold,
);

final TextStyle kBodyTextStyle = TextStyle(
  fontFamily: 'NotoSans',
  fontSize: 15,
  color: kTextColor,
  fontWeight: FontWeight.w500,
  height: 1.5,
);

final TextStyle kSecondaryTextStyle = TextStyle(
  fontFamily: 'NotoSans',
  fontSize: 17,
  fontWeight: FontWeight.bold,
  color: kTextColor,
  // height: 1.5,
);

final TextStyle kButtonTextStyle = TextStyle(
  fontFamily: 'NotoSans',
  color: Colors.white,
  fontSize: 13,
  fontWeight: FontWeight.bold,
);

// padding
const double kDefaultPadding = 40.0;
final EdgeInsets kTextFieldPadding = EdgeInsets.symmetric(
  horizontal: kDefaultPadding,
  vertical: getProportionateScreenHeight(kDefaultPadding),
);
