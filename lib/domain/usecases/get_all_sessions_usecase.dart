import '../entities/session.dart';
import '../repositories/session_repository.dart';

class GetAllSessionsUseCase {
  final SessionRepository repository;

  const GetAllSessionsUseCase(this.repository);

  Future<List<Session>> call() {
    return repository.getAllSessions();
  }
}
