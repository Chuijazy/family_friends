import 'package:family_friends/autorization/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FamilyFriends());
}

class FamilyFriends extends StatelessWidget {
  const FamilyFriends({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Авторизация', home: SplashScreen());
  }
}
