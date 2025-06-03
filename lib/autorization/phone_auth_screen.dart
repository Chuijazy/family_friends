import 'package:family_friends/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  String? verificationId;
  bool codeSent = false;

  Future<void> sendCode() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneController.text.trim(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        _goHome();
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ошибка: ${e.message}')));
      },
      codeSent: (id, _) {
        setState(() {
          verificationId = id;
          codeSent = true;
        });
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  Future<void> verifyCode() async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: codeController.text.trim(),
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      _goHome();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Неверный код')));
    }
  }

  void _goHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вход по номеру')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (!codeSent) ...[
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Введите номер'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: sendCode,
                child: const Text('Отправить код'),
              ),
            ] else ...[
              TextField(
                controller: codeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Код из SMS'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: verifyCode,
                child: const Text('Подтвердить'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
