import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nexora/core/constants.dart';
import 'package:nexora/models/user_model.dart';
class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: AppConstants.apiBaseUrl, connectTimeout: Duration(milliseconds: AppConstants.connectTimeout), receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout)));
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  Future<UserModel> login(String email, String password) async { try { final response = await _dio.post('/login', data: {'email': email, 'password': password}); final token = response.data['token']; final user = UserModel.fromJson(response.data['user'], token); await _storage.write(key: AppConstants.tokenKey, value: token); await _storage.write(key: AppConstants.userRoleKey, value: user.role); return user; } on DioException catch (e) { if (e.response?.statusCode == 401) { throw Exception('Email ou mot de passe incorrect'); } throw Exception('Erreur de connexion. Veuillez réessayer'); } }
  Future<void> logout() async { await _storage.delete(key: AppConstants.tokenKey); await _storage.delete(key: AppConstants.userRoleKey); }
  Future<String?> getToken() async { return await _storage.read(key: AppConstants.tokenKey); }
  Future<String?> getUserRole() async { return await _storage.read(key: AppConstants.userRoleKey); }
}
