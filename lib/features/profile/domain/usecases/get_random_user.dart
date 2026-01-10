import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/user.dart';
import '../repositories/profile_repository.dart';

/// Use case for fetching a random user profile.
class GetRandomUser implements UseCaseNoParams<User> {
  final ProfileRepository _repository;

  GetRandomUser(this._repository);

  @override
  Future<Result<User>> call() {
    return _repository.getRandomUser();
  }
}
