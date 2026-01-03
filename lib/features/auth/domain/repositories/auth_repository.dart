import '../entities/user.dart';

abstract class AuthRepository {
  Future<User?> getCurrentUser();
  Future<User> login({required String email, required String password});
  Future<void> logout();
}
