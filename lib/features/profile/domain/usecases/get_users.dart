import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/user.dart';
import '../repositories/profile_repository.dart';

/// Parameters for the GetUsers use case
class GetUsersParams {
  final int count;

  const GetUsersParams({this.count = 30});
}

/// Use case for fetching a list of users.
class GetUsers implements UseCase<List<User>, GetUsersParams> {
  final ProfileRepository _repository;

  GetUsers(this._repository);

  @override
  Future<Result<List<User>>> call(GetUsersParams params) {
    return _repository.getUsers(count: params.count);
  }
}
