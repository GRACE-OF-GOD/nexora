import 'package:dio/dio.dart';
import 'package:nexora/core/constants.dart';
import 'package:nexora/models/bulletin_model.dart';
import 'package:nexora/services/api_service.dart';

class BulletinService {
  final Dio _dio;
  final AuthService _authService = AuthService();

  BulletinService()
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

  Future<Options> _authHeaders() async {
    final token = await _authService.getToken();
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  Future<List<BulletinModel>> getBulletins({
    String? idEleve,
    int? trimestre,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final options = await _authHeaders();
      final response = await _dio.get(
        '/api/bulletins',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (idEleve != null) 'idEleve': idEleve,
          if (trimestre != null) 'trimestre': trimestre,
        },
        options: options,
      );
      final List data = response.data['data'] ?? response.data;
      return data.map((e) => BulletinModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<BulletinModel> getBulletin(String id) async {
    try {
      final options = await _authHeaders();
      final response = await _dio.get(
        '/api/bulletins/$id',
        options: options,
      );
      return BulletinModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<BulletinModel> genererBulletin(Map<String, dynamic> data) async {
    try {
      final options = await _authHeaders();
      final response = await _dio.post(
        '/api/bulletins',
        data: data,
        options: options,
      );
      return BulletinModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response?.statusCode == 401) {
      return Exception('Session expiree. Reconnectez-vous');
    }
    if (e.response?.statusCode == 403) {
      return Exception('Acces refuse');
    }
    if (e.response?.statusCode == 404) {
      return Exception('Bulletin introuvable');
    }
    if (e.type == DioExceptionType.connectionError) {
      return Exception('Impossible de contacter le serveur');
    }
    return Exception('Erreur serveur. Veuillez reessayer');
  }
}