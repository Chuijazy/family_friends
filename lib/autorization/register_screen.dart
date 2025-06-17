import 'dart:io';
import 'package:family_friends/autorization/login_screen.dart';
import 'package:family_friends/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _phone = TextEditingController();
  final _fullName = TextEditingController();
  String _selectedRole = 'dad';
  File? _image;

  final _authService = AuthService();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _phone.dispose();
    _fullName.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await _authService.registerUser(
        email: _email.text.trim(),
        password: _password.text.trim(),
        phone: _phone.text.trim(),
        fullName: _fullName.text.trim(),
        role: _selectedRole,
        photo: _image,
      );

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка регистрации: $e')));
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Введите email';
    final emailRegex = RegExp(
      r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)',
    );
    if (!emailRegex.hasMatch(value)) return 'Некорректный email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Введите пароль';
    if (value.length < 6) return 'Пароль должен быть не менее 6 символов';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Введите телефон';
    final phoneRegex = RegExp(r'^[0-9\-\+]{9,15}$');
    if (!phoneRegex.hasMatch(value)) return 'Некорректный номер телефона';
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return 'Введите ФИО';
    if (value.length < 3) return 'Слишком короткое имя';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Регистрация')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'example@mail.com',
                ),
                validator: _validateEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: _password,
                decoration: const InputDecoration(
                  labelText: 'Пароль',
                  hintText: 'Минимум 6 символов',
                ),
                obscureText: true,
                validator: _validatePassword,
              ),
              TextFormField(
                controller: _phone,
                decoration: const InputDecoration(
                  labelText: 'Телефон',
                  hintText: '0123456789',
                ),
                keyboardType: TextInputType.phone,
                validator: _validatePhone,
              ),
              TextFormField(
                controller: _fullName,
                decoration: const InputDecoration(
                  labelText: 'ФИО',
                  hintText: 'Иванов Иван Иванович',
                ),
                validator: _validateName,
              ),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: const [
                  DropdownMenuItem(value: 'dad', child: Text('Папа')),
                  DropdownMenuItem(value: 'mom', child: Text('Мама')),
                  DropdownMenuItem(value: 'child', child: Text('Ребёнок')),
                  DropdownMenuItem(
                    value: 'dad_child',
                    child: Text('Папа-ребёнок'),
                  ),
                  DropdownMenuItem(
                    value: 'mom_child',
                    child: Text('Мама-ребёнок'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _selectedRole = value);
                },
                decoration: const InputDecoration(labelText: 'Роль'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Загрузить фото (необязательно)'),
              ),
              if (_image != null) Image.file(_image!, height: 100),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _register,
                child: const Text('Зарегистрироваться'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text('Уже есть аккаунт? Войти'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
