 import 'package:dio/dio.dart';
import 'package:nexora/core/constants.dart';
import 'package:nexora/models/note_model.dart';
import 'package:nexora/services/api_service.dart';

class NoteService {
  final Dio _dio;
  final AuthService _authService = AuthService();

  NoteService()
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

  Future<List<NoteModel>> getNotes({
    String? idEleve,
    String? idMatiere,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final options = await _authHeaders();
      final response = await _dio.get(
        '/api/notes',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (idEleve != null) 'idEleve': idEleve,
          if (idMatiere != null) 'idMatiere': idMatiere,
        },
        options: options,
      );
      final List data = response.data['data'] ?? response.data;
      return data.map((e) => NoteModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<NoteModel> createNote(Map<String, dynamic> data) async {
    try {
      final options = await _authHeaders();
      final response = await _dio.post(
        '/api/notes',
        data: data,
        options: options,
      );
      return NoteModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<NoteModel> updateNote(String id, Map<String, dynamic> data) async {
    try {
      final options = await _authHeaders();
      final response = await _dio.put(
        '/api/notes/$id',
        data: data,
        options: options,
      );
      return NoteModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      final options = await _authHeaders();
      await _dio.delete(
        '/api/notes/$id',
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
      return Exception('Note introuvable');
    }
    if (e.type == DioExceptionType.connectionError) {
      return Exception('Impossible de contacter le serveur');
    }
    return Exception('Erreur serveur. Veuillez reessayer');
  }
}