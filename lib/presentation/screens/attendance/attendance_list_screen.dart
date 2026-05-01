import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/datasources/attendance_remote_datasource.dart';
import '../../../data/repositories/attendance_repository_impl.dart';
import '../../../domain/entities/attendance.dart';
import '../../../domain/usecases/get_my_attendances_usecase.dart';
import '../../widgets/custom_button.dart';

class AttendanceListScreen extends StatefulWidget {
  final int userId;
  final String token;

  const AttendanceListScreen({
    super.key,
    required this.userId,
    required this.token,
  });

  @override
  State<AttendanceListScreen> createState() => _AttendanceListScreenState();
}

class _AttendanceListScreenState extends State<AttendanceListScreen> {
  late final GetMyAttendancesUseCase _getMyAttendancesUseCase =
      GetMyAttendancesUseCase(
        AttendanceRepositoryImpl(AttendanceRemoteDataSource()),
      );

  List<Attendance> _attendances = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAttendances();
  }

  Future<void> _fetchAttendances() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final attendances = await _getMyAttendancesUseCase(widget.userId);
      setState(() => _attendances = attendances);
    } catch (e) {
      setState(
        () => _errorMessage = e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'PRESENT':
        return const Color(0xFF4CAF50);
      case 'ABSENT':
        return AppColors.error;
      case 'LATE':
        return const Color(0xFFFFA500);
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Attendance'),
        elevation: 0,
      ),
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
                    CustomButton(label: 'Retry', onPressed: _fetchAttendances),
                  ],
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: _fetchAttendances,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_attendances.isNotEmpty) ...[
                      const Text(
                        'Previous Attendances',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._attendances.map((attendance) {
                        return _buildAttendanceCard(attendance);
                      }),
                      const SizedBox(height: 24),
                    ] else
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(
                                Icons.event_available_outlined,
                                size: 48,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'No attendance records yet',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildAttendanceCard(Attendance attendance) {
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
                        attendance.programmeName ?? 'Unknown Programme',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'User: ${attendance.userName ?? 'N/A'}',
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
                      attendance.status,
                    ).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    attendance.status?.toUpperCase() ?? 'UNKNOWN',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(attendance.status),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  attendance.time ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  attendance.createdAt ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
