import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nexora/core/constants.dart';
import 'package:nexora/models/user_model.dart';

class AuthService {
  final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: AppConstants.apiBaseUrl,
            connectTimeout:
                Duration(milliseconds: AppConstants.connectTimeout),
            receiveTimeout:
                Duration(milliseconds: AppConstants.receiveTimeout),
            headers: {'Content-Type': 'application/json'},
          ),
        );

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/login',
        data: {'email': email, 'password': password},
      );
      final token = response.data['token'];
      final user = UserModel.fromJson(response.data['user'], token);
      await _storage.write(key: AppConstants.tokenKey, value: token);
      await _storage.write(key: AppConstants.userRoleKey, value: user.role);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Email ou mot de passe incorrect');
      }
      if (e.response?.statusCode == 422) {
        throw Exception('Donnees invalides');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connexion trop lente. Verifiez votre internet');
      }
      if (e.type == DioExceptionType.connectionError) {
        throw Exception('Impossible de contacter le serveur');
      }
      throw Exception('Erreur de connexion. Veuillez reessayer');
    }
  }

  Future<void> logout() async {
    try {
      final token = await _storage.read(key: AppConstants.tokenKey);
      if (token != null) {
        await _dio.post(
          '/api/logout',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
      }
    } catch (_) {
    } finally {
      await _storage.delete(key: AppConstants.tokenKey);
      await _storage.delete(key: AppConstants.userRoleKey);
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: AppConstants.tokenKey);
  }

  Future<String?> getUserRole() async {
    return await _storage.read(key: AppConstants.userRoleKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: AppConstants.tokenKey);
    return token != null;
  }
}