import 'package:family_friends/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FamilyFriends());
}

class FamilyFriends extends StatelessWidget {
  const FamilyFriends({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Авторизация', home: HomeScreen());
  }
}
