import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> login({required String email, required String password}) {
    return remoteDataSource.login(email: email, password: password);
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) {
    return remoteDataSource.register(name: name, email: email, password: password);
  }
}
