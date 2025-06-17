import 'dart:io';
import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:9090/api'));

  String? _token;

  String? get token => _token;

  Future<void> registerUser({
    required String email,
    required String password,
    required String phone,
    required String fullName,
    required String role,
    File? photo,
  }) async {
    try {
      final formData = FormData.fromMap({
        'email': email,
        'password': password,
        'phone': phone,
        'fullName': fullName,
        'role': role,
        if (photo != null)
          'photo': await MultipartFile.fromFile(
            photo.path,
            filename: 'avatar.jpg',
          ),
      });

      final response = await _dio.post('/auth/register', data: formData);
      print('Успешная регистрация: ${response.data}');
    } on DioException catch (e) {
      print('Ошибка регистрации, статус: ${e.response?.statusCode}');
      print('Тело ответа: ${e.response?.data ?? e.message}');
      rethrow;
    }
  }

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['token'] != null) {
          _token = data['token'];

          _dio.options.headers['Authorization'] = 'Bearer $_token';

          print('Успешный вход, токен сохранён');
          return true;
        } else {
          print('Вход прошёл, но токен не получен');
          return false;
        }
      } else {
        print('Ошибка входа: статус ${response.statusCode}');
        return false;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        print('Неверные данные для входа');
        return false;
      }
      print('Ошибка при входе: ${e.response?.data ?? e.message}');
      rethrow;
    }
  }

  Future<Response> getProfile() async {
    if (_token == null) {
      throw Exception('Пользователь не авторизован');
    }
    return await _dio.get('/user/profile');
  }
}
