import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../widgets/attendance_stats_card.dart';
import '../../../auth/injection.dart';
import '../widgets/attendance_request_card.dart';
import '../widgets/attendance_request_list.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/university_header.dart';

/// The main home screen displayed after successful login.
///
/// This screen shows:
/// - A personalized app bar with the user's name
/// - University branding header
/// - Quick action buttons for common tasks
/// - Recent attendance requests
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeScreenContent();
  }
}

class _HomeScreenContent extends StatefulWidget {
  const _HomeScreenContent();

  @override
  State<_HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent> {
  // Mock data for demonstration - will be replaced with real data
  late List<AttendanceRequest> _mockRequests;

  @override
  void initState() {
    super.initState();
    _initMockData();
  }

  void _initMockData() {
    final now = DateTime.now();

    _mockRequests = [
      AttendanceRequest(
        id: '1',
        courseName: 'Data Structures & Algorithms',
        sessionInfo: 'Lecture - Week 12',
        date: now,
        status: AttendanceRequestStatus.pending,
        lecturerName: 'Dr. Sarah Johnson',
      ),
      AttendanceRequest(
        id: '2',
        courseName: 'Database Management Systems',
        sessionInfo: 'Lab Session 8',
        date: now.subtract(const Duration(days: 1)),
        status: AttendanceRequestStatus.approved,
        lecturerName: 'Prof. Michael Chen',
      ),
      AttendanceRequest(
        id: '3',
        courseName: 'Software Engineering',
        sessionInfo: 'Tutorial - Group A',
        date: now.subtract(const Duration(days: 2)),
        status: AttendanceRequestStatus.approved,
        lecturerName: 'Dr. Emily Williams',
      ),
      AttendanceRequest(
        id: '4',
        courseName: 'Computer Networks',
        sessionInfo: 'Lecture - Week 11',
        date: now.subtract(const Duration(days: 5)),
        status: AttendanceRequestStatus.rejected,
        lecturerName: 'Prof. James Brown',
      ),
    ];
  }

  /// Get the current user's display name from Firebase Auth.
  String get _userName {
    final user = AuthDI.firebaseAuthService.currentUser;
    if (user != null) {
      // Prefer display name, then email prefix, then fallback
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        // Get first name only for cleaner greeting
        return user.displayName!.split(' ').first;
      }
      if (user.email != null && user.email!.isNotEmpty) {
        return user.email!.split('@').first;
      }
    }
    return 'Student';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        userName: _userName,
        onNotificationTap: _handleNotificationTap,
        onSettingsTap: _handleSettingsTap,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // University Header Section with entrance animation
              const UniversityHeader(
                    universityName: 'University of Technology',
                    logoAssetPath: 'assets/icons/attendly_main_icon.png',
                  )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: -0.1, duration: 400.ms),

              // Attendance Stats Chart
              const AttendanceStatsCard()
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 100.ms)
                  .slideY(begin: 0.1, duration: 400.ms, delay: 100.ms),

              Gap(16.h),

              // Quick Actions with staggered animation
              QuickActionsRow(
                    onScanTap: _handleScanTap,
                    onHistoryTap: _handleHistoryTap,
                    onProfileTap: _handleProfileTap,
                  )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 200.ms)
                  .slideY(begin: 0.1, duration: 400.ms, delay: 200.ms),

              Gap(24.h),

              // Attendance Requests Section
              AttendanceRequestList(
                    requests: _mockRequests,
                    onRequestTap: _handleRequestTap,
                  )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 300.ms)
                  .slideY(begin: 0.1, duration: 400.ms, delay: 300.ms),

              // Bottom padding for safe area
              Gap(32.h),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    // TODO: Implement actual data refresh
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _initMockData();
      });
    }
  }

  void _handleNotificationTap() {
    context.push(AppRoutes.notifications);
  }

  void _handleSettingsTap() {
    context.push(AppRoutes.settings);
  }

  void _handleScanTap() {
    context.push(AppRoutes.scan);
  }

  void _handleHistoryTap() {
    context.push(AppRoutes.history);
  }

  void _handleProfileTap() {
    context.push(AppRoutes.profile);
  }

  void _handleRequestTap(AttendanceRequest request) {
    // TODO: Navigate to request details
    AppSnackbar.showInfo(
      context,
      title: 'Viewing Request',
      message: 'Viewing: ${request.courseName}',
    );
  }
}
