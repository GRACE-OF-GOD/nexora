import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexora/models/user_model.dart';
import 'package:nexora/services/api_service.dart';
final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final authStateProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) { return AuthNotifier(ref.read(authServiceProvider)); });
class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> { final AuthService _authService; AuthNotifier(this._authService) : super(const AsyncValue.data(null));
  Future<void> login(String email, String password) async { state = const AsyncValue.loading(); try { final user = await _authService.login(email, password); state = AsyncValue.data(user); } catch (e) { state = AsyncValue.error(e, StackTrace.current); } }
  Future<void> logout() async { await _authService.logout(); state = const AsyncValue.data(null); }
}
