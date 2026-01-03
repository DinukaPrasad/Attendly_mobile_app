import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_ds.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote);

  final AuthRemoteDataSource _remote;

  @override
  Future<User?> getCurrentUser() async {
    final dto = await _remote.getCurrentUser();
    return dto?.toEntity();
  }

  @override
  Future<User> login({required String email, required String password}) async {
    final dto = await _remote.login(email: email, password: password);
    return dto.toEntity();
  }

  @override
  Future<void> logout() {
    return _remote.logout();
  }
}
