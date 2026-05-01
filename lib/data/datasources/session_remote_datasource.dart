import '../models/session_model.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';

class SessionRemoteDataSource {
  final ApiClient _apiClient;

  SessionRemoteDataSource({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<List<SessionModel>> getAllSessions() async {
    final data = await _apiClient.get(ApiConstants.sessions);
    final List<dynamic> sessionList = data is List ? data : data['data'] ?? [];
    return sessionList
        .map(
          (session) => SessionModel.fromJson(session as Map<String, dynamic>),
        )
        .toList();
  }

  Future<SessionModel> createSession(Map<String, dynamic> sessionData) async {
    final response = await _apiClient.post(
      ApiConstants.sessions,
      body: sessionData,
    );
    // Backend wraps response in ApiResponse<SessionResponse> — extract data.
    final data = response['data'] as Map<String, dynamic>? ?? response;
    return SessionModel.fromJson(data);
  }
}
