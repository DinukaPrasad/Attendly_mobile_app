import '../entities/session.dart';
import '../repositories/session_repository.dart';

class CreateSessionUseCase {
  final SessionRepository repository;

  const CreateSessionUseCase(this.repository);

  Future<Session> call(Map<String, dynamic> sessionData) {
    return repository.createSession(sessionData);
  }
}
