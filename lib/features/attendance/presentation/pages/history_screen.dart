import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/attendance.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';
import '../bloc/history_state.dart';

/// Screen for viewing attendance history.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HistoryBloc>()
        ..add(
          // TODO: Get actual user ID from auth state
          const LoadHistoryEvent(userId: 'current-user-id'),
        ),
      child: const _HistoryScreenContent(),
    );
  }
}

class _HistoryScreenContent extends StatelessWidget {
  const _HistoryScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // TODO: Get actual user ID from auth state
              context.read<HistoryBloc>().add(
                const RefreshHistoryEvent(userId: 'current-user-id'),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          return switch (state) {
            HistoryInitial() => const Center(child: Text('Loading...')),
            HistoryLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            HistoryEmpty() => _buildEmptyState(context),
            HistoryLoaded(:final attendanceList) => _buildHistoryList(
              context,
              attendanceList,
            ),
            HistoryError(:final message) => _buildErrorState(context, message),
          };
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No attendance records yet',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'Start scanning QR codes to mark attendance',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(
    BuildContext context,
    List<Attendance> attendanceList,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Get actual user ID from auth state
        context.read<HistoryBloc>().add(
          const RefreshHistoryEvent(userId: 'current-user-id'),
        );
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: attendanceList.length,
        itemBuilder: (context, index) {
          final attendance = attendanceList[index];
          return _AttendanceCard(attendance: attendance);
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text(
            'Failed to load history',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // TODO: Get actual user ID from auth state
              context.read<HistoryBloc>().add(
                const LoadHistoryEvent(userId: 'current-user-id'),
              );
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  final Attendance attendance;

  const _AttendanceCard({required this.attendance});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Status icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getStatusColor(
                  attendance.status,
                ).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getStatusIcon(attendance.status),
                color: _getStatusColor(attendance.status),
              ),
            ),
            const SizedBox(width: 16),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Session: ${attendance.sessionId}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDateTime(attendance.timestamp),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                  if (attendance.hasLocation) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${attendance.latitude?.toStringAsFixed(4)}, ${attendance.longitude?.toStringAsFixed(4)}',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Status chip
            Chip(
              label: Text(
                attendance.status.name.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: _getStatusColor(
                attendance.status,
              ).withValues(alpha: 0.2),
              labelStyle: TextStyle(color: _getStatusColor(attendance.status)),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(AttendanceStatus status) {
    return switch (status) {
      AttendanceStatus.verified => Colors.green,
      AttendanceStatus.pending => Colors.orange,
      AttendanceStatus.rejected => Colors.red,
    };
  }

  IconData _getStatusIcon(AttendanceStatus status) {
    return switch (status) {
      AttendanceStatus.verified => Icons.check_circle,
      AttendanceStatus.pending => Icons.hourglass_empty,
      AttendanceStatus.rejected => Icons.cancel,
    };
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
