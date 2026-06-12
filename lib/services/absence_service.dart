import 'package:dio/dio.dart';
import 'package:nexora/core/constants.dart';
import 'package:nexora/models/absence_model.dart';
import 'package:nexora/services/api_service.dart';

class AbsenceService {
  final Dio _dio;
  final AuthService _authService = AuthService();

  AbsenceService()
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

  Future<List<AbsenceModel>> getAbsences({
    String? idEleve,
    String? date,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final options = await _authHeaders();
      final response = await _dio.get(
        '/api/absences',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (idEleve != null) 'idEleve': idEleve,
          if (date != null) 'date': date,
        },
        options: options,
      );
      final List data = response.data['data'] ?? response.data;
      return data.map((e) => AbsenceModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<AbsenceModel> createAbsence(Map<String, dynamic> data) async {
    try {
      final options = await _authHeaders();
      final response = await _dio.post(
        '/api/absences',
        data: data,
        options: options,
      );
      return AbsenceModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<AbsenceModel> updateAbsence(String id, Map<String, dynamic> data) async {
    try {
      final options = await _authHeaders();
      final response = await _dio.put(
        '/api/absences/$id',
        data: data,
        options: options,
      );
      return AbsenceModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteAbsence(String id) async {
    try {
      final options = await _authHeaders();
      await _dio.delete(
        '/api/absences/$id',
        options: options,
      );
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
      return Exception('Absence introuvable');
    }
    if (e.type == DioExceptionType.connectionError) {
      return Exception('Impossible de contacter le serveur');
    }
    return Exception('Erreur serveur. Veuillez reessayer');
  }
}