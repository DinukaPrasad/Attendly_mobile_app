import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/student.dart';
import '../repositories/profile_repository.dart';

/// Use case for fetching all students.
class GetAllStudents implements UseCaseNoParams<List<Student>> {
  final ProfileRepository _repository;

  GetAllStudents(this._repository);

  @override
  Future<Result<List<Student>>> call() {
    return _repository.getAllStudents();
  }
}
