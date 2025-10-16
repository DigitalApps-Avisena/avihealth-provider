import 'package:avihealth_provider/login/model/login_repository.dart';
import 'package:avihealth_provider/login/model/login_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  return LoginRepository();
});

final loginProvider = StateNotifierProvider<LoginNotifier, AsyncValue<LoginResponse?>>((ref) {
  return LoginNotifier(ref.watch(loginRepositoryProvider));
});

class LoginNotifier extends StateNotifier<AsyncValue<LoginResponse?>> {
  final LoginRepository repository;

  LoginNotifier(this.repository) : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final response = await repository.login(email, password);
      state = AsyncValue.data(response);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
