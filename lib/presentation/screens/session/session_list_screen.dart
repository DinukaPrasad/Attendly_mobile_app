import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/datasources/session_remote_datasource.dart';
import '../../../data/repositories/session_repository_impl.dart';
import '../../../domain/entities/session.dart';
import '../../../domain/usecases/get_all_sessions_usecase.dart';
import '../../widgets/custom_button.dart';
import '../attendance/mark_attendance_screen.dart';
import 'start_session_screen.dart';

class SessionListScreen extends StatefulWidget {
  final String token;
  final int userId;
  final String role;

  const SessionListScreen({
    super.key,
    required this.token,
    required this.userId,
    required this.role,
  });

  @override
  State<SessionListScreen> createState() => _SessionListScreenState();
}

class _SessionListScreenState extends State<SessionListScreen> {
  late final GetAllSessionsUseCase _getAllSessionsUseCase =
      GetAllSessionsUseCase(SessionRepositoryImpl(SessionRemoteDataSource()));

  List<Session> _sessions = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchSessions();
  }

  Future<void> _fetchSessions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final sessions = await _getAllSessionsUseCase();
      setState(() => _sessions = sessions);
    } catch (e) {
      setState(
        () => _errorMessage = e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onStartSession() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            StartSessionScreen(token: widget.token, userId: widget.userId),
      ),
    ).then((_) => _fetchSessions());
  }

  void _onMarkAttendance(int sessionId, int programmeId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MarkAttendanceScreen(
          token: widget.token,
          userId: widget.userId,
          programmeId: programmeId,
        ),
      ),
    ).then((_) => _fetchSessions());
  }

  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'SCHEDULED':
        return AppColors.primary;
      case 'ONGOING':
        return const Color(0xFF4CAF50);
      case 'COMPLETED':
        return AppColors.textSecondary;
      default:
        return AppColors.textHint;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Sessions'),
        elevation: 0,
      ),
      floatingActionButton: widget.role.toUpperCase() == 'LECTURER'
          ? FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: _onStartSession,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : _errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: AppColors.error),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomButton(label: 'Retry', onPressed: _fetchSessions),
                  ],
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: _fetchSessions,
              child: _sessions.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_available_outlined,
                              size: 48,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No sessions available',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _sessions.length,
                      itemBuilder: (context, index) {
                        return _buildSessionCard(_sessions[index]);
                      },
                    ),
            ),
    );
  }

  Widget _buildSessionCard(Session session) {
    final isOngoing = session.sessionStatus?.toUpperCase() == 'ONGOING';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.title ?? 'Unknown Session',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        session.module ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(
                      session.sessionStatus,
                    ).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    session.sessionStatus?.toUpperCase() ?? 'UNKNOWN',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(session.sessionStatus),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.person, session.lecturer ?? 'N/A'),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.location_on, session.venue ?? 'N/A'),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.access_time, session.startTime ?? 'N/A'),
            if (isOngoing && widget.role.toUpperCase() == 'STUDENT') ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => _onMarkAttendance(
                    session.id ?? 0,
                    session.programmeId ?? 0,
                  ),
                  child: const Text(
                    'Mark Attendance',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
