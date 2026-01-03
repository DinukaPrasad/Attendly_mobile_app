import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Login {
  const Login(this._repository);

  final AuthRepository _repository;

  Future<User> call(String email, String password) {
    // TODO: add validation.
    return _repository.login(email: email, password: password);
  }
}
