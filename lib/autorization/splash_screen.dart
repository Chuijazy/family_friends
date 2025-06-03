import 'package:family_friends/autorization/phone_auth_screen.dart';
import 'package:family_friends/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 2)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          return HomeScreen();
        } else {
          return PhoneAuthScreen();
        }
      },
    );
  }
}
