import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/datasources/session_remote_datasource.dart';
import '../../../data/repositories/session_repository_impl.dart';
import '../../../domain/entities/session.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/get_all_sessions_usecase.dart';
import '../attendance/mark_attendance_screen.dart';
import '../login/login_screen.dart';
import '../notification/notification_screen.dart';
import '../session/start_session_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool get _isLecturer =>
      (widget.user.role ?? '').toUpperCase() == 'LECTURER' ||
      (widget.user.role ?? '').toUpperCase() == 'ADMIN';

  int get _userId => int.tryParse(widget.user.id) ?? 0;

  // Session state — only used for STUDENT view
  late final GetAllSessionsUseCase _getAllSessionsUseCase =
      GetAllSessionsUseCase(SessionRepositoryImpl(SessionRemoteDataSource()));

  List<Session> _sessions = [];
  bool _isLoadingSessions = false;
  String? _sessionError;

  @override
  void initState() {
    super.initState();
    if (!_isLecturer) _fetchSessions();
  }

  Future<void> _fetchSessions() async {
    setState(() {
      _isLoadingSessions = true;
      _sessionError = null;
    });
    try {
      final sessions = await _getAllSessionsUseCase();
      setState(() => _sessions = sessions);
    } catch (e) {
      setState(
        () => _sessionError = e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) setState(() => _isLoadingSessions = false);
    }
  }

  void _goToNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotificationScreen(
          token: widget.user.token ?? '',
          userId: _userId,
        ),
      ),
    );
  }

  void _goToCreateSession() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StartSessionScreen(
          token: widget.user.token ?? '',
          userId: _userId,
        ),
      ),
    );
  }

  void _goToMarkAttendance(Session session) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MarkAttendanceScreen(
          token: widget.user.token ?? '',
          userId: _userId,
          programmeId: session.programmeId ?? 0,
        ),
      ),
    ).then((_) => _fetchSessions());
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await StorageService.clearAll();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (_) => false,
                );
              }
            },
            child: const Text('Logout', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Attendly',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              widget.user.name,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Notifications',
            onPressed: _goToNotifications,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _confirmLogout,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildWelcomeCard(),
            Expanded(
              child: _isLecturer ? _buildLecturerBody() : _buildStudentBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    final roleLabel = _isLecturer ? 'Lecturer' : 'Student';
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: Text(
              widget.user.name.isNotEmpty
                  ? widget.user.name[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome back,',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.user.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    roleLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── LECTURER body ──────────────────────────────────────────────────────────

  Widget _buildLecturerBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildCreateSessionButton(),
        ],
      ),
    );
  }

  Widget _buildCreateSessionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        icon: const Icon(Icons.add_circle_outline),
        label: const Text(
          'Create Session',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        onPressed: _goToCreateSession,
      ),
    );
  }

  // ── STUDENT body ───────────────────────────────────────────────────────────

  Widget _buildStudentBody() {
    if (_isLoadingSessions) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_sessionError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 56, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                _sessionError!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _fetchSessions,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_sessions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_available_outlined,
              size: 56,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 12),
            Text(
              'No sessions available',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'All Sessions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${_sessions.length} sessions',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _fetchSessions,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: _sessions.length,
              itemBuilder: (context, index) =>
                  _buildSessionCard(_sessions[index]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSessionCard(Session session) {
    return GestureDetector(
      onTap: () => _goToMarkAttendance(session),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
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
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (session.module != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            session.module!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(status: session.sessionStatus),
                ],
              ),
              const SizedBox(height: 12),
              _DetailRow(
                icon: Icons.person_outline,
                value: session.lecturer ?? 'N/A',
              ),
              const SizedBox(height: 6),
              _DetailRow(
                icon: Icons.location_on_outlined,
                value: session.venue ?? 'N/A',
              ),
              const SizedBox(height: 6),
              _DetailRow(
                icon: Icons.access_time,
                value: session.startTime ?? 'N/A',
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Tap to mark attendance',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: AppColors.primary.withValues(alpha: 0.8),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String? status;

  const _StatusChip({this.status});

  Color get _color {
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status?.toUpperCase() ?? 'UNKNOWN',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: _color,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String value;

  const _DetailRow({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
