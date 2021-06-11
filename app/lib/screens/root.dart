import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:persona/screens/bottom_nav_bar.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('root_page created');
    return _handleCurrentScreen();
  }

  Widget _handleCurrentScreen() {
    return StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // 연결 상태가 기다리는 중이라면 로딩 페이지를 반환
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            // 연결이 되어있고 데이터가 있다면
            if (snapshot.hasData) {
              return BottomNavBar(snapshot.data);
            } else {
              return BottomNavBar(snapshot.data);
            }
          }
        });
  }
}
