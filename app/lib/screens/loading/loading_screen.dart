import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persona/constants.dart';
import 'package:persona/screens/face_analysis_results/face_analysis_results_screen.dart';

class LoadingScreen extends StatefulWidget {
  final User user;
  LoadingScreen(this.user);
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 21000)),
        builder: (context, snapshot) {
          // Checks whether the future is resolved, ie the duration is over
          if (snapshot.connectionState == ConnectionState.done) {
            return FaceAnanlysisScreen(widget.user);
          } else
            return Scaffold(
              body: Center(
                child: Text(
                  "분석 중입니다. 잠시만 기다려주세요😌",
                  style: TextStyle(
                      color: kActiveColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ); // Return empty container to avoid build errors
        });
  }
}
