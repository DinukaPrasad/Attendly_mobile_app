import '../models/user_dto.dart';

class AuthRemoteDataSource {
  Future<UserDto> login({required String email, required String password}) async {
    // TODO: call API for login.
    return UserDto(id: '123', email: email);
  }

  Future<void> logout() async {
    // TODO: call API to revoke session.
  }

  Future<UserDto?> getCurrentUser() async {
    // TODO: fetch current user from remote.
    return null;
  }
}
